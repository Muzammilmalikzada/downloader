// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import "./draft-IERC20Permit.sol";
import "./IERC20.sol";

interface IBeamToken is IERC20, IERC20Permit {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}