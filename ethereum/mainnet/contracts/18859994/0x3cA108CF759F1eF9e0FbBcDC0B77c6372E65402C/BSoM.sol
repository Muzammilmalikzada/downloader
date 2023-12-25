// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Blue Shades of Mexico
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
//    (  ___ \ ( \      |\     /|(  ____ \  (  ____ \|\     /|(  ___  )(  __  \ (  ____ \(  ____ \    //
//    | (   ) )| (      | )   ( || (    \/  | (    \/| )   ( || (   ) || (  \  )| (    \/| (    \/    //
//    | (__/ / | |      | |   | || (__      | (_____ | (___) || (___) || |   ) || (__    | (_____     //
//    |  __ (  | |      | |   | ||  __)     (_____  )|  ___  ||  ___  || |   | ||  __)   (_____  )    //
//    | (  \ \ | |      | |   | || (              ) || (   ) || (   ) || |   ) || (            ) |    //
//    | )___) )| (____/\| (___) || (____/\  /\____) || )   ( || )   ( || (__/  )| (____/\/\____) |    //
//    |/ \___/ (_______/(_______)(_______/  \_______)|/     \||/     \|(______/ (_______/\_______)    //
//                                                                                                    //
//     _______  _______    _______  _______          _________ _______  _______                       //
//    (  ___  )(  ____ \  (       )(  ____ \|\     /|\__   __/(  ____ \(  ___  )                      //
//    | (   ) || (    \/  | () () || (    \/( \   / )   ) (   | (    \/| (   ) |                      //
//    | |   | || (__      | || || || (__     \ (_) /    | |   | |      | |   | |                      //
//    | |   | ||  __)     | |(_)| ||  __)     ) _ (     | |   | |      | |   | |                      //
//    | |   | || (        | |   | || (       / ( ) \    | |   | |      | |   | |                      //
//    | (___) || )        | )   ( || (____/\( /   \ )___) (___| (____/\| (___) |                      //
//    (_______)|/         |/     \|(_______/|/     \|\_______/(_______/(_______)                      //
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BSoM is ERC721Creator {
    constructor() ERC721Creator("Blue Shades of Mexico", "BSoM") {}
}