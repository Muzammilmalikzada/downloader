
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Memes
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                              //
//                                                                                                                              //
//    ███████████████████████████████████▌     ▐█████▌                       ██████     ▐███████████████████████████████████    //
//    ███████████████████████████████████▌     ▐█████▌                       ██████     ▐███████████████████████████████████    //
//    ███████████████████████████████████▌     ▐█████▌                       ██████     ▐███████████████████████████████████    //
//                   █████▌                    ▐█████▌                       ██████     ▐█████▌                                 //
//                   █████▌                    ▐█████▌                       ██████     ▐█████▌                                 //
//                   █████▌                    ▐█████▌                       ██████     ▐█████▌                                 //
//                   █████▌                    ▐█████▌                       ██████     ▐█████▌                                 //
//                   █████▌                    ▐███████████████████████████████████     ▐███████████████████████████████████    //
//                   █████▌                    ▐███████████████████████████████████     ▐███████████████████████████████████    //
//                   █████▌                    ▐███████████████████████████████████     ▐███████████████████████████████████    //
//                   █████▌                    ▐█████▌                       ██████     ▐█████▌                                 //
//                   █████▌                    ▐█████▌                       ██████     ▐█████▌                                 //
//                   █████▌                    ▐█████▌                       ██████     ▐█████▌                                 //
//                   █████▌                    ▐█████▌                       ██████     ▐█████▌                                 //
//                   █████▌                    ▐█████▌                       ██████     ▐███████████████████████████████████    //
//                   █████▌                    ▐█████▌                       ██████     ▐███████████████████████████████████    //
//                   █████▌                    ▐█████▌                       ██████     ▐███████████████████████████████████    //
//                                                                                                                              //
//                                                                                                                              //
//                                                                                                                              //
//    ███████████████████████████████████▌     ▐███████████████████████████████████     ▐███████████████████████████████████    //
//    ███████████████████████████████████▌     ▐███████████████████████████████████     ▐███████████████████████████████████    //
//    ███████████████████████████████████▌     ▐███████████████████████████████████     ▐███████████████████████████████████    //
//    ██████         █████▌        ▐█████▌     ▐█████▌                                  ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐█████▌                                  ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐█████▌                                  ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐███████████████████████████████████     ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐███████████████████████████████████     ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐███████████████████████████████████     ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐█████▌                                  ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐█████▌                                  ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐█████▌                                  ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐█████▌                                  ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐███████████████████████████████████     ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐███████████████████████████████████     ▐█████▌        ▐█████         ██████    //
//    ██████         █████▌        ▐█████▌     ▐███████████████████████████████████     ▐█████▌        ▐█████         ██████    //
//                                                                                                                              //
//                                                                                                                              //
//                                                                                                                              //
//    ███████████████████████████████████      ▐███████████████████████████████████      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ███████████████████████████████████      ▐███████████████████████████████████      ▒▒                                     //
//    ██████▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀      ▐███████████████████████████████████      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ██████                                   ▐█████▌                                   ▒▒                               ▒▒    //
//    ██████                                   ▐█████▌                                   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ██████                                   ▐█████▌                                                                          //
//    ██████                                   ▐█████▌                                   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ███████████████████████████████████      ▐███████████████████████████████████      ▒▒                               ▒▒    //
//    ███████████████████████████████████      ▐███████████████████████████████████      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ███████████████████████████████████      ▐███████████████████████████████████                    ▒▒  ▒▒                   //
//    ██████                                                                 ██████      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ██████                                                                 ██████                                             //
//    ██████                                                                 ██████      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ██████                                                                 ██████      ▒▒                               ▒▒    //
//    ███████████████████████████████████▌     ▐███████████████████████████████████      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ███████████████████████████████████▌     ▐███████████████████████████████████                                       ▒▒    //
//    ███████████████████████████████████▌     ▐███████████████████████████████████      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//                                                                                                                              //
//                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MEMES is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
