// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "./IERC721.sol";


interface IArtBlocks is IERC721 {
    function nextProjectId() external view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
}
