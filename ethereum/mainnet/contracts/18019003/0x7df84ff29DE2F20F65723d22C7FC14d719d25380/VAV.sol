// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: VAVortex
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                        //
//                                                                                                                                                                        //
//     .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.     //
//    | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |    //
//    | | ____   ____  | || |      __      | || | ____   ____  | || |     ____     | || |  _______     | || |  _________   | || |  _________   | || |  ____  ____  | |    //
//    | ||_  _| |_  _| | || |     /  \     | || ||_  _| |_  _| | || |   .'    `.   | || | |_   __ \    | || | |  _   _  |  | || | |_   ___  |  | || | |_  _||_  _| | |    //
//    | |  \ \   / /   | || |    / /\ \    | || |  \ \   / /   | || |  /  .--.  \  | || |   | |__) |   | || | |_/ | | \_|  | || |   | |_  \_|  | || |   \ \  / /   | |    //
//    | |   \ \ / /    | || |   / ____ \   | || |   \ \ / /    | || |  | |    | |  | || |   |  __ /    | || |     | |      | || |   |  _|  _   | || |    > `' <    | |    //
//    | |    \ ' /     | || | _/ /    \ \_ | || |    \ ' /     | || |  \  `--'  /  | || |  _| |  \ \_  | || |    _| |_     | || |  _| |___/ |  | || |  _/ /'`\ \_  | |    //
//    | |     \_/      | || ||____|  |____|| || |     \_/      | || |   `.____.'   | || | |____| |___| | || |   |_____|    | || | |_________|  | || | |____||____| | |    //
//    | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |    //
//    | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |    //
//     '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'     //
//                                                                                                                                                                        //
//                                                                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract VAV is ERC1155Creator {
    constructor() ERC1155Creator("VAVortex", "VAV") {}
}