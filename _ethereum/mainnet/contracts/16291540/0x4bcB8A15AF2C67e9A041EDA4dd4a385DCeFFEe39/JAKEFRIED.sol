
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: JAKE FRIED Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//                                                                                       //
//             ██  █████  ██   ██ ███████     ███████ ██████  ██ ███████ ██████          //
//             ██ ██   ██ ██  ██  ██          ██      ██   ██ ██ ██      ██   ██         //
//             ██ ███████ █████   █████       █████   ██████  ██ █████   ██   ██         //
//        ██   ██ ██   ██ ██  ██  ██          ██      ██   ██ ██ ██      ██   ██         //
//         █████  ██   ██ ██   ██ ███████     ██      ██   ██ ██ ███████ ██████          //
//                                                                                       //
//                                                                                       //
//                                    ████████████                                       //
//                            ████████            ████████                               //
//                       █████                            █████                          //
//                    ███               ████████                ███                      //
//                 ███               ██████████████                ███                   //
//              ███                ███     ██████████                 ███                //
//            ██                 █████     ████████████                  ██              //
//          ██                  ████████████████████████                   ██            //
//        ██                   ██████████████████████████                    ██          //
//        ██                   ██████████████████████████                    ██          //
//          ██                  ████████████████████████                   ██            //
//            ██                 ██████████████████████                  ██              //
//              ███                ██████████████████                 ███                //
//                 ███               ██████████████                ███                   //
//                    ███               ████████                ███                      //
//                       █████                            █████                          //
//                            ████████            ████████                               //
//                                    ████████████                                       //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract JAKEFRIED is ERC1155Creator {
    constructor() ERC1155Creator("JAKE FRIED Editions", "JAKEFRIED") {}
}
