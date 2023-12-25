
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: loulanweu
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////
//                                              //
//                                              //
//          ___       ___           ___         //
//         /  /\     /  /\         /  /\        //
//        /  /:/    /  /::\       /  /:/        //
//       /  /:/    /  /:/\:\     /  /:/         //
//      /  /:/    /  /:/  \:\   /  /:/          //
//     /__/:/    /__/:/ \__\:\ /__/:/     /\    //
//     \  \:\    \  \:\ /  /:/ \  \:\    /:/    //
//      \  \:\    \  \:\  /:/   \  \:\  /:/     //
//       \  \:\    \  \:\/:/     \  \:\/:/      //
//        \  \:\    \  \::/       \  \::/       //
//         \__\/     \__\/         \__\/        //
//                                              //
//                                              //
//////////////////////////////////////////////////


contract LOU is ERC1155Creator {
    constructor() ERC1155Creator("loulanweu", "LOU") {}
}
