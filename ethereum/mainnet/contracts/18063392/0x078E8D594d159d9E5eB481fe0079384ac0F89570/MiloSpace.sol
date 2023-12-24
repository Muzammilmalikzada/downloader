// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Milo Sohl - Space
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ███████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓███████████████████    //
//    ███████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓███████████████████    //
//    ███████████████████▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓▓████████████████████    //
//    █████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█████████████████████████    //
//    █████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█████████████████████████    //
//    █████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█████████████████████████    //
//    █████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█████████████████████████    //
//    █████████████████████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓█████████████████████████    //
//    ███████████████████████████▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒████████████████████████████    //
//    █████████████████████████████▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒██████████████████████████████    //
//    ███████████████████████████████▓░░░░░░░░░░░░░░░░░░░░░░░░░▒████████████████████████████████    //
//    █████████████████████████████████▓░░░░░░░░░░░░░░░░░░░░░▒██████████████████████████████████    //
//    ███████████████████████████████████▓░░░░░░░░░░░░░░░░░▒████████████████████████████████████    //
//    █████████████████████████████████████▓░░░░░░░░░░░░░▒██████████████████████████████████████    //
//    ███████████████████████████████████████▓░░░░░░░░░▒▓███████████████████████████████████████    //
//    █████████████████████████████████████████▓▒░░░░▒██████████████████████████████████████████    //
//    █████████████████████████████████████████▓▒░░░░▒██████████████████████████████████████████    //
//    ████████████████████████████████████████▒░░░▓▓░░░▒████████████████████████████████████████    //
//    ██████████████████████████████████████▒░░░▓████▓░░░▒██████████████████████████████████████    //
//    ████████████████████████████████████▒░░░▓████████▓░░░▒████████████████████████████████████    //
//    █████████████████████████████████▓▒░░░▓████████████▓░░░▒██████████████████████████████████    //
//    ████████████████████████████████▒░░░▓████████████████▓░░░▒████████████████████████████████    //
//    █████████████████████████████▓▒░░░▓████████████████████▓░░░▒██████████████████████████████    //
//    ███████████████████████████▓▒░░░▓███████████░░▓██████████▓░░░▒████████████████████████████    //
//    █████████████████████████▓░░░░▓█████████████▒░▒████████████▓░░░░▓█████████████████████████    //
//    █████████████████████████░░░▓███████████▓▓▓▓▓▓▓▓▓████████████▓░░░█████████████████████████    //
//    █████████████████████████▒▓█████▓▒▒░░░░░░░░░░░░░░░░░░░░▒▓▓█████▓▒█████████████████████████    //
//    ████████████████████████████▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓████████████████████████████    //
//    █████████████████████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒█████████████████████████    //
//    █████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█████████████████████████    //
//    ███████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓███████████████████    //
//    ███████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒███████████████████    //
//    ████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████ SPACE    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract MiloSpace is ERC721Creator {
    constructor() ERC721Creator("Milo Sohl - Space", "MiloSpace") {}
}
