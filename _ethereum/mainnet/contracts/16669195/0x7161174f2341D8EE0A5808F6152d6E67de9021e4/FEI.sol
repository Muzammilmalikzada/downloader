// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Fables of an Extradimensional Idol
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                       //
//                                                                                                                                       //
//    ███████╗ █████╗ ██████╗ ██╗     ███████╗███████╗     ██████╗ ███████╗     █████╗ ███╗   ██╗                                        //
//    ██╔════╝██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝    ██╔═══██╗██╔════╝    ██╔══██╗████╗  ██║                                        //
//    █████╗  ███████║██████╔╝██║     █████╗  ███████╗    ██║   ██║█████╗      ███████║██╔██╗ ██║                                        //
//    ██╔══╝  ██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║    ██║   ██║██╔══╝      ██╔══██║██║╚██╗██║                                        //
//    ██║     ██║  ██║██████╔╝███████╗███████╗███████║    ╚██████╔╝██║         ██║  ██║██║ ╚████║                                        //
//    ╚═╝     ╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝     ╚═════╝ ╚═╝         ╚═╝  ╚═╝╚═╝  ╚═══╝                                        //
//                                                                                                                                       //
//    ███████╗██╗  ██╗████████╗██████╗  █████╗ ██████╗ ██╗███╗   ███╗███████╗███╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗ █████╗ ██╗         //
//    ██╔════╝╚██╗██╔╝╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██║████╗ ████║██╔════╝████╗  ██║██╔════╝██║██╔═══██╗████╗  ██║██╔══██╗██║         //
//    █████╗   ╚███╔╝    ██║   ██████╔╝███████║██║  ██║██║██╔████╔██║█████╗  ██╔██╗ ██║███████╗██║██║   ██║██╔██╗ ██║███████║██║         //
//    ██╔══╝   ██╔██╗    ██║   ██╔══██╗██╔══██║██║  ██║██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║╚════██║██║██║   ██║██║╚██╗██║██╔══██║██║         //
//    ███████╗██╔╝ ██╗   ██║   ██║  ██║██║  ██║██████╔╝██║██║ ╚═╝ ██║███████╗██║ ╚████║███████║██║╚██████╔╝██║ ╚████║██║  ██║███████╗    //
//    ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝    //
//                                                                                                                                       //
//    ██╗██████╗  ██████╗ ██╗                                                                       ██╗   ██╗██████╗                     //
//    ██║██╔══██╗██╔═══██╗██║                                                                       ██║   ██║╚════██╗                    //
//    ██║██║  ██║██║   ██║██║                                                                       ██║   ██║ █████╔╝                    //
//    ██║██║  ██║██║   ██║██║                                                                       ╚██╗ ██╔╝ ╚═══██╗                    //
//    ██║██████╔╝╚██████╔╝███████╗███████╗███████╗███████╗███████╗███████╗███████╗███████╗███████╗██╗╚████╔╝ ██████╔╝                    //
//    ╚═╝╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝ ╚═══╝  ╚═════╝                     //
//                                                                                                                                       //
//                                                                                                                                       //
//                                                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract FEI is ERC721Creator {
    constructor() ERC721Creator("Fables of an Extradimensional Idol", "FEI") {}
}
