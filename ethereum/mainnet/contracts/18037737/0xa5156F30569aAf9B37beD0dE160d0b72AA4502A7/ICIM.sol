// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Infinite Colors
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                  //
//                                                                                                                                  //
//                                                                                                                                  //
//      _              ___  _             _   _                                        _                           _   __           //
//     (_)           .' ..](_)           (_) / |_                                     / |_                        / |_[  |          //
//     __   _ .--.  _| |_  __   _ .--.   __ `| |-'.---.   _ .--..--.   ,--.   _ .--. `| |-'_ .--.  ,--.     .---.`| |-'| |--.       //
//    [  | [ `.-. |'-| |-'[  | [ `.-. | [  | | | / /__\\ [ `.-. .-. | `'_\ : [ `.-. | | | [ `/'`\]`'_\ :   / /__\\| |  | .-. |      //
//     | |  | | | |  | |   | |  | | | |  | | | |,| \__.,  | | | | | | // | |, | | | | | |, | |    // | |, _| \__.,| |, | | | |      //
//    [___][___||__][___] [___][___||__][___]\__/ '.__.' [___||__||__]\'-;__/[___||__]\__/[___]   \'-;__/(_)'.__.'\__/[___]|__]     //
//                                                                                                                                  //
//                                                                                                                                  //
//                                                                                                                                  //
//                                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ICIM is ERC721Creator {
    constructor() ERC721Creator("Infinite Colors", "ICIM") {}
}