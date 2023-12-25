// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Abstract Dots
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░░    //
//    ░░░▓████▒░░░░████████▒░░░▒██████▓░░█████████▓░████████▒░░░░░█████░░░░░▒███████░░██████████    //
//    ░░░█████▓░░░░███▒░▒███▒░░███░░▓██▓░▒▒▒███▓▒▒▒░███▓░▒███▒░░░░█████▒░░░░███▒░▓███░▒▒▒▓███▒▒▒    //
//    ░░▒██▓███░░░░███▒░░▓██▒░▒███░░▒██▓░░░░███▒░░░░███▒░░▓██▓░░░▒██▒███░░░░███░░░███░░░░▓██▓░░░    //
//    ░░▓██▒▓██▒░░░███▒░░███░░░███▓░░░░░░░░░███▒░░░░███▒░░▓██▒░░░███░███░░░▒███░░░░░░░░░░▓██▓░░░    //
//    ░░███░▒██▓░░░████████▒░░░░█████▒░░░░░░███▒░░░░████▓███▓░░░░███░▓██▒░░▒███░░░░░░░░░░▓██▓░░░    //
//    ░░███░░███░░░███▓▒▓███▒░░░░░▓████░░░░░███▒░░░░████▓███▓░░░▒██▓░▒███░░▒███░░░░░░░░░░▓██▓░░░    //
//    ░▓████████▒░░███▒░░▒███░░░░░░░▓███░░░░███▒░░░░███▒░░███▒░░█████████░░▒███░░░░░░░░░░▓██▓░░░    //
//    ░███▓▒▒▓██▓░░███▒░░▒███░▓██▒░░░███░░░░███▒░░░░███▒░░▓██▒░░███▒▒▒███▒░▒███░░░███░░░░▓██▓░░░    //
//    ░███░░░░███░░███▒░░▓██▓░▓██▓░░▒███░░░░███▒░░░░███▒░░▓██▒░▒███░░░▓███░░███▒░▒███░░░░▓██▓░░░    //
//    ▓██▓░░░░███▒░████████▓░░░▓███████░░░░░███▒░░░░███▒░░▓██▒░███▓░░░░███░░▒███████▒░░░░▓██▓░░░    //
//    ░▒▒░░░░░░▒▒░░░▒▒▒▒▒░░░░░░░░▒▒▒▒░░░░░░░░▒▒░░░░░▒▒▒░░░░▒▒░░▒▒▒░░░░░▒▒▒░░░░▒▒▒▒▒░░░░░░░▒▒░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒░░░░░░░░░░▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░████████▓░░░▒████████░░█████████▓░▒███████░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░███░░▒███▓░░███▒░░▓██▓░░░░███▒░░░░███░░▓██▓░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░███░░░▓███░░███░░░▒███░░░░███▒░░░▒███░░▒▓▓▒░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░███░░░▓███░░███░░░▒███░░░░███▒░░░░████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░███░░░▓███░░███░░░▒███░░░░███▒░░░░░▓████▓░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░███░░░▓███░░███░░░▒███░░░░███▒░░░░░░░▒████▒░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░███░░░▓███░░███░░░▒███░░░░███▒░░░░░░░░░▓███░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░███░░░▓██▓░░███░░░▒███░░░░███▒░░░▓██▓░░░███░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░███░▒▒███▒░░███▓░░▓██▓░░░░███▒░░░▓███░░▓███░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░████████▒░░░░███████▓░░░░░███▒░░░░▓██████▓░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract absdts is ERC721Creator {
    constructor() ERC721Creator("Abstract Dots", "absdts") {}
}