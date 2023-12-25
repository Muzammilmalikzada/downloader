// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Julia Sky Editions
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                      ,φ    //
//                                                                                  ,▄▒╬▒╣    //
//                                                                                .██▓▓▓▓╩    //
//                                     ;░░░░░░░░░░░░;                            ╓██▓▓╩╙░░    //
//                                  ;░░░░░░░░░░░░░░░░░│'░░░░░]φ▓▓▄µ░''░░,   ,,░φ▓█▓▓╙░░░░░    //
//                                ░░░░░░░░░░░$░░░│'  '││.' ░░'╙█████░  '░φ▓░░░φ█▓█░░░░░  ░    //
//                            ,▄▄██████▀██▄░╠▓▄▄░░░   '    ¡▐▓'╙███╫█▒  '░╠░░║██▒░░░Γ'  ░░    //
//                         ▄███████████▄∩╙▀██▒║██∩░│'  .░░░░╙▒  └▀██▓▒░░░░╠█▓█╬╬▒░░░  ░░░│    //
//                       ,██████████████▌▒▄░╙╙▀╩*∩'  ░░│░░░░░║    ╙█╩░░░░░║███╠▒░░░░░░░░░'    //
//                      ╔█████████████████▒▒░░ ''░░░'││ '''''    │'░░░░░░φ║██████▒░░░░░│░╓    //
//                    ╓███████▓█████████████▒░░▐▓█░░░░░          │░░░░░░░╠╣█████▀░│░░░░▄██    //
//                 .φ▓██▓▓▓█▓████████████████▓░⌠▓▓▒╠φ▒"░░░     │'░░░░░░░φ║██████∩░░░░▄█╬▓█    //
//                ░║██████▓███████████████████ε ║█▒░▒▓█▄▒░░   │░░░░░░▒φ╠║▓██████▄░░▄█╣▓███    //
//             ;░░φ███████████████████▓███████▌░║██░░╬██╬░░░░░░░░░░▒▒╬╠╣▓██╬█████████▓████    //
//           ░░░░φ╣████████████████████████████▒░╣█▌░░░╚▒░░░░░░φφ╠╬╬╬╣╣▓███▓█████████████╙    //
//          ¡░░░░╠██████████████████████████████░░╚██░╠╬░░░░░▒╠╠╠╬╣▓▓█████████████████▀┌░░    //
//            │'░║███████████████████████╬██████▒░░░╠▀▒▒░░φ▒╠╬╣╣▓▓█████████████████▀░░φ░░░    //
//            "░φ║██████████████████████▓████████╬▓▒╬╠╬╬╬╬╬╣▓██████░╠█████████████╬▒░φ▒▒▒░    //
//               ╙█████████████████████▓████████████▓▓▓▓█████████╠╬▒█████████████╬╬╬▒╠╬░░░    //
//               ⌠█████████████████████████████████████████████╙╚║███████║▌████████╬╬╬░░░░    //
//                ║█████████████████████████████████████████▓╣████████████████████~╙╣▓▒░░░    //
//                ╚██████████████████████████████████████████████████████║████████░  ╙▓▒░░    //
//                 ║████████████████████████████████████████████████████████████▒░    ^╫▒▒    //
//                 ^╫██████████████████▓█████████████████████▒▒░║████████████████▒░     ╙╣    //
//                  ╙████████████████████████████████████████╩░╠╚╠█▀▀╙╙╙╙╙╚╚╙╙╙╙╙╙░≥,         //
//                   ╙██████████████████████████████████████▌░φ▒φ╠██▓░║░░░░░░░░░░░░░░│░░≥,    //
//                    ╙▓████████████████████████████████████▌░░░░φ▓██▓███▒░░░░φ░░░░░░░░░░░    //
//                     ;║████████████████████████████████████╠░░φ▓██╬╩░╚║▒░░▒╚░░░░││░░░░░░    //
//                  ]██████▀█████████████████████████████████▒░░║█▒╠Γ╚╚Σ░░φ░░░░░││││'│''││    //
//                  ╫████░φφφ▓████████████████████████████████▒░╩╚╫▒░▒▒╩╚░░░░░░░░░░░░░.│      //
//                  ╚██████████████████████████████████████████▄░░░▒░░▒░░░░░░░φ▄▄▄█▄▄▄▄░░░    //
//                   ╙▀█████▓█████████████████████████████████████████████▓███████████████    //
//                     ¡║████████████████████████████████████████████████████████████▓████    //
//                     ▐████▒╠▓███████████████████████████████████████████████████████████    //
//                ,,,╓╓φ╣████████████████████████████████████████████████████████████████▓    //
//           ╓███████████████████████████████████████████████████████████████████████████▓    //
//         ]▓█████▀▀█████████████████████████████████████████████████████████████████████▒    //
//        ¡║▓██╩░░φ▄▄▄███████████████████████████████████████████████████████████████████╩    //
//         ╙╚██▒╠╣▓██████████████████████████████████████████████████████████████████▀░░░Γ    //
//           ╙╙╣▓████████████████████████╬╠█████████████████████████████████╬╙▀▀▀╙╙""'        //
//            .φ████▀▀╙╙▀███████████████╩╙╙╙▀╣▓██████████████████████████████▄                //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract JSKY is ERC721Creator {
    constructor() ERC721Creator("Julia Sky Editions", "JSKY") {}
}