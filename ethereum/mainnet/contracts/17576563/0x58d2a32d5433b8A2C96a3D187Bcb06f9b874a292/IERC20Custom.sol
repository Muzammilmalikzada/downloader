// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "./IERC20.sol";

interface IERC20Custom is IERC20 {
    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}
