// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Ledger x Deadfellaz - Proof of Redemption
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////
//                                                                                  //
//                                                                                  //
//      ██▓    ▓█████▄   ▄████  ██▀███     ▒██   ██▒   ▓█████▄   █████▒▒███████▒    //
//    ▓██▒    ▒██▀ ██▌ ██▒ ▀█▒▓██ ▒ ██▒   ▒▒ █ █ ▒░   ▒██▀ ██▌▓██   ▒ ▒ ▒ ▒ ▄▀░     //
//    ▒██░    ░██   █▌▒██░▄▄▄░▓██ ░▄█ ▒   ░░  █   ░   ░██   █▌▒████ ░ ░ ▒ ▄▀▒░      //
//    ▒██░    ░▓█▄   ▌░▓█  ██▓▒██▀▀█▄      ░ █ █ ▒    ░▓█▄   ▌░▓█▒  ░   ▄▀▒   ░     //
//    ░██████▒░▒████▓ ░▒▓███▀▒░██▓ ▒██▒   ▒██▒ ▒██▒   ░▒████▓ ░▒█░    ▒███████▒     //
//    ░ ▒░▓  ░ ▒▒▓  ▒  ░▒   ▒ ░ ▒▓ ░▒▓░   ▒▒ ░ ░▓ ░    ▒▒▓  ▒  ▒ ░    ░▒▒ ▓░▒░▒     //
//    ░ ░ ▒  ░ ░ ▒  ▒   ░   ░   ░▒ ░ ▒░   ░░   ░▒ ░    ░ ▒  ▒  ░      ░░▒ ▒ ░ ▒     //
//      ░ ░    ░ ░  ░ ░ ░   ░   ░░   ░     ░    ░      ░ ░  ░  ░ ░    ░ ░ ░ ░ ░     //
//        ░  ░   ░          ░    ░         ░    ░        ░              ░ ░         //
//             ░                                       ░              ░             //
//                                                                                  //
//                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////


contract LXDFZ is ERC1155Creator {
    constructor() ERC1155Creator("Ledger x Deadfellaz - Proof of Redemption", "LXDFZ") {}
}
