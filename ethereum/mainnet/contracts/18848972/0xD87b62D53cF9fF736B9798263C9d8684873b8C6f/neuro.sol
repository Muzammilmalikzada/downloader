// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: neuroscience fiction
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                                                                                                    //
//     ██████ ██    ██ ███████ ████████  ██████  ███    ███     ██   ██  ██████  ██████  ██████   ██████  ██████      //
//    ██      ██    ██ ██         ██    ██    ██ ████  ████     ██   ██ ██    ██ ██   ██ ██   ██ ██    ██ ██   ██     //
//    ██      ██    ██ ███████    ██    ██    ██ ██ ████ ██     ███████ ██    ██ ██████  ██████  ██    ██ ██████      //
//    ██      ██    ██      ██    ██    ██    ██ ██  ██  ██     ██   ██ ██    ██ ██   ██ ██   ██ ██    ██ ██   ██     //
//     ██████  ██████  ███████    ██     ██████  ██      ██     ██   ██  ██████  ██   ██ ██   ██  ██████  ██   ██     //
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract neuro is ERC721Creator {
    constructor() ERC721Creator("neuroscience fiction", "neuro") {}
}