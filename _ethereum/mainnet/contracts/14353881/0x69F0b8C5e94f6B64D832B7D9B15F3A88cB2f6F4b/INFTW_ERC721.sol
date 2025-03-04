// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./IERC721.sol";

interface INFTW_ERC721 is IERC721 {
    function updateMetadataIPFSHash(uint _tokenId, string calldata _tokenMetadataIPFSHash) external;
}
