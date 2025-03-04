// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: THE TAPESTRY
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
//                                                                                    //
//                                                                                    //
//    ##### #    # ######    #####   ##   #####  ######  ####  ##### #####  #   #     //
//      #   #    # #           #    #  #  #    # #      #        #   #    #  # #      //
//      #   ###### #####       #   #    # #    # #####   ####    #   #    #   #       //
//      #   #    # #           #   ###### #####  #           #   #   #####    #       //
//      #   #    # #           #   #    # #      #      #    #   #   #   #    #       //
//      #   #    # ######      #   #    # #      ######  ####    #   #    #   #       //
//                                                                                    //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////


contract TPSTRY is ERC1155Creator {
    constructor() ERC1155Creator("THE TAPESTRY", "TPSTRY") {}
}
