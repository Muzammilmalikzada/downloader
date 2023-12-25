// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Memories and Moods
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//                                                                                                //
//                                                                                                //
//     ______     ______     ______     ______     ______   __  __                                //
//    /\  __ \   /\___  \   /\  ___\   /\  == \   /\__  _\ /\ \_\ \                               //
//    \ \  __ \  \/_/  /__  \ \  __\   \ \  __<   \/_/\ \/ \ \____ \                              //
//     \ \_\ \_\   /\_____\  \ \_____\  \ \_\ \_\    \ \_\  \/\_____\                             //
//      \/_/\/_/   \/_____/   \/_____/   \/_/ /_/     \/_/   \/_____/                             //
//                                                                                                //
//     ______     ______     ______   ______     __    __     ______     __  __                   //
//    /\  == \   /\  ___\   /\__  _\ /\  __ \   /\ "-./  \   /\  __ \   /\_\_\_\                  //
//    \ \  __<   \ \  __\   \/_/\ \/ \ \  __ \  \ \ \-./\ \  \ \  __ \  \/_/\_\/_                 //
//     \ \_____\  \ \_____\    \ \_\  \ \_\ \_\  \ \_\ \ \_\  \ \_\ \_\   /\_\/\_\                //
//      \/_____/   \/_____/     \/_/   \/_/\/_/   \/_/  \/_/   \/_/\/_/   \/_/\/_/                //
//                                                                                                //
//     __    __     ______     __    __     ______     ______     __     ______     ______        //
//    /\ "-./  \   /\  ___\   /\ "-./  \   /\  __ \   /\  == \   /\ \   /\  ___\   /\  ___\       //
//    \ \ \-./\ \  \ \  __\   \ \ \-./\ \  \ \ \/\ \  \ \  __<   \ \ \  \ \  __\   \ \___  \      //
//     \ \_\ \ \_\  \ \_____\  \ \_\ \ \_\  \ \_____\  \ \_\ \_\  \ \_\  \ \_____\  \/\_____\     //
//      \/_/  \/_/   \/_____/   \/_/  \/_/   \/_____/   \/_/ /_/   \/_/   \/_____/   \/_____/     //
//                                                                                                //
//     __    __     ______     ______     _____     ______                                        //
//    /\ "-./  \   /\  __ \   /\  __ \   /\  __-.  /\  ___\                                       //
//    \ \ \-./\ \  \ \ \/\ \  \ \ \/\ \  \ \ \/\ \ \ \___  \                                      //
//     \ \_\ \ \_\  \ \_____\  \ \_____\  \ \____-  \/\_____\                                     //
//      \/_/  \/_/   \/_____/   \/_____/   \/____/   \/_____/                                     //
//                                                                                                //
//                                                                                                //
//                                                                                                //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////


contract ABMandM is ERC721Creator {
    constructor() ERC721Creator("Memories and Moods", "ABMandM") {}
}