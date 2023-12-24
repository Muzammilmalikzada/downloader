// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: JB ABSTRACT
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//           (                     )  (    (     (                 )      //
//           )\ )      (        ( /(  )\ ) )\ )  )\ )    (      ( /(      //
//       (  (()/( (    )\ )     )\())(()/((()/( (()/(    )\     )\())     //
//       )\  /(_)))\  (()/(   |((_)\  /(_))/(_)) /(_))((((_)(  ((_)\      //
//      ((_)(_)) ((_)  /(_))_ |_ ((_)(_)) (_))  (_))   )\ _ )\  _((_)     //
//     _ | || _ \| __|(_)) __|| |/ / |_ _|| |   | |    (_)_\(_)| || |     //
//    | || ||  _/| _|   | (_ |  ' <   | | | |__ | |__   / _ \  | __ |     //
//     \__/ |_|  |___|   \___| _|\_\ |___||____||____| /_/ \_\ |_||_|     //
//                                                                        //
//                                                                        //
//           (                     )  (    (     (                 )      //
//           )\ )      (        ( /(  )\ ) )\ )  )\ )    (      ( /(      //
//       (  (()/( (    )\ )     )\())(()/((()/( (()/(    )\     )\())     //
//       )\  /(_)))\  (()/(   |((_)\  /(_))/(_)) /(_))((((_)(  ((_)\      //
//      ((_)(_)) ((_)  /(_))_ |_ ((_)(_)) (_))  (_))   )\ _ )\  _((_)     //
//     _ | || _ \| __|(_)) __|| |/ / |_ _|| |   | |    (_)_\(_)| || |     //
//    | || ||  _/| _|   | (_ |  ' <   | | | |__ | |__   / _ \  | __ |     //
//     \__/ |_|  |___|   \___| _|\_\ |___||____||____| /_/ \_\ |_||_|     //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
////////////////////////////////////////////////////////////////////////////


contract JB is ERC721Creator {
    constructor() ERC721Creator("JB ABSTRACT", "JB") {}
}
