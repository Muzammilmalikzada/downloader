// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./Address.sol";
import "./JBPayoutRedemptionPaymentTerminal3_1.sol";
import "./JBSplitsGroups.sol";

/**
  @notice
  Manages all inflows and outflows of ETH funds into the protocol ecosystem.

  @dev
  Inherits from -
  JBPayoutRedemptionPaymentTerminal3_1: Generic terminal managing all inflows and outflows of funds into the protocol ecosystem.
*/
contract JBETHPaymentTerminal3_1 is JBPayoutRedemptionPaymentTerminal3_1 {
  //*********************************************************************//
  // -------------------------- internal views ------------------------- //
  //*********************************************************************//

  /** 
    @notice
    Checks the balance of tokens in this contract.

    @return The contract's balance, as a fixed point number with the same amount of decimals as this terminal.
  */
  function _balance() internal view override returns (uint256) {
    return address(this).balance;
  }

  //*********************************************************************//
  // -------------------------- constructor ---------------------------- //
  //*********************************************************************//

  /**
    @param _baseWeightCurrency The currency to base token issuance on.
    @param _operatorStore A contract storing operator assignments.
    @param _projects A contract which mints ERC-721's that represent project ownership and transfers.
    @param _directory A contract storing directories of terminals and controllers for each project.
    @param _splitsStore A contract that stores splits for each project.
    @param _prices A contract that exposes price feeds.
    @param _store A contract that stores the terminal's data.
    @param _owner The address that will own this contract.
  */
  constructor(
    uint256 _baseWeightCurrency,
    IJBOperatorStore _operatorStore,
    IJBProjects _projects,
    IJBDirectory _directory,
    IJBSplitsStore _splitsStore,
    IJBPrices _prices,
    IJBSingleTokenPaymentTerminalStore _store,
    address _owner
  )
    JBPayoutRedemptionPaymentTerminal3_1(
      JBTokens.ETH,
      18, // 18 decimals.
      JBCurrencies.ETH,
      _baseWeightCurrency,
      JBSplitsGroups.ETH_PAYOUT,
      _operatorStore,
      _projects,
      _directory,
      _splitsStore,
      _prices,
      _store,
      _owner
    )
  // solhint-disable-next-line no-empty-blocks
  {

  }

  //*********************************************************************//
  // ---------------------- internal transactions ---------------------- //
  //*********************************************************************//

  /** 
    @notice
    Transfers tokens.

    @param _from The address from which the transfer should originate.
    @param _to The address to which the transfer should go.
    @param _amount The amount of the transfer, as a fixed point number with the same number of decimals as this terminal.
  */
  function _transferFrom(
    address _from,
    address payable _to,
    uint256 _amount
  ) internal override {
    _from; // Prevents unused var compiler and natspec complaints.

    Address.sendValue(_to, _amount);
  }
}
