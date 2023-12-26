// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./Common.sol";
import "./IERC165.sol";
import "./IERC2981.sol";
import "./IJBFundingCycleDataSource3_1_1.sol";
import "./IJBDirectory.sol";
import "./IJBPayDelegate3_1_1.sol";
import "./IJBRedemptionDelegate3_1_1.sol";
import "./IJBPaymentTerminal.sol";
import "./JBConstants.sol";
import "./JBPayParamsData.sol";
import "./JBDidPayData3_1_1.sol";
import "./JBDidRedeemData3_1_1.sol";
import "./JBRedeemParamsData.sol";
import "./JBPayDelegateAllocation3_1_1.sol";
import "./JBRedemptionDelegateAllocation3_1_1.sol";
import "./JBDelegateMetadataLib.sol";

import "./IJB721Delegate.sol";
import "./ERC721.sol";

/// @title JB721Delegate
/// @notice This delegate makes NFTs available to a project's contributors upon payment, and allows project owners to enable NFT redemption for treasury assets.
abstract contract JB721Delegate is
    ERC721,
    IJB721Delegate,
    IJBFundingCycleDataSource3_1_1,
    IJBPayDelegate3_1_1,
    IJBRedemptionDelegate3_1_1
{
    //*********************************************************************//
    // --------------------------- custom errors ------------------------- //
    //*********************************************************************//

    error INVALID_PAYMENT_EVENT();
    error INVALID_REDEMPTION_EVENT();
    error UNAUTHORIZED_TOKEN(uint256 _tokenId);
    error UNEXPECTED_TOKEN_REDEEMED();
    error INVALID_REDEMPTION_METADATA();

    //*********************************************************************//
    // --------------- public immutable stored properties ---------------- //
    //*********************************************************************//


    /// @notice The directory of terminals and controllers for projects.
    IJBDirectory public override immutable directory;

    /// @notice The 4bytes ID of this delegate, used for pay metadata parsing
    bytes4 public override immutable payMetadataDelegateId;

    /// @notice The 4bytes ID of this delegate, used for redeem metadata parsing
    bytes4 public override immutable redeemMetadataDelegateId;

    //*********************************************************************//
    // -------------------- public stored properties --------------------- //
    //*********************************************************************//

    /// @notice The Juicebox project ID this contract's functionality applies to.
    uint256 public override projectId;

    //*********************************************************************//
    // ------------------------- external views -------------------------- //
    //*********************************************************************//

    /// @notice This function gets called when the project receives a payment. It sets this contract as the delegate to get a callback from the terminal. Part of IJBFundingCycleDataSource.
    /// @param _data The Juicebox standard project payment data.
    /// @return weight The weight that tokens should get minted in accordance with.
    /// @return memo A memo to be forwarded to the event.
    /// @return delegateAllocations Amount to be sent to delegates instead of adding to local balance.
    function payParams(JBPayParamsData calldata _data)
        public
        view
        virtual
        override
        returns (uint256 weight, string memory memo, JBPayDelegateAllocation3_1_1[] memory delegateAllocations)
    {
        // Forward the received weight and memo, and use this contract as a pay delegate.
        weight = _data.weight;
        memo = _data.memo;
        delegateAllocations = new JBPayDelegateAllocation3_1_1[](1);
        delegateAllocations[0] = JBPayDelegateAllocation3_1_1(this, 0, bytes(''));
    }

    /// @notice This function gets called when the project's (NFT) token holders redeem. Part of IJBFundingCycleDataSource.
    /// @param _data Standard Juicebox project redemption data.
    /// @return reclaimAmount Amount to be reclaimed from the treasury.
    /// @return memo A memo to be forwarded to the event.
    /// @return delegateAllocations Amount to be sent to delegates instead of being added to the beneficiary.
    function redeemParams(JBRedeemParamsData calldata _data)
        public
        view
        virtual
        override
        returns (uint256 reclaimAmount, string memory memo, JBRedemptionDelegateAllocation3_1_1[] memory delegateAllocations)
    {
        // Make sure fungible project tokens aren't also being redeemed.
        if (_data.tokenCount > 0) revert UNEXPECTED_TOKEN_REDEEMED();

        // fetch this delegates metadata from the delegate id
        (bool _found, bytes memory _metadata) = JBDelegateMetadataLib.getMetadata(redeemMetadataDelegateId, _data.metadata);

        // Set the only delegate allocation to be a callback to this contract.
        delegateAllocations = new JBRedemptionDelegateAllocation3_1_1[](1);
        delegateAllocations[0] = JBRedemptionDelegateAllocation3_1_1(this, 0, bytes(''));

        uint256[] memory _decodedTokenIds;

        // Decode the metadata
        if (_found) _decodedTokenIds = abi.decode(_metadata, (uint256[]));

        // Get a reference to the redemption rate of the provided tokens.
        uint256 _redemptionWeight = redemptionWeightOf(_decodedTokenIds, _data);

        // Get a reference to the total redemption weight.
        uint256 _total = totalRedemptionWeight(_data);

        // Get a reference to the linear proportion.
        uint256 _base = mulDiv(_data.overflow, _redemptionWeight, _total);

        // These conditions are all part of the same curve. Edge conditions are separated because fewer operation are necessary.
        if (_data.redemptionRate == JBConstants.MAX_REDEMPTION_RATE) {
            return (_base, _data.memo, delegateAllocations);
        }

        // Return the weighted overflow, and this contract as the delegate so that tokens can be deleted.
        return (
            mulDiv(
                _base,
                _data.redemptionRate
                    + mulDiv(_redemptionWeight, JBConstants.MAX_REDEMPTION_RATE - _data.redemptionRate, _total),
                JBConstants.MAX_REDEMPTION_RATE
                ),
            _data.memo,
            delegateAllocations
        );
    }

    //*********************************************************************//
    // -------------------------- public views --------------------------- //
    //*********************************************************************//

    /// @notice Returns the cumulative redemption weight of the given token IDs relative to the `totalRedemptionWeight`.
    /// @param _tokenIds The token IDs to calculate the cumulative redemption weight for.
    /// @param _data Standard Juicebox project redemption data.
    /// @return The cumulative redemption weight of the specified token IDs.
    function redemptionWeightOf(uint256[] memory _tokenIds, JBRedeemParamsData calldata _data)
        public
        view
        virtual
        returns (uint256)
    {
        _tokenIds; // Prevents unused var compiler and natspec complaints.
        _data; // Prevents unused var compiler and natspec complaints.
        return 0;
    }

    /// @notice Calculates the cumulative redemption weight of all token IDs.
    /// @param _data Standard Juicebox project redemption data.
    /// @return Total cumulative redemption weight of all token IDs.
    function totalRedemptionWeight(JBRedeemParamsData calldata _data) public view virtual returns (uint256) {
        _data; // Prevents unused var compiler and natspec complaints.
        return 0;
    }

    /// @notice Indicates if this contract adheres to the specified interface.
    /// @dev See {IERC165-supportsInterface}.
    /// @param _interfaceId The ID of the interface to check for adherence to.
    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
        return _interfaceId == type(IJB721Delegate).interfaceId
            || _interfaceId == type(IJBFundingCycleDataSource3_1_1).interfaceId
            || _interfaceId == type(IJBPayDelegate3_1_1).interfaceId || _interfaceId == type(IJBRedemptionDelegate3_1_1).interfaceId
            || _interfaceId == type(IERC2981).interfaceId || super.supportsInterface(_interfaceId);
    }

    //*********************************************************************//
    // -------------------------- constructor ---------------------------- //
    //*********************************************************************//

    /// @param _directory A directory of terminals and controllers for projects.
    /// @param _payMetadataDelegateId The 4bytes ID of this delegate, used for pay metadata parsing
    /// @param _redeemMetadataDelegateId The 4bytes ID of this delegate, used for redeem metadata parsing
    constructor(IJBDirectory _directory, bytes4 _payMetadataDelegateId, bytes4 _redeemMetadataDelegateId) {
        directory = _directory;
        payMetadataDelegateId = _payMetadataDelegateId;
        redeemMetadataDelegateId = _redeemMetadataDelegateId;
    }

    /// @notice Initializes the contract with project details and ERC721 token details.
    /// @param _projectId The ID of the project this contract's functionality applies to.
    /// @param _name The name of the token.
    /// @param _symbol The symbol representing the token.
    function _initialize(uint256 _projectId, string memory _name, string memory _symbol)
        internal
    {
        ERC721._initialize(_name, _symbol);
        projectId = _projectId;
    }

    //*********************************************************************//
    // ---------------------- external transactions ---------------------- //
    //*********************************************************************//

    /// @notice Mints an NFT to the contributor (_data.beneficiary) upon project payment if conditions are met. Part of IJBPayDelegate.
    /// @dev Reverts if the calling contract is not one of the project's terminals.
    /// @param _data Standard Juicebox project payment data.
    function didPay(JBDidPayData3_1_1 calldata _data) external payable virtual override {
        uint256 _projectId = projectId;

        // Make sure the caller is a terminal of the project, and that the call is being made on behalf of an interaction with the correct project.
        if (
            msg.value != 0 || !directory.isTerminalOf(_projectId, IJBPaymentTerminal(msg.sender))
                || _data.projectId != _projectId
        ) revert INVALID_PAYMENT_EVENT();

        // Process the payment.
        _processPayment(_data);
    }

    /// @notice Burns specified NFTs upon token holder redemption, reclaiming funds from the project's balance to _data.beneficiary. Part of IJBRedeemDelegate.
    /// @dev Reverts if the calling contract is not one of the project's terminals.
    /// @param _data Standard Juicebox project redemption data.
    function didRedeem(JBDidRedeemData3_1_1 calldata _data) external payable virtual override {
        // Make sure the caller is a terminal of the project, and that the call is being made on behalf of an interaction with the correct project.
        if (
            msg.value != 0 || !directory.isTerminalOf(projectId, IJBPaymentTerminal(msg.sender))
                || _data.projectId != projectId
        ) revert INVALID_REDEMPTION_EVENT();

        // fetch this delegates metadata from the delegate id
        (bool _found, bytes memory _metadata) = JBDelegateMetadataLib.getMetadata(redeemMetadataDelegateId, _data.redeemerMetadata);

        uint256[] memory _decodedTokenIds;

        // Decode the metadata.
        if (_found) _decodedTokenIds = abi.decode(_metadata, (uint256[]));

        // Get a reference to the number of token IDs being checked.
        uint256 _numberOfTokenIds = _decodedTokenIds.length;

        // Keep a reference to the token ID being iterated upon.
        uint256 _tokenId;

        // Iterate through all tokens, burning them if the owner is correct.
        for (uint256 _i; _i < _numberOfTokenIds;) {
            // Set the token's ID.
            _tokenId = _decodedTokenIds[_i];

            // Make sure the token's owner is correct.
            if (_owners[_tokenId] != _data.holder) revert UNAUTHORIZED_TOKEN(_tokenId);

            // Burn the token.
            _burn(_tokenId);

            unchecked {
                ++_i;
            }
        }

        // Call the hook.
        _didBurn(_decodedTokenIds);
    }

    //*********************************************************************//
    // ---------------------- internal transactions ---------------------- //
    //*********************************************************************//

    /// @notice Process a received payment.
    /// @param _data Standard Juicebox project payment data.
    function _processPayment(JBDidPayData3_1_1 calldata _data) internal virtual {
        _data; // Prevents unused var compiler and natspec complaints.
    }

    /// @notice Executes after tokens have been burned via redemption.
    /// @param _tokenIds The IDs of the tokens that were burned.
    function _didBurn(uint256[] memory _tokenIds) internal virtual {
        _tokenIds;
    }
}
