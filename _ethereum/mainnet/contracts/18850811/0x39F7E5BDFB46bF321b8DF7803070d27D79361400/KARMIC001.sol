// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: THE SPHERE KARMIC OBJECTS — FIRST CYCLE
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ██████████████████████████████▐█████████████████████████████████████████████████████████████████████    //
//        █████████████████████████████▌████████▄██▀██████████████████████████████████████████████████████████    //
//        ██████████████████████▀▀▀███████████████████████████▌█___██_-`_▀▀▀▀█████████████████████████████████    //
//        █████▌_▐█▀-██__████'_______`█_██████████████████████▀██__██`___,,,,,▄██▄________▀███__________██████    //
//        █████▌_▐█__▀█__███____▄▄▄___,▄_▀▀▀█_____'██████████__██__▐█U___██████████▄,▄▄,____██____▄▄▄▄▄▄██████    //
//        █████▌▄▄▄▄▄▄▄▄▄██▌___▐███▌____▀▄,_________▀▀█████▀__▐█▌__▐█▌___██████████_████▌___▐█____████████████    //
//        ██████▀▀▀▀▀▀▀▀▀███____██▀▄▄_____█████▄▄______╙██____██___▐█▌___█████████▌__███▌___▐█____████████████    //
//        ██████▄▄▄__▄▄▄▄████,____Æ███▄____▀██████______█____"▀`___▐█▌_________▐██▌__▀▀-___▄██__________██████    //
//        ██████▀▀▀__▀▀▀▀███████▄___▀██________-______,██__________██▌_________▐███_r______▀██__________██████    //
//        ██████▄▄▄▄▄▄▄▄▄██___]██____╘█▌_____,_____,▄███▌____▄▄▄___██____▄▄▄▄▄▄████▀▐███____██____████████████    //
//        █████▌`▐█████████____██▌____██_____███████████▌____███___██___j████████▀-_▐███U___██____████████████    //
//        █████▌__``````└███____▀▀▀__╓██_____████████████____██▀__▐█▌___▐████▀▀█▌___▐███U___██____''''''▐█████    //
//        █████▌_▐███████████▄______▀███_____████████████▀$███▌___▐█▌__________█▌___▐███U___██__________▐█████    //
//        ████████████████████████████▄,_____█████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████▀▀██▀████▀████▀▀▀▀███▀████▀▀█▀███▀▀▀████▀▀████▀▀▀████▀██████    //
//        ████████████████████████████████████████▌▐▀,████▀▄_███_███_█▌ _██▌,_█_▐█ ███▄█▌_██_▐█_██═_█▌▄_▐█████    //
//        ████████████████████████████████████████▌.▄_███▌_▀^_██_▄▄_▄█▌▐▌▐▌,▌_█_▐▌j█████▌_,▄▌j█_`▄█_███-▐█████    //
//        ████████████████████████████████████████▌▐██▄▀█_███▌▐█ ███_█▌▐█,_█▌j█ ██▄'▀▀,██,▀▀,██▄"▀,▄██▀ _▀████    //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀    //
//                                                                                                                //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract KARMIC001 is ERC1155Creator {
    constructor() ERC1155Creator(unicode"THE SPHERE KARMIC OBJECTS — FIRST CYCLE", "KARMIC001") {}
}
