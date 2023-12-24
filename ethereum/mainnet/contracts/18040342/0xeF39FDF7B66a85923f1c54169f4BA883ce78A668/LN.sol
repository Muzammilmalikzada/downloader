// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Laurent Nguyen
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                         //
//                                                                                                         //
//    .____                                        __     _______                                          //
//    |    |   _____   __ _________   ____   _____/  |_   \      \    ____  __ __ ___.__. ____   ____      //
//    |    |   \__  \ |  |  \_  __ \_/ __ \ /    \   __\  /   |   \  / ___\|  |  <   |  |/ __ \ /    \     //
//    |    |___ / __ \|  |  /|  | \/\  ___/|   |  \  |   /    |    \/ /_/  >  |  /\___  \  ___/|   |  \    //
//    |_______ (____  /____/ |__|    \___  >___|  /__|   \____|__  /\___  /|____/ / ____|\___  >___|  /    //
//            \/    \/                   \/     \/               \//_____/        \/         \/     \/     //
//                                                                                                         //
//                                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LN is ERC721Creator {
    constructor() ERC721Creator("Laurent Nguyen", "LN") {}
}
