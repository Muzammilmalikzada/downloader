// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Gutter Records
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                     //
//                                                                                                     //
//      ________        __    __                 __________                              .___          //
//     /  _____/ __ ___/  |__/  |_  ___________  \______   \ ____   ____  ___________  __| _/______    //
//    /   \  ___|  |  \   __\   __\/ __ \_  __ \  |       _// __ \_/ ___\/  _ \_  __ \/ __ |/  ___/    //
//    \    \_\  \  |  /|  |  |  | \  ___/|  | \/  |    |   \  ___/\  \__(  <_> )  | \/ /_/ |\___ \     //
//     \______  /____/ |__|  |__|  \___  >__|     |____|_  /\___  >\___  >____/|__|  \____ /____  >    //
//            \/                       \/                \/     \/     \/                 \/    \/     //
//                                                                                                     //
//                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////


contract GR is ERC1155Creator {
    constructor() ERC1155Creator("Gutter Records", "GR") {}
}
