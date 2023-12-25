// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Upside Down World
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    https://asciiart.club/view.php?art=7cWGtzk                                          //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//    ████████████████████████████████████████████████████████████████████████████████    //
//                                                                                        //
//    ███████████████▀└╫███╬▒'φ╠█'\╣███████████████████▌╠█▒"╟█╬█████╬▀████████████████    //
//                                                                                        //
//    ████████████▀└   ╟██████▓█████████████████▓██████████▓▓███████▒╠▒╙██████████████    //
//                                                                                        //
//    ██████████▀'┌.   ╟███████████████████████▓▓███████████████████▒╠▒░░╙▀███████████    //
//                                                                                        //
//    ████████▀  ''''..╟██████╬███▒███████████▓╬████████╬███▌███████▒▒▒░░φφ╚████████╬█    //
//                                                                                        //
//    ███████'  ▄█▀φ;╔▒╣████▓█▓██▓▌██████████▓▓▓████████▓███▓██▓████▒▒▒▒▒░▄░░╙██████▓█    //
//                                                                                        //
//    █████▀    ╙. ╟█▓▓▓██████▓██▓▌▓▓▓██████▓█▓▓████████╣█▓▓▓▓█▓████╬╬▓█░.╟█░░░████▓▓█    //
//                                                                                        //
//    ████─     ,▓▄╙█╬╠▓██████╫█▓▓▌▓▓▓██████╫█╣████████▓╣█▓▓▓▓▓▓▓████▓██▓Å▓▄░░░░╙█▓▓▓█    //
//                                                                                        //
//    ███       ▀▀███╫╬╣▓▓████▌█▓▓▓▓▓╣██████╬█▓█████████▓█▓▓▓▓▓███▄█▓╣██╦∩░█░░░░░╙████    //
//                                                                                        //
//    ██          ^▀█╠╣▓██╬███╬█▓▓▓▓▓▓███████▓▓███████▓▓╣▓▓▓▓▓▓▓▓████╬█▓▀▒░░░░░░░░╙███    //
//                                                                                        //
//    █─              ╙▓╬╠╣█████▓▓▓▓▓▓███████████████▓╬╣╣▓▓▓▓▓▓█╣█▒█╬╬▒░░░░░░░░░└''╟██    //
//                                                                                        //
//    ▌                ▐██▒▓█▀▀▀▀▀▀▓▓▓███████████████▓▓╬╨╙╙╙╙╙╠▓▓███▒▒▒░░░░░░░││..  ██    //
//                                                                                        //
//                     ▐██▒█╩▀"▀░,f╙▀█╬███▒╫█▓║██▒▓██▓▓▀δ≥Θ╠▀╙▒╬╬███▒▒▒░░░░░░░│''   ╟█    //
//                                                                                        //
//                     ▐█╬╣▓██ .░░░░░░║███▌███╢▓█▌███▒⌐  .▄▌█▀█╬╠█╬█▒▒▒░░░░░░│.'     █    //
//                                                                                        //
//                     ▐▓╬▒▓▓▓φ░░░░░░░╟█▓║██╙██╩╟█▓╙▓╬▒∩  █╬██▒░╠█╠▓▒▒░░░░░░░│'''    █    //
//                                                                                        //
//                     ▐▓╣╬▓╬░╠▒░░░!░░╚██╟██▒██▓╬██▒╬╩░░ ,▓▓▓▌▒░║█╠▓▒▒░░░░░░░│''     ╫    //
//                                                                                        //
//                     j▓╠╠╣▓▌╟▄▒░φ  ~╔▒╫█▓╫▓█▒▓█▓╣▌░╣▒▒ ▓█▓▓╫▒░╟█╠▓▒▒░░░░│░░│  '    ╫    //
//                                                                                        //
//                     j▓╠▒╬▓▓▓▓▓▌╚░ 7╚▌███╟██╬╣██╩└!╚░▓▓▒╝╫╫╫▒░╫█╠▓▒▒░░│░││░│''     █    //
//                                                                                        //
//                      ▓▒╠╬▓▓█▓▓▌7╗~τ░φ░≥░│╙Γ╙╙╩╠▒φ\▒▐▓█▌╟▓▓▓▌░▓█╬▓▒▒░░░│││││''     █    //
//                                                                                        //
//                      ▓▓╠╫▓███▓▓½╚░∩;Γ .Γ ]░░░░░╠╟[╙╙▀▓▒██▓▓▓▒██╬▌▒▒░░│││││┐ '    ▐█    //
//                                                                                        //
//    ⌐                 ▓╬▒▓▓██▓▓▓▒~-╓φ░≥⌐¡~]░≥░φ▒δ▒▌≤░░▄▌╟███▓▒██╫▌▒▒░││││││'      ██    //
//                                                                                        //
//    █                 ▓╬╠▓▓▓██▀▓∩δε▓ └""Γ "░"╚░░░▓╟b▒=▀▓╟█╣██▒██╫▌▒▒░░││││░' '   ▐██    //
//                                                                                        //
//    █▌                ▓╬╫╫▓▓███▒'"░╚░░░,,,.░░░φφ░╬░▒▄░░░██▓▓▓▌██▓▌▒▒░││││││' '  ╓███    //
//                                                                                        //
//    ██▌               ╣▓▓▓╣██▓▓▌▒]▒▄▒░░░;░.┌└░░░░╟▒▌╩╙]▒▓██╣█▌██▌▌▒▒░││││││'   j████    //
//                                                                                        //
//    ███▌              ╫▓▓█▓▓███▒▒▒▒╚▒Γ"""""""░░░░░░░▒░░░╚╚░░╚╠██▓▌▒▒░││││││' │╓█████    //
//                                                                                        //
//    █████             ╫▓██▀▀▀╙╙└│ -'"└░░░░~...¡░░░░░░░░░░░'░░░╚██╬╠╠░│││░¡│'.▄██████    //
//                                                                                        //
//    ██████▄           ╣╟▒   ."░' .';   ;░" ""~,'░░░░░░Q▄▓▓▓▒░""╙█▌╠╠▒░░││││¡▓███████    //
//                                                                                        //
//    ████████          ╫▒ ┌.░,▒▄░▄▄▄¼╓∩▄▄▄██▓▓▌▄█▄╔φ▓╫█▓░▓██╣▌   ╙▌╠╠╠▒░░░░▄█████████    //
//                                                                                        //
//    █████████▌        ╜~'φ▒▓▓╟╣▒╣▓▓█▓████╬╠╠╟▓██▓▌▒█╫█▓▓║▓▓╣█▒τ ░╙╠╠╠▒░░▄███████████    //
//                                                                                        //
//    ███████████▓ç       ]╫████▓▒▓╣╣▓▓█▓▓▓╬╬▒╬╣╣█▓╬╬▓╣█▓▓▌╟▓╢▓▓▌:Γ ^╠╩░▓█████████████    //
//                                                                                        //
//    ██████████████▄, ╠~"▐██▓█▓▓▒╣╬▓▓▓▓▓▓█▌╠╬╬╣╣▓█╫▓▓▓▓▓▓▓╟╬╫▓▌█▌░[:▒╠╬██████████████    //
//                                                                                        //
//    █████████████████⌐''!╣█▓▓█▌φ██▓█▓▓████▓φ▓╬╬██╣▓▒█▓╬╬╫▒╠╟╣╬╬╬╬▄▄╬▒╠╠█████████████    //
//                                                                                        //
//    ╬████████████████▌φ░░╠╬╬╬╬╬╬█████████████▓╝╬▓╬╠╠╣╩╩╩╬▓╬╬▄▄▓▓▓██▌╬▒╠╣████████████    //
//                                                                                        //
//    ▓╬╬╬╬╬████████████▄╩▄φ╫▌▓▓▄▄▄▒▒╙╙╙╙╙╙╙╙╙│░░╙░░░░░▄▄▓████████████▒╠▒╠████████████    //
//                                                                                        //
//    ╬╬╬▓▓╬╬╣╬╬╬████████████╫█████████████████▄▓█████╟████████████████╠▒╬╬███████████    //
//                                                                                        //
//         └└└└└└└ └└└└└└└└└└ └└└└└└└└└ └└└└ └     └└└└ └ └└└└└└└└└└└└└    └└└└└└└└└└└    //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract UDW is ERC721Creator {
    constructor() ERC721Creator("Upside Down World", "UDW") {}
}