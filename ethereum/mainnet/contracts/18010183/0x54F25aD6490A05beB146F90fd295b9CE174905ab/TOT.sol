// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Taste of Texas
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                 //
//                                                                                                                                                                                                 //
//                                               /$$     /$$       /$$                             /$$     /$$                           /$$                                                       //
//                                              | $$    | $$      |__/                            | $$    | $$                          | $$                                                       //
//      /$$$$$$$  /$$$$$$  /$$   /$$  /$$$$$$  /$$$$$$  | $$   /$$ /$$ /$$$$$$$   /$$$$$$        /$$$$$$  | $$$$$$$   /$$$$$$  /$$$$$$$ | $$   /$$ /$$$$$$$       /$$   /$$  /$$$$$$  /$$   /$$    //
//     /$$_____/ /$$__  $$| $$  | $$ /$$__  $$|_  $$_/  | $$  /$$/| $$| $$__  $$ /$$__  $$      |_  $$_/  | $$__  $$ |____  $$| $$__  $$| $$  /$$//$$_____/      | $$  | $$ /$$__  $$| $$  | $$    //
//    | $$      | $$  \__/| $$  | $$| $$  \ $$  | $$    | $$$$$$/ | $$| $$  \ $$| $$  \ $$        | $$    | $$  \ $$  /$$$$$$$| $$  \ $$| $$$$$$/|  $$$$$$       | $$  | $$| $$  \ $$| $$  | $$    //
//    | $$      | $$      | $$  | $$| $$  | $$  | $$ /$$| $$_  $$ | $$| $$  | $$| $$  | $$        | $$ /$$| $$  | $$ /$$__  $$| $$  | $$| $$_  $$ \____  $$      | $$  | $$| $$  | $$| $$  | $$    //
//    |  $$$$$$$| $$      |  $$$$$$$| $$$$$$$/  |  $$$$/| $$ \  $$| $$| $$  | $$|  $$$$$$$        |  $$$$/| $$  | $$|  $$$$$$$| $$  | $$| $$ \  $$/$$$$$$$/      |  $$$$$$$|  $$$$$$/|  $$$$$$/    //
//     \_______/|__/       \____  $$| $$____/    \___/  |__/  \__/|__/|__/  |__/ \____  $$         \___/  |__/  |__/ \_______/|__/  |__/|__/  \__/_______/        \____  $$ \______/  \______/     //
//                         /$$  | $$| $$                                         /$$  \ $$                                                                        /$$  | $$                        //
//                        |  $$$$$$/| $$                                        |  $$$$$$/                                                                       |  $$$$$$/                        //
//                         \______/ |__/                                         \______/                                                                         \______/                         //
//                                                                                                                                                                                                 //
//                                                                                                                                                                                                 //
//                                                                                                                                                                                                 //
//                                                                                                                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TOT is ERC721Creator {
    constructor() ERC721Creator("Taste of Texas", "TOT") {}
}