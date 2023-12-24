// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: LOL GIF By Vijay!
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//       _____                _           _   ____         __      ___ _                 //
//      / ____|              | |         | | |  _ \        \ \    / (_|_)                //
//     | |     _ __ ___  __ _| |_ ___  __| | | |_) |_   _   \ \  / / _ _  __ _ _   _     //
//     | |    | '__/ _ \/ _` | __/ _ \/ _` | |  _ <| | | |   \ \/ / | | |/ _` | | | |    //
//     | |____| | |  __/ (_| | ||  __/ (_| | | |_) | |_| |    \  /  | | | (_| | |_| |    //
//      \_____|_|  \___|\__,_|\__\___|\__,_| |____/ \__, |     \/   |_| |\__,_|\__, |    //
//                                                   __/ |           _/ |       __/ |    //
//                                                  |___/           |__/       |___/     //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract GifByVJ is ERC721Creator {
    constructor() ERC721Creator("LOL GIF By Vijay!", "GifByVJ") {}
}
