// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./EnumerableSet.sol";
import "./SafeERC20.sol";
import "./IERC20.sol";
import "./LibDiamond.sol";
import "./LibKitty.sol";
import "./Errors.sol";

interface IKitty {
  event PartnerWithdraw(address indexed partner, address indexed token, uint256 amount);

  function partnerTokens(address partner) external view returns (address[] memory tokens_);

  function partnerTokenBalance(address partner, address token) external view returns (uint256);

  function partnerWithdraw(address token) external;

  function ownerWithdraw(address token, uint256 amount, address payable to) external;
}
