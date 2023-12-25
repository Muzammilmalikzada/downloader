// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Storm.
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////
//                //
//                //
//    ……,,,,,,    //
//                //
//                //
////////////////////


contract TS is ERC721Creator {
    constructor() ERC721Creator("The Storm.", "TS") {}
}