// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: HONEMARU
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////
//                                                                 //
//                                                                 //
//     __ __   ___   ____     ___  ___ ___   ____  ____  __ __     //
//    |  |  | /   \ |    \   /  _]|   |   | /    ||    \|  |  |    //
//    |  |  ||     ||  _  | /  [_ | _   _ ||  o  ||  D  )  |  |    //
//    |  _  ||  O  ||  |  ||    _]|  \_/  ||     ||    /|  |  |    //
//    |  |  ||     ||  |  ||   [_ |   |   ||  _  ||    \|  :  |    //
//    |  |  ||     ||  |  ||     ||   |   ||  |  ||  .  \     |    //
//    |__|__| \___/ |__|__||_____||___|___||__|__||__|\_|\__,_|    //
//                                                                 //
//                                                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////


contract HONEMARU is ERC721Creator {
    constructor() ERC721Creator("HONEMARU", "HONEMARU") {}
}