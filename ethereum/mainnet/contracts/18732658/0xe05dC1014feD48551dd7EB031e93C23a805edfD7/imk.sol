// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: imk ed.
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////
//                                                                                 //
//                                                                                 //
//                                                                                 //
//          _           _         _             _   _                              //
//         (_)_ __ ___ | | ____ _| |_ ___   ___| |_| |__                           //
//         | | '_ ` _ \| |/ / _` | __/ _ \ / _ \ __| '_ \                          //
//         | | | | | | |   < (_| | ||  __/|  __/ |_| | | |                         //
//         |_|_| |_| |_|_|\_\__,_|\__\___(_)___|\__|_| |_|                         //
//                                                                                 //
//         collection of editions created on December 7, 2023                      //
//                                                                                 //
//                                                                                 //
//                                                                                 //
//                                                                                 //
//                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////


contract imk is ERC1155Creator {
    constructor() ERC1155Creator("imk ed.", "imk") {}
}
