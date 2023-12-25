// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: manifold.xyz

////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ██████████████▌          ╟██           ████████████████          j██████████████  //
//  ██████████████▌          ╟███           ███████████████          j██████████████  //
//  ██████████████▌          ╟███▌           ██████████████          j██████████████  //
//  ██████████████▌          ╟████▌           █████████████          j██████████████  //
//  ██████████████▌          ╟█████▌          ╙████████████          j██████████████  //
//  ██████████████▌          ╟██████▄          ╙███████████          j██████████████  //
//  ██████████████▌          ╟███████           ╙██████████          j██████████████  //
//  ██████████████▌          ╟████████           ╟█████████          j██████████████  //
//  ██████████████▌          ╟█████████           █████████          j██████████████  //
//  ██████████████▌          ╟██████████           ████████          j██████████████  //
//  ██████████████▌          ╟██████████▌           ███████          j██████████████  //
//  ██████████████▌          ╟███████████▌           ██████          j██████████████  //
//  ██████████████▌          ╟████████████▄          ╙█████        ,████████████████  //
//  ██████████████▌          ╟█████████████           ╙████      ▄██████████████████  //
//  ██████████████▌          ╟██████████████           ╙███    ▄████████████████████  //
//  ██████████████▌          ╟███████████████           ╟██ ,███████████████████████  //
//  ██████████████▌                      ,████           ███████████████████████████  //
//  ██████████████▌                    ▄██████▌           ██████████████████████████  //
//  ██████████████▌                  ▄█████████▌           █████████████████████████  //
//  ██████████████▌               ,█████████████▄           ████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//  ████████████████████████████████████████████████████████████████████████████████  //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////

import "./IERC1155.sol";

interface IResources is IERC1155 {

    /**
     * @dev Mint tokens
     */
    function mint(address to, uint256[] memory tokenIds, uint256[] memory amounts) external;

    /**
     * @dev Set the tokenURI of a token.
     */
    function setTokenURI(uint256 tokenId, string calldata uri_) external;

    /**
     * @dev set the tokenURI of multiple tokens.
     */
    function setTokenURIs(uint256[] memory tokenIds, string[] calldata uris) external;

    /**
     * @dev burn tokens. Can only be called by token owner or approved address.
     * On burn, calls back to the registered extension's onBurn method
     */
    function burn(address account, uint256[] calldata tokenIds, uint256[] calldata amounts) external;

    /**
     * @dev Total amount of tokens of resource with a given id.
     */
    function totalSupply(uint256 tokenId) external view returns (uint256);

    /**
     * @dev Total amount of burned tokens of resource with a given id.
     */
    function burnedSupply(uint256 tokenId) external view returns (uint256);
}