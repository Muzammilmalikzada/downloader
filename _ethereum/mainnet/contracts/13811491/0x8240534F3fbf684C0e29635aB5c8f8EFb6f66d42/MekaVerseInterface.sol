// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";

interface MekaVerseInterface is IERC721{
    function walletOfOwner(address _owner) external view returns (uint256[] memory);
}