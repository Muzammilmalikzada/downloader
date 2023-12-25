// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Namineko Island
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//                                         ___                                __                                //
//                                      ▄██████████@▄                 ▄@██████████▄                             //
//                                      ███L  █████████@           g██████████▓▒███                             //
//                                      █████████▌ ~██████▄     ▄█████████████_▄███                             //
//                                     τ██████████g@████▓█████████████_ _██████████L                            //
//            τ███████████░_           τ█████▌ ▀███████████████████████████████████▌                            //
//            M█▌ßßÉÉÉÉÑ░██████▄       τ██████@@██████████████████████████▄█████ Σ█▌     _g█████████████████    //
//            ██▌ßßßßßßß▐██gßÑ████_    ▄████████████▒████████▄▄██████████████▓█████▌ _██████▓#ßßßßßßßßßßßß██    //
//            ██Éßßßßßß▐██████▒ÉÑ███@██████  ██████__▒███████████████` █████▄ _████████▌ß▐▒███████Éßßßßßß▐██    //
//            ██ßßßßßßß▐████▒█████▐███▌ß█████████████████▓ÉßßßßßÉ▓█████████████████É█████████▒████▐ßßßßßß██     //
//            ██▌ßßßßßßN████████████#ßßßß█████████████▌Éßßßßßßßßßßßß░█████████████Éßßß████████████ßßßßßß▒██     //
//             ██ßßßßßßß██████████▌ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÉÉßßßßßßßßßß███▒█████▌ßßßßß▓██      //
//             ▒█½ßßßßßßß███████▓ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß▐███▒███ßßßßß▐██       //
//             ~██ßßßßßßßÉ█████Éßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß▓███▌ßßßßß½██        //
//              ▒█▌ßßßßßßßß███ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß▐██▌ßßßß▐██         //
//               ▒██Éßßßß▐██▌ßßßßßßßßßg███████████gßßßßßßßßßßßßßßßßßßßßß½▒██████████░ßßßßßßßßß██▓ßß▒██          //
//                ▐███▒É░██▌ßßßßßßß▐███▀         ▀███▌ßßßßßßßßßßßßßßßß███▌         ~▓██@ßßßßßßß█████▓           //
//                   ▓████▌ßßßßgßÉ▒█▌       __      ▀██ßßßßßßßßßßßßß▐██       __       ██ß▐▌▌ßßß██▀             //
//                     ██▓ßßßßß████L     ▐██████      █▌ßßßßßßßßßßßß██     τ██████      █████ßßß▐██             //
//                    q██ßßßßßßßßÉ█_     ███████      █▌ßßßßßßßßßßßß█▓     ███████Ñ     ▒█Éßßßßßß▒█▌            //
//                    ██ßßßßßßßßßß██▄    ~█████▌    _██ßßßßßßßßßßßßß▐█@     ██████     ██ßßßßßßßßß██            //
//                   ██▌ßßßßßßßßßßß▐██@_         _½██▓ßßßÉÉ½gg░░½Éßßß▐███_          g███ßßßßßßßßßß▓█L           //
//                   ██ßßßßßßßßßßßßßßÉ▓███████████▓Éßßß████████████ßßßßß░████████████▌ßßßßßßßßßßßßß██           //
//                   ██ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß████████████ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß██           //
//                   ██ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß▐█████████Éßßßßßßßßßßßßßßßß▐@@@%▌ßßßßßßßßßß██           //
//                   ▒█▐ßßßßßßßßßßßß▐@▓▓▓@▌ßßßßßßßßßßßßßßß▐█████Éßßßßßßßßßßßßßßßßß▐▓▓▓▓▓▓▌ßßßßßßßß▐█▌           //
//                   ~██ßßßßßßßßßßßß▓▓▓▓▓▓@ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß▐M▓▓▓▓ÑÉßßßßßßßÉ██            //
//                    ▐██ßßßßßßßßßßß▐ÑÑ▓ÑÑ▌ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß▐▐▌Éßßßßßßßßß██"            //
//                     ▀██½ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÉ██▀             //
//                       ███ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÉ███████Bßßßßßßßßßßßßßßßßßßßßßßßßßßßß▐██               //
//                        ▀███ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÉÉÉÉßßßßßßßßßßßßßßßßßßßßßßßßßßßßß▐███                //
//                          ▐███½ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß@███                  //
//                             ████½ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß▐███▓                    //
//                               ▀████@ÉßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÉ▒████                       //
//                                   ▓█████gßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßg█████▓                          //
//                                       ▐███████@▌ßßßßßßßßßßßßßßßßßßßßß▐▒███████╜                              //
//                                             ▓███████████████████████████▌                                    //
//                                            ▐██ßßßßßßßW░░▓▓▓▓▓@Ñ#Éßßß▓██                                      //
//                                           ▒█▓ßßßßßßßßßßßßßßßßßßßßßßßß▐██                                     //
//                                          @█▓ßßßßßßßßßßßßßßßßßßßßßßßßßßÉ██                                    //
//                                         τ██ßßßßßßßßßßßßßßßßßßßßßßßßßßßß▐██                                   //
//                                         ██ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß▓█L                                  //
//                                        ▒█▌ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß██                                  //
//                                        █▓▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█                                  //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//    ---                                                                                                       //
//    asciiart.club                                                                                             //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract CAT is ERC721Creator {
    constructor() ERC721Creator("Namineko Island", "CAT") {}
}
