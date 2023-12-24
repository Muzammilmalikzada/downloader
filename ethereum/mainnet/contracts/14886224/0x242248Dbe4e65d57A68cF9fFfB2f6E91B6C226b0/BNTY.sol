
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: HPPRS BOUNTY
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                                                                                                                                     //
//                                                                                                                                                                                                                                                                                                                                     //
//                                                                                                                                                                                                                                                                                                                                     //
//    echo " ▄█     █▄     ▄████████  ▄█        ▄████████  ▄██████▄     ▄▄▄▄███▄▄▄▄      ▄████████          ███      ▄██████▄           ███        ▄█    █▄       ▄████████         ▄█    █▄       ▄███████▄    ▄███████▄    ▄████████    ▄████████      ▀█████████▄   ▄██████▄  ███    █▄  ███▄▄▄▄       ███     ▄██   ▄        ";    //
//    echo "███     ███   ███    ███ ███       ███    ███ ███    ███  ▄██▀▀▀███▀▀▀██▄   ███    ███      ▀█████████▄ ███    ███      ▀█████████▄   ███    ███     ███    ███        ███    ███     ███    ███   ███    ███   ███    ███   ███    ███        ███    ███ ███    ███ ███    ███ ███▀▀▀██▄ ▀█████████▄ ███   ██▄      ";    //
//    echo "███     ███   ███    █▀  ███       ███    █▀  ███    ███  ███   ███   ███   ███    █▀          ▀███▀▀██ ███    ███         ▀███▀▀██   ███    ███     ███    █▀         ███    ███     ███    ███   ███    ███   ███    ███   ███    █▀         ███    ███ ███    ███ ███    ███ ███   ███    ▀███▀▀██ ███▄▄▄███      ";    //
//    echo "███     ███  ▄███▄▄▄     ███       ███        ███    ███  ███   ███   ███  ▄███▄▄▄              ███   ▀ ███    ███          ███   ▀  ▄███▄▄▄▄███▄▄  ▄███▄▄▄           ▄███▄▄▄▄███▄▄   ███    ███   ███    ███  ▄███▄▄▄▄██▀   ███              ▄███▄▄▄██▀  ███    ███ ███    ███ ███   ███     ███   ▀ ▀▀▀▀▀▀███      ";    //
//    echo "███     ███ ▀▀███▀▀▀     ███       ███        ███    ███  ███   ███   ███ ▀▀███▀▀▀              ███     ███    ███          ███     ▀▀███▀▀▀▀███▀  ▀▀███▀▀▀          ▀▀███▀▀▀▀███▀  ▀█████████▀  ▀█████████▀  ▀▀███▀▀▀▀▀   ▀███████████      ▀▀███▀▀▀██▄  ███    ███ ███    ███ ███   ███     ███     ▄██   ███      ";    //
//    echo "███     ███   ███    █▄  ███       ███    █▄  ███    ███  ███   ███   ███   ███    █▄           ███     ███    ███          ███       ███    ███     ███    █▄         ███    ███     ███          ███        ▀███████████          ███        ███    ██▄ ███    ███ ███    ███ ███   ███     ███     ███   ███      ";    //
//    echo "███ ▄█▄ ███   ███    ███ ███▌    ▄ ███    ███ ███    ███  ███   ███   ███   ███    ███          ███     ███    ███          ███       ███    ███     ███    ███        ███    ███     ███          ███          ███    ███    ▄█    ███        ███    ███ ███    ███ ███    ███ ███   ███     ███     ███   ███      ";    //
//    echo " ▀███▀███▀    ██████████ █████▄▄██ ████████▀   ▀██████▀    ▀█   ███   █▀    ██████████         ▄████▀    ▀██████▀          ▄████▀     ███    █▀      ██████████        ███    █▀     ▄████▀       ▄████▀        ███    ███  ▄████████▀       ▄█████████▀   ▀██████▀  ████████▀   ▀█   █▀     ▄████▀    ▀█████▀       ";    //
//    echo "                         ▀                                                                                                                                                                                      ███    ███                                                                                           ";    //
//    echo " ▄█  ███▄▄▄▄      ▄████████     ███        ▄████████ ███    █▄   ▄████████     ███      ▄█   ▄██████▄  ███▄▄▄▄      ▄████████  ▄█               ▄████████    ▄████████  ▄████████     ███      ▄█   ▄██████▄  ███▄▄▄▄                                                                                                ";    //
//    echo "███  ███▀▀▀██▄   ███    ███ ▀█████████▄   ███    ███ ███    ███ ███    ███ ▀█████████▄ ███  ███    ███ ███▀▀▀██▄   ███    ███ ███              ███    ███   ███    ███ ███    ███ ▀█████████▄ ███  ███    ███ ███▀▀▀██▄                                                                                              ";    //
//    echo "███▌ ███   ███   ███    █▀     ▀███▀▀██   ███    ███ ███    ███ ███    █▀     ▀███▀▀██ ███▌ ███    ███ ███   ███   ███    ███ ███              ███    █▀    ███    █▀  ███    █▀     ▀███▀▀██ ███▌ ███    ███ ███   ███                                                                                              ";    //
//    echo "███▌ ███   ███   ███            ███   ▀  ▄███▄▄▄▄██▀ ███    ███ ███            ███   ▀ ███▌ ███    ███ ███   ███   ███    ███ ███              ███         ▄███▄▄▄     ███            ███   ▀ ███▌ ███    ███ ███   ███                                                                                              ";    //
//    echo "███▌ ███   ███ ▀███████████     ███     ▀▀███▀▀▀▀▀   ███    ███ ███            ███     ███▌ ███    ███ ███   ███ ▀███████████ ███            ▀███████████ ▀▀███▀▀▀     ███            ███     ███▌ ███    ███ ███   ███                                                                                              ";    //
//    echo "███  ███   ███          ███     ███     ▀███████████ ███    ███ ███    █▄      ███     ███  ███    ███ ███   ███   ███    ███ ███                     ███   ███    █▄  ███    █▄      ███     ███  ███    ███ ███   ███                                                                                              ";    //
//    echo "███  ███   ███    ▄█    ███     ███       ███    ███ ███    ███ ███    ███     ███     ███  ███    ███ ███   ███   ███    ███ ███▌    ▄         ▄█    ███   ███    ███ ███    ███     ███     ███  ███    ███ ███   ███                                                                                              ";    //
//    echo "█▀    ▀█   █▀   ▄████████▀     ▄████▀     ███    ███ ████████▀  ████████▀     ▄████▀   █▀    ▀██████▀   ▀█   █▀    ███    █▀  █████▄▄██       ▄████████▀    ██████████ ████████▀     ▄████▀   █▀    ▀██████▀   ▀█   █▀                                                                                               ";    //
//    echo "                                          ███    ███                                                                          ▀                                                                                                                                                                                      ";    //
//                                                                                                                                                                                                                                                                                                                                     //
//                                                                                                                                                                                                                                                                                                                                     //
//                                                                                                                                                                                                                                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BNTY is ERC1155Creator {
    constructor() ERC1155Creator() {}
}
