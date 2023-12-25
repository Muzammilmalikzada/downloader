// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Inkwell Echoes
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////
//                                                 //
//                                                 //
//                                                 //
//     8 8888 b.             8 8 8888     ,88'     //
//     8 8888 888o.          8 8 8888    ,88'      //
//     8 8888 Y88888o.       8 8 8888   ,88'       //
//     8 8888 .`Y888888o.    8 8 8888  ,88'        //
//     8 8888 8o. `Y888888o. 8 8 8888 ,88'         //
//     8 8888 8`Y8o. `Y88888o8 8 8888 88'          //
//     8 8888 8   `Y8o. `Y8888 8 888888<           //
//     8 8888 8      `Y8o. `Y8 8 8888 `Y8.         //
//     8 8888 8         `Y8o.` 8 8888   `Y8.       //
//     8 8888 8            `Yo 8 8888     `Y8.     //
//                                                 //
//                                                 //
//                                                 //
//                                                 //
/////////////////////////////////////////////////////


contract INK is ERC721Creator {
    constructor() ERC721Creator("Inkwell Echoes", "INK") {}
}