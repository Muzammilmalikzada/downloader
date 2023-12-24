// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Surrogate by Lauren Lee McCarthy
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////
//                                                                 //
//                                                                 //
//                                                   O             //
//                                                  oOo            //
//    .oOo  O   o  `OoOo. `OoOo. .oOo. .oOoO .oOoO'  o   .oOo.     //
//    `Ooo. o   O   o      o     O   o o   O O   o   O   OooO'     //
//        O O   o   O      O     o   O O   o o   O   o   O         //
//    `OoO' `OoO'o  o      o     `OoO' `OoOo `OoO'o  `oO `OoO'     //
//                                         O                       //
//                                      OoO'                       //
//                                                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////


contract sro is ERC721Creator {
    constructor() ERC721Creator("Surrogate by Lauren Lee McCarthy", "sro") {}
}
