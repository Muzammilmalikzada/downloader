// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IPoolAddressesProvider.sol";
import "./IPool.sol";

/**
 * @dev altered version removing immutables, for easier inheritance
 * @title IFlashLoanReceiver
 * @author Aave
 * @notice Defines the basic interface of a flashloan-receiver contract.
 * @dev Implement this interface to develop a flashloan-compatible flashLoanReceiver contract
 **/
interface IFlashLoanReceiverBase {
  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);

  function POOL() external view returns (IPool);
}
