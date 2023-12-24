// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Dark Diaries
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////
//                                                                 //
//                                                                 //
//      ____             _      ____  _            _               //
//     |  _ \  __ _ _ __| | __ |  _ \(_) __ _ _ __(_) ___  ___     //
//     | | | |/ _` | '__| |/ / | | | | |/ _` | '__| |/ _ \/ __|    //
//     | |_| | (_| | |  |   <  | |_| | | (_| | |  | |  __/\__ \    //
//     |____/ \__,_|_|  |_|\_\ |____/|_|\__,_|_|  |_|\___||___/    //
//                                                                 //
//                                                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////


contract Dark is ERC721Creator {
    constructor() ERC721Creator("Dark Diaries", "Dark") {}
}
