// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Lucid
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                                                                           //
//             ▄▓▓▄                                                          //
//         ▄▓█▓▓▓▓▓▓▄                                                        //
//     ▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░                       ▄▓▓▓▓▓▄                       //
//    ▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄                    ▐▓▓▓▓▓▓▓▓▓▓▄                   //
//      ▀▓▓▓▓▓▓▓▀▓▓▓▓▓▓▓▓▓█▄░                ░▓▓▓▓▓▓▓▓▓▓▓▓▓▄                 //
//        ░▓▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄              ░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄               //
//          ░▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄             ▓▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓█▄             //
//             ▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄░     ▄▒▒▓░▓██▄▒▒▓▓▓▓▓▓▓▓▓▓▓█▌            //
//               ▀▓▓▓▓▓▓▓▓▓▓▓▓▓▀▓▓▓▓▓░▒░░▒▒▓░▒████▓▄▒▓▓▓▓▓███████▌           //
//                 ░▀▓▓▓▓▓▓▓▓▓▓▓▒▒▓▀░░░░░░░▒▒▒▒▓█▓▓▓██▓▓██████████▌          //
//                    ▀▓▓▓▓▓▒██▀▒░░▓▒░░▒░▒▒▒▒▒▒▒▓▓▓▓███▓▓██████████░         //
//                     ░▀▓▓▓▀░░░░░▒░▐▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓████▓██████████░         //
//                  ░█▒▒▄█████▓▄▓█▓▓▄░▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓██████████████          //
//                   ▀▓█▓▓██▀▓▓▓▓▒▒▓▓▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▀▀▀████████▀           //
//                    ░▓▀▀░░▄▒▒▓▓█▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▌                    //
//                  ▒▒▒░░▒▒▒▒▒▒▓▓▓█▓▓██▓▓██▓▓▓▓▓▓▓▓▓██████▌                  //
//                ░▒░░░░░▒▒▒▒▒▓▓▓▓████████▓▓▓▓▓▓▓█████▓▓█▓▓▄                 //
//              ██▄▓▒▀░░▒▒▓▒▓▓▓▓▓▓██████▒▒▓▓███████████▀ ▐▀                  //
//              █████▒▒▓▓▓▓▓▓██▓█████████▓█▌▓█████████▄                      //
//               █████▓▓▓▓▓▓█▓███████████████▓██▓▓▓█████▄                    //
//                ▀█████▓▓███▀▀█▀▀▀███████████▓▓▓████████▀▄                  //
//                  ▀▓▓█▀▀      ▓▄▄▄  ▀██▓▓▓█████████▀▄██████▄               //
//                             ▐▓███     ▀███████▀█████████████▄             //
//                               ▀▀        ▀██▀▄█████████████████▒           //
//                                           ▀███████████████▀▓▄████▄        //
//                                              ▀██▓█████▀▓▓▓█████████▄      //
//                                                ▀███▀▓████████████████▌    //
//                                                  ▀▓███████████████▀▀      //
//                                                     ▀█████████▓▀          //
//                                                       ▀████▀▀             //
//                                                         ▀                 //
//                                                                           //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


contract LUCID is ERC721Creator {
    constructor() ERC721Creator("Lucid", "LUCID") {}
}
