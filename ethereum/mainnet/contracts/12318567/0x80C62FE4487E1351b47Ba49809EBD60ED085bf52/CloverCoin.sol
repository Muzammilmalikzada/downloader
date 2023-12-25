// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20PresetMinterPauser.sol";

// Clover ERC20 token contract
contract CloverToken is ERC20PresetMinterPauser {
  constructor() ERC20PresetMinterPauser("Clover", "CLV") {
  }
}