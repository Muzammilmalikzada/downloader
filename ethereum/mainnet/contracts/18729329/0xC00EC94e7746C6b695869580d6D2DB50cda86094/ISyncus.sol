// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

interface ISyncus {
    function burn(uint256 amount) external;

    function burnFrom(address account_, uint256 amount_) external;
}