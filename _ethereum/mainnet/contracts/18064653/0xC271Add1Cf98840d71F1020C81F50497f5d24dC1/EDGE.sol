// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Edge of Euphoria
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                                                                                               //
//    ___________    .___                       _____  ___________            .__                 .__            //
//    \_   _____/  __| _/ ____   ____     _____/ ____\ \_   _____/__ ________ |  |__   ___________|__|____       //
//     |    __)_  / __ | / ___\_/ __ \   /  _ \   __\   |    __)_|  |  \____ \|  |  \ /  _ \_  __ \  \__  \      //
//     |        \/ /_/ |/ /_/  >  ___/  (  <_> )  |     |        \  |  /  |_> >   Y  (  <_> )  | \/  |/ __ \_    //
//    /_______  /\____ |\___  / \___  >  \____/|__|    /_______  /____/|   __/|___|  /\____/|__|  |__(____  /    //
//            \/      \/_____/      \/                         \/      |__|        \/                     \/     //
//                                                                                                               //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract EDGE is ERC721Creator {
    constructor() ERC721Creator("Edge of Euphoria", "EDGE") {}
}
