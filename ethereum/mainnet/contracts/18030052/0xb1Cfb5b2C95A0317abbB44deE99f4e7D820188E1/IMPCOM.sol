// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Impostor Commissions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ████████████████████████████████████████████████████████████████████████████████    //
//                                                                                        //
//    ██▌                                                                         ▐███    //
//                                                                                        //
//    ███                                     ,,,,                                 ███    //
//                                                                                        //
//    ███                            ,▄▄P▀▀-`"▀▀██▓▓▄▀▀ⁿ═▄,                        ▐██    //
//                                                                                        //
//    ███                         ▄▀▀─^`            ╘▄▄,   `▀N▄                    ▐██    //
//                                                                                        //
//    ███µ                    ,▄▀▄`       ▄'            -▀+, ∞ ▀▄                  ▐██    //
//                                                                                        //
//    ███▌                  ,▓█▀   ,     █-                 ▀▄ ▀▄▀                 ▐██    //
//                                                                                        //
//    ███▌                 ▓▀▄' ▄ ,▌y    ▌ ░        'N,       ▀▄ ▀█▄               ▐██    //
//                                                                                        //
//    ████               ▄▀█▓  █  █ ▌   ▐              ▀▄ ▀  & ╙▄  ▀▌.             ▐██    //
//                                                                                        //
//    ████              ▐¬█▐" ▐`  █▐    ▐ ▐  █           ▄ ▀▄ ▀▄█▌╖ ▀▄,"¬,         ▐██    //
//                                                                                        //
//    ████              █,▌▌  ▐   ▌║▌    ▄ ▌  █         ¬ ▌ ▐▄  ██▒   ██▄ '╕       ███    //
//                                                                                        //
//    ████              ▌██,█  ▌░▐█▓░▌   "▄▐⌐  █       , █▐  ▐▄▀▄█▄▒ ⌐ █▀█  ╙      ███    //
//                                                                                        //
//    ████▌            ▐███▓██ ▐▄ █▀▒░▀,   ▀▀▄ `█▄  █   █▄█¬U █ ▐███ ▐ ▐▌"█  ╘     ███    //
//                                                                                        //
//    ████▌             ▌▐█▓▌╙▒▄█▀▄▌`╙╙▒▀▄▄▄▀▄ █▄██▄ ▀▄  ██▄█ █U██▓▌█▄▌ █U▐█  ╘    ███    //
//                                                                                        //
//    ████▌             ▌▐███▄▄▄▄▄▄▒    ▄▓▀▓██▌▄▌░░▒,▀∞██▄█▀▀▀▓█▓▓▓████ █[ █▌      ███    //
//                                                                                        //
//    █████             ▌▐████▌▀▀▄▒▒▀█r "▀███████▒█▌██M▄`▒█  ▐███▓▓▓▓█▐▄█[ ▐█      ███    //
//                                                                                        //
//    █████            ,Ω▀█░█████████▀▌    ▐▄   ▀▓▓█▀█▀▀ ▒█  ▀▌▐▒▀╢▓▓▓██▌` ▐▒▌     ███    //
//                                                                                        //
//    █████            ▌█  ███ ╙█▓▀▀▄▀`     '`  ▄▄▄4∞   ]▒█ j█▌╙▒,█╢▓▓▓▌   █▒▌     ███    //
//                                                                                        //
//    █████           ██ ╓` ██▀▌.▄∞─                    ▒▒█ ▐██▀▐▌ █▓▓▓▌  ,▌▒▌     ███    //
//                                                                                        //
//    █████          ╒▀' ▌ ▐▓▌        ╖╜                ▒░█  ▐▀,█ ░▐▌▓▓▌  █▒█      ███    //
//                                                                                        //
//    ████▌          ▌█▄█- █▐▌        *╦▄`              ▒██  █▄▀ ▄▓██▓▓█▄█▒▄▀     ▐███    //
//                                                                                        //
//    ████          █ █▀█  █▐█▌         ─     ,▄▄∞     ]█▀▌  █` ▄█▓██▓▓█`██▀      ▐███    //
//                                                                                        //
//    ████          ▌ ▌▌▌  ▌▐█▀▒,   "▀▀▀▀ `            ▄▀Å⌐ █▀,██▀█▀▐▓▓ █▀        ▐███    //
//                                                                                        //
//    ███▌          ▌█ U`  ▌▐▒█▀▄▒,      ▀▀▀          ▄`ƒ█ █████▌█   ▌▌           ▐███    //
//                                                                                        //
//    ███           `▀ H`▐▌▌█▐▒█▄▀▄▄╖             ,▄██,███████▀ ▀    █-           ▐███    //
//                                                                                        //
//    ███              ╙▌▌ ▌▌▐╙█████████ß▄▄▄███████████▀╜▒▐▀         █            ▐███    //
//                                                                                        //
//    ██▌               █- █▀▓.▐█ ▀▀ ▀▀▀██▀▀▀▀▀██████▀    ▒█▒R¥∞w▄   `            ▐███    //
//                                                                                        //
//    ██▌               ▐                  ,▄▄M████▀      ║▀█▓▄╢  `▀⌐             ▐███    //
//                                                                                        //
//    ██⌐                                █  *▒░▐█▀        ]▒░▀▀█    █▄▄           ████    //
//                                                                                        //
//    ██                            ,,▄▄▄▓▌  ▄ ▄▌    ,,╖p▄▄▄Å▀▀     ▀▄╨▒▀▀R▄▄,    ████    //
//                                                                                        //
//    ██                        █▀▒▒▒▒╜╜║█▄▀▀███    ╓█`               ▌ ╙` ╙╜░█   ████    //
//                                                                                        //
//    ██                       █       ┌█▀▒╜ ▀██▄▄  ▐▄▄▄  ,▄▀▀▀▀▀▀▀▀▀▀▀       `▀  ████    //
//                                                                                        //
//    ██                      █        `     ▐████████████▒`                    ▀▄▐███    //
//                                                                                        //
//    ██                    ▄▀               ▒████▀▀▀▀ ]▒`                       ╙████    //
//                                                                                        //
//    █▌                   ▄▀  ]▌           ]█████▌                       j╢▄      ███    //
//                                                                                        //
//    ██,,,,,,,,,,,▄▄▄▄▄▄▄▀   ,╠█           ██████▌                       ]▒▌       ▀█    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract IMPCOM is ERC1155Creator {
    constructor() ERC1155Creator("Impostor Commissions", "IMPCOM") {}
}