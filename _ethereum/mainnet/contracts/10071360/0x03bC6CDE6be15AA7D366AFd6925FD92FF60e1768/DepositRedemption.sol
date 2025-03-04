/*
 Authored by Satoshi Nakamoto 🤪
*/

pragma solidity 0.5.17;

import "./BTCUtils.sol";
import "./BytesLib.sol";
import "./ValidateSPV.sol";
import "./CheckBitcoinSigs.sol";
import "./IERC721.sol";
import "./SafeMath.sol";
import "./IBondedECDSAKeep.sol";
import "./DepositUtils.sol";
import "./DepositStates.sol";
import "./OutsourceDepositLogging.sol";
import "./TBTCConstants.sol";
import "./TBTCToken.sol";
import "./DepositLiquidation.sol";

library DepositRedemption {

    using SafeMath for uint256;
    using CheckBitcoinSigs for bytes;
    using BytesLib for bytes;
    using BTCUtils for bytes;
    using ValidateSPV for bytes;
    using ValidateSPV for bytes32;

    using DepositUtils for DepositUtils.Deposit;
    using DepositStates for DepositUtils.Deposit;
    using DepositLiquidation for DepositUtils.Deposit;
    using OutsourceDepositLogging for DepositUtils.Deposit;

    /// @notice     Pushes signer fee to the Keep group by transferring it to the Keep address.
    /// @dev        Approves the keep contract, then expects it to call transferFrom.
    function distributeSignerFee(DepositUtils.Deposit storage _d) internal {
        IBondedECDSAKeep _keep = IBondedECDSAKeep(_d.keepAddress);

        _d.tbtcToken.approve(_d.keepAddress, _d.signerFee());
        _keep.distributeERC20Reward(address(_d.tbtcToken), _d.signerFee());
    }

    /// @notice Approves digest for signing by a keep.
    /// @dev Calls given keep to sign the digest. Records a current timestamp
    /// for given digest.
    /// @param _digest Digest to approve.
    function approveDigest(DepositUtils.Deposit storage _d, bytes32 _digest) internal {
        IBondedECDSAKeep(_d.keepAddress).sign(_digest);

        _d.approvedDigests[_digest] = block.timestamp;
    }

    /// @notice Handles TBTC requirements for redemption.
    /// @dev Burns or transfers depending on term and supply-peg impact.
    function performRedemptionTBTCTransfers(DepositUtils.Deposit storage _d) internal {
        address tdtHolder = _d.depositOwner();
        address vendingMachineAddress = _d.vendingMachineAddress;

        uint256 tbtcLot = _d.lotSizeTbtc();
        uint256 signerFee = _d.signerFee();
        uint256 tbtcOwed = _d.getRedemptionTbtcRequirement(_d.redeemerAddress);

        // if we owe 0 TBTC, msg.sender is TDT holder and FRT holder.
        if(tbtcOwed == 0){
            return;
        }
        // if we owe > 0 & < signerfee, msg.sender is TDT holder but not FRT holder.
        if(tbtcOwed <= signerFee){
            _d.tbtcToken.transferFrom(msg.sender, address(this), tbtcOwed);
            return;
        }
        // Redemmer always owes a full TBTC for at-term redemption.
        if(tbtcOwed == tbtcLot){
            // the TDT holder has exclusive redemption rights to a UXTO up until the deposit’s term.
            // At that point, we open it up so anyone may redeem it.
            // As compensation, the TDT holder is reimbursed in TBTC
            // Vending Machine-owned TDTs have been used to mint TBTC,
            // and we should always burn a full TBTC to redeem the deposit.
            if(tdtHolder == vendingMachineAddress){
                _d.tbtcToken.burnFrom(msg.sender, tbtcLot);
            }
            // if signer fee is not escrowed, escrow and it here and send the rest to TDT holder
            else if(_d.tbtcToken.balanceOf(address(this)) < signerFee){
                _d.tbtcToken.transferFrom(msg.sender, address(this), signerFee);
                _d.tbtcToken.transferFrom(msg.sender, tdtHolder, tbtcLot.sub(signerFee));
            }
            // tansfer a full TBTC to TDT holder if signerFee is escrowed
            else{
                _d.tbtcToken.transferFrom(msg.sender, tdtHolder, tbtcLot);
            }
            return;
        }
        revert("tbtcOwed value must be 0, SignerFee, or a full TBTC");
    }

    function _requestRedemption(
        DepositUtils.Deposit storage _d,
        bytes8 _outputValueBytes,
        bytes memory _redeemerOutputScript,
        address payable _redeemer
    ) internal {
        require(_d.inRedeemableState(), "Redemption only available from Active or Courtesy state");
        require(_redeemerOutputScript.length > 0, "cannot send value to zero output script");

        // set redeemerAddress early to enable direct access by other functions
        _d.redeemerAddress = _redeemer;

        performRedemptionTBTCTransfers(_d);

        // Convert the 8-byte LE ints to uint256
        uint256 _outputValue = abi.encodePacked(_outputValueBytes).reverseEndianness().bytesToUint();
        uint256 _requestedFee = _d.utxoSize().sub(_outputValue);
        require(_requestedFee >= TBTCConstants.getMinimumRedemptionFee(), "Fee is too low");

        // Calculate the sighash
        bytes32 _sighash = CheckBitcoinSigs.wpkhSpendSighash(
            _d.utxoOutpoint,
            _d.signerPKH(),
            _d.utxoSizeBytes,
            _outputValueBytes,
            _redeemerOutputScript);

        // write all request details
        _d.redeemerOutputScript = _redeemerOutputScript;
        _d.initialRedemptionFee = _requestedFee;
        _d.latestRedemptionFee = _requestedFee;
        _d.withdrawalRequestTime = block.timestamp;
        _d.lastRequestedDigest = _sighash;

        approveDigest(_d, _sighash);

        _d.setAwaitingWithdrawalSignature();
        _d.logRedemptionRequested(
            _redeemer,
            _sighash,
            _d.utxoSize(),
            _redeemerOutputScript,
            _requestedFee,
            _d.utxoOutpoint);
    }

    /// @notice                     Anyone can request redemption as long as they can.
    ///                             approve the TDT transfer to the final recipient.
    /// @dev                        The redeemer specifies details about the Bitcoin redemption tx and pays for the redemption
    ///                             on behalf of _finalRecipient.
    /// @param  _d                  Deposit storage pointer.
    /// @param  _outputValueBytes   The 8-byte LE output size.
    /// @param  _redeemerOutputScript The redeemer's length-prefixed output script.
    /// @param  _finalRecipient     The address to receive the TDT and later be recorded as deposit redeemer.
    function transferAndRequestRedemption(
        DepositUtils.Deposit storage _d,
        bytes8 _outputValueBytes,
        bytes memory _redeemerOutputScript,
        address payable _finalRecipient
    ) public {
        _d.tbtcDepositToken.transferFrom(msg.sender, _finalRecipient, uint256(address(this)));

        _requestRedemption(_d, _outputValueBytes, _redeemerOutputScript, _finalRecipient);
    }

    /// @notice                     Only TDT holder can request redemption,
    ///                             unless Deposit is expired or in COURTESY_CALL.
    /// @dev                        The redeemer specifies details about the Bitcoin redemption transaction.
    /// @param  _d                  Deposit storage pointer.
    /// @param  _outputValueBytes   The 8-byte LE output size.
    /// @param  _redeemerOutputScript The redeemer's length-prefixed output script.
    function requestRedemption(
        DepositUtils.Deposit storage _d,
        bytes8 _outputValueBytes,
        bytes memory _redeemerOutputScript
    ) public {
        _requestRedemption(_d, _outputValueBytes, _redeemerOutputScript, msg.sender);
    }

    /// @notice     Anyone may provide a withdrawal signature if it was requested.
    /// @dev        The signers will be penalized if this (or provideRedemptionProof) is not called.
    /// @param  _d  Deposit storage pointer.
    /// @param  _v  Signature recovery value.
    /// @param  _r  Signature R value.
    /// @param  _s  Signature S value. Should be in the low half of secp256k1 curve's order.
    function provideRedemptionSignature(
        DepositUtils.Deposit storage _d,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public {
        require(_d.inAwaitingWithdrawalSignature(), "Not currently awaiting a signature");

        // If we're outside of the signature window, we COULD punish signers here
        // Instead, we consider this a no-harm-no-foul situation.
        // The signers have not stolen funds. Most likely they've just inconvenienced someone

        // Validate `s` value for a malleability concern described in EIP-2.
        // Only signatures with `s` value in the lower half of the secp256k1
        // curve's order are considered valid.
        require(
            uint256(_s) <=
                0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
            "Malleable signature - s should be in the low half of secp256k1 curve's order"
        );

        // The signature must be valid on the pubkey
        require(
            _d.signerPubkey().checkSig(
                _d.lastRequestedDigest,
                _v, _r, _s
            ),
            "Invalid signature"
        );

        // A signature has been provided, now we wait for fee bump or redemption
        _d.setAwaitingWithdrawalProof();
        _d.logGotRedemptionSignature(
            _d.lastRequestedDigest,
            _r,
            _s);

    }

    /// @notice                             Anyone may notify the contract that a fee bump is needed.
    /// @dev                                This sends us back to AWAITING_WITHDRAWAL_SIGNATURE.
    /// @param  _d                          Deposit storage pointer.
    /// @param  _previousOutputValueBytes   The previous output's value.
    /// @param  _newOutputValueBytes        The new output's value.
    /// @return                             True if successful, False if prevented by timeout, otherwise revert.
    function increaseRedemptionFee(
        DepositUtils.Deposit storage _d,
        bytes8 _previousOutputValueBytes,
        bytes8 _newOutputValueBytes
    ) public returns (bool) {
        require(_d.inAwaitingWithdrawalProof(), "Fee increase only available after signature provided");
        require(block.timestamp >= _d.withdrawalRequestTime.add(TBTCConstants.getIncreaseFeeTimer()), "Fee increase not yet permitted");

        uint256 _newOutputValue = checkRelationshipToPrevious(_d, _previousOutputValueBytes, _newOutputValueBytes);
        _d.latestRedemptionFee = _newOutputValue;
        // Calculate the next sighash
        bytes32 _sighash = CheckBitcoinSigs.wpkhSpendSighash(
            _d.utxoOutpoint,
            _d.signerPKH(),
            _d.utxoSizeBytes,
            _newOutputValueBytes,
            _d.redeemerOutputScript);

        // Ratchet the signature and redemption proof timeouts
        _d.withdrawalRequestTime = block.timestamp;
        _d.lastRequestedDigest = _sighash;

        approveDigest(_d, _sighash);

        // Go back to waiting for a signature
        _d.setAwaitingWithdrawalSignature();
        _d.logRedemptionRequested(
            msg.sender,
            _sighash,
            _d.utxoSize(),
            _d.redeemerOutputScript,
            _d.utxoSize().sub(_newOutputValue),
            _d.utxoOutpoint);
    }

    function checkRelationshipToPrevious(
        DepositUtils.Deposit storage _d,
        bytes8 _previousOutputValueBytes,
        bytes8 _newOutputValueBytes
    ) public view returns (uint256 _newOutputValue){

        // Check that we're incrementing the fee by exactly the redeemer's initial fee
        uint256 _previousOutputValue = DepositUtils.bytes8LEToUint(_previousOutputValueBytes);
        _newOutputValue = DepositUtils.bytes8LEToUint(_newOutputValueBytes);
        require(_previousOutputValue.sub(_newOutputValue) == _d.initialRedemptionFee, "Not an allowed fee step");

        // Calculate the previous one so we can check that it really is the previous one
        bytes32 _previousSighash = CheckBitcoinSigs.wpkhSpendSighash(
            _d.utxoOutpoint,
            _d.signerPKH(),
            _d.utxoSizeBytes,
            _previousOutputValueBytes,
            _d.redeemerOutputScript);
        require(
            _d.wasDigestApprovedForSigning(_previousSighash) == _d.withdrawalRequestTime,
            "Provided previous value does not yield previous sighash"
        );
    }

    /// @notice                 Anyone may provide a withdrawal proof to prove redemption.
    /// @dev                    The signers will be penalized if this is not called.
    /// @param  _d              Deposit storage pointer.
    /// @param  _txVersion      Transaction version number (4-byte LE).
    /// @param  _txInputVector  All transaction inputs prepended by the number of inputs encoded as a VarInt, max 0xFC(252) inputs.
    /// @param  _txOutputVector All transaction outputs prepended by the number of outputs encoded as a VarInt, max 0xFC(252) outputs.
    /// @param  _txLocktime     Final 4 bytes of the transaction.
    /// @param  _merkleProof    The merkle proof of inclusion of the tx in the bitcoin block.
    /// @param  _txIndexInBlock The index of the tx in the Bitcoin block (0-indexed).
    /// @param  _bitcoinHeaders An array of tightly-packed bitcoin headers.
    function provideRedemptionProof(
        DepositUtils.Deposit storage _d,
        bytes4 _txVersion,
        bytes memory _txInputVector,
        bytes memory _txOutputVector,
        bytes4 _txLocktime,
        bytes memory _merkleProof,
        uint256 _txIndexInBlock,
        bytes memory _bitcoinHeaders
    ) public {
        bytes32 _txid;
        uint256 _fundingOutputValue;

        require(_d.inRedemption(), "Redemption proof only allowed from redemption flow");

        _fundingOutputValue = redemptionTransactionChecks(_d, _txInputVector, _txOutputVector);

        _txid = abi.encodePacked(_txVersion, _txInputVector, _txOutputVector, _txLocktime).hash256();
        _d.checkProofFromTxId(_txid, _merkleProof, _txIndexInBlock, _bitcoinHeaders);

        require((_d.utxoSize().sub(_fundingOutputValue)) <= _d.latestRedemptionFee, "Incorrect fee amount");

        // Transfer TBTC to signers and close the keep.
        distributeSignerFee(_d);
        _d.closeKeep();

        _d.distributeFeeRebate();

        // We're done yey!
        _d.setRedeemed();
        _d.redemptionTeardown();
        _d.logRedeemed(_txid);
    }

    /// @notice                 Check the redemption transaction input and output vector to ensure the transaction spends
    ///                         the correct UTXO and sends value to the appropriate public key hash.
    /// @dev                    We only look at the first input and first output. Revert if we find the wrong UTXO or value recipient.
    ///                         It's safe to look at only the first input/output as anything that breaks this can be considered fraud
    ///                         and can be caught by ECDSAFraudProof.
    /// @param  _d              Deposit storage pointer.
    /// @param _txInputVector   All transaction inputs prepended by the number of inputs encoded as a VarInt, max 0xFC(252) inputs.
    /// @param _txOutputVector  All transaction outputs prepended by the number of outputs encoded as a VarInt, max 0xFC(252) outputs.
    /// @return                 The value sent to the redeemer's public key hash.
    function redemptionTransactionChecks(
        DepositUtils.Deposit storage _d,
        bytes memory _txInputVector,
        bytes memory _txOutputVector
    ) public view returns (uint256) {
        require(_txInputVector.validateVin(), "invalid input vector provided");
        require(_txOutputVector.validateVout(), "invalid output vector provided");

        bytes memory _input = _txInputVector.slice(1, _txInputVector.length-1);
        bytes memory _output = _txOutputVector.slice(1, _txOutputVector.length-1);

        require(
            keccak256(_input.extractOutpoint()) == keccak256(_d.utxoOutpoint),
            "Tx spends the wrong UTXO"
        );
        require(
            keccak256(_output.slice(8, 3).concat(_output.extractHash())) == keccak256(abi.encodePacked(_d.redeemerOutputScript)),
            "Tx sends value to wrong pubkeyhash"
        );
        return (uint256(_output.extractValue()));
    }

    /// @notice     Anyone may notify the contract that the signers have failed to produce a signature.
    /// @dev        This is considered fraud, and is punished.
    /// @param  _d  Deposit storage pointer.
    function notifySignatureTimeout(DepositUtils.Deposit storage _d) public {
        require(_d.inAwaitingWithdrawalSignature(), "Not currently awaiting a signature");
        require(block.timestamp > _d.withdrawalRequestTime.add(TBTCConstants.getSignatureTimeout()), "Signature timer has not elapsed");
        _d.startLiquidation(false);  // not fraud, just failure
    }

    /// @notice     Anyone may notify the contract that the signers have failed to produce a redemption proof.
    /// @dev        This is considered fraud, and is punished.
    /// @param  _d  Deposit storage pointer.
    function notifyRedemptionProofTimeout(DepositUtils.Deposit storage _d) public {
        require(_d.inAwaitingWithdrawalProof(), "Not currently awaiting a redemption proof");
        require(block.timestamp > _d.withdrawalRequestTime.add(TBTCConstants.getRedemptionProofTimeout()), "Proof timer has not elapsed");
        _d.startLiquidation(false);  // not fraud, just failure
    }
}
