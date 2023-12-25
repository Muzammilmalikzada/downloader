// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 2A ELITE PASS
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////
//                                                              //
//                                                              //
//    ________    _____    ___________.__  .__  __              //
//    \_____  \  /  _  \   \_   _____/|  | |__|/  |_  ____      //
//     /  ____/ /  /_\  \   |    __)_ |  | |  \   __\/ __ \     //
//    /       \/    |    \  |        \|  |_|  ||  | \  ___/     //
//    \_______ \____|__  / /_______  /|____/__||__|  \___  >    //
//            \/       \/          \/                    \/     //
//                                                              //
//                                                              //
//////////////////////////////////////////////////////////////////


contract GUN is ERC1155Creator {
    constructor() ERC1155Creator("2A ELITE PASS", "GUN") {}
}