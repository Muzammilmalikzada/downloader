// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RngAuction.sol";
import "./IAuction.sol";
import "./AddressRemapper.sol";
import "./IRngAuctionRelayListener.sol";

/// @notice Emitted when the RNG has not yet completed
error RngNotCompleted();

/// @notice Emitted when the RngAuction is zero
error RngAuctionIsZeroAddress();

/// @notice Emitted when recipient is zero
error RewardRecipientIsZeroAddress();

/// @title RngAuctionRelayer
/// @author G9 Software Inc.
/// @notice Base contarct that relays RNG auction results to a listener
abstract contract RngAuctionRelayer is AddressRemapper {

    /// @notice The RNG Auction to get the random number from
    RngAuction public immutable rngAuction;

    /// @notice Constructs a new contract
    /// @param _rngAuction The RNG auction to retrieve the random number from
    constructor(
        RngAuction _rngAuction
    ) {
        if (address(_rngAuction) == address(0)) revert RngAuctionIsZeroAddress();
        rngAuction = _rngAuction;
    }

    /// @notice Encodes the calldata for the RNG auction relay listener
    /// @param _rewardRecipient The address of the relay reward recipient
    /// @return The calldata to call the listener with
    function _encodeCalldata(address _rewardRecipient) internal returns (bytes memory) {
        if (_rewardRecipient == address(0)) {
            revert RewardRecipientIsZeroAddress();
        }
        if (!rngAuction.isRngComplete()) revert RngNotCompleted();
        (uint256 randomNumber, uint64 rngCompletedAt) = rngAuction.getRngResults();
        AuctionResult memory results = rngAuction.getLastAuctionResult();
        uint32 sequenceId = rngAuction.openSequenceId();
        results.recipient = remappingOf(results.recipient);
        return abi.encodeCall(
            IRngAuctionRelayListener.rngComplete,
            (randomNumber, rngCompletedAt, _rewardRecipient, sequenceId, results)
        );
    }
}
