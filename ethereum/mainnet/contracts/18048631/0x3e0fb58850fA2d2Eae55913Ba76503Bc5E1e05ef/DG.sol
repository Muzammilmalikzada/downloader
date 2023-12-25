// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Distributed Gallery
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                               //
//                                                                                                                               //
//    ________  .__         __         ._____.           __             .___   ________       .__  .__                           //
//    \______ \ |__| ______/  |________|__\_ |__  __ ___/  |_  ____   __| _/  /  _____/_____  |  | |  |   ___________ ___.__.    //
//     |    |  \|  |/  ___|   __\_  __ \  || __ \|  |  \   __\/ __ \ / __ |  /   \  ___\__  \ |  | |  | _/ __ \_  __ <   |  |    //
//     |    `   \  |\___ \ |  |  |  | \/  || \_\ \  |  /|  | \  ___// /_/ |  \    \_\  \/ __ \|  |_|  |_\  ___/|  | \/\___  |    //
//    /_______  /__/____  >|__|  |__|  |__||___  /____/ |__|  \___  >____ |   \______  (____  /____/____/\___  >__|   / ____|    //
//            \/        \/                     \/                 \/     \/          \/     \/               \/       \/         //
//                                                                                                                               //
//                                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DG is ERC721Creator {
    constructor() ERC721Creator("Distributed Gallery", "DG") {}
}