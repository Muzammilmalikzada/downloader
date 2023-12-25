// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: REAS-UFS
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ....   ....   .    .    ...       .               ..   :.    .    ..............    //
//    ....   ....        .    ...       ............. . .. ..:. ......................    //
//    ...........   .    .             .:=+****++++===-:.. .... . ....................    //
//    ...........   .    .          ..:*#####%%###****###*=:... . ....................    //
//    ...........   .    .         ..:#%%#%%%#########%%##%*:.. . ....................    //
//    ...... .....  . ....       ...:*#%%%##********###%@@@%*:........................    //
//    ............  ......      ....=%#%##**********##%%%@@%#=........................    //
//    ....................      ...:#####*****++*++*#%%%%%%%#+:.......................    //
//    ....................     ....-######***+*****#%%%%#%#***:.....................::    //
//    ....................     ....=%%###***++****#%%%#***#**+:....................:::    //
//    ......................   ....=%%##****+**###%%%#*++****+:.................::::::    //
//    ..::..................   ....:*%#*****++***#%%%%*++****=..................::::::    //
//    ..::..................   .....-*##****+++*##%%%%#++*+*=:..................::::::    //
//    ..::...................  ......+###***++**#***###****+:..................:::::::    //
//    :.::...................  ......:*##**#***#*****##***=::..................:::::::    //
//    =:::............................+#*###***#****######-.::..........::.....:::::::    //
//    *=-:.........................  .-**+****#%****###**#@*-:... ......::.....:::::::    //
//    **=-.........................  .:+******%%****###**#@@@*:.........::.....:::::::    //
//    %%*=............................+@@%***###*********%@@@@@#+::.....::.....:::::::    //
//    @@%+:.......................:=*%@%******##********%@@@@@@@@@%*=-.:::.....:::::::    //
//    @@%*:....................:+%@@@@@#+++*******++*#%@@@@@@@@@@@@@@@%*+-.....:::::::    //
//    @@@*:..................=#@@@@@@@@%*+++****+*%%@@@@@@@@@@@@@@@@@@@@@@#=::..::::::    //
//    @@@#:................=%@@@@@@@@@@@%+++++++#@@@@@@@@@@@@@@@@@@@@@@@@@@%=:..::::::    //
//    @@@#-..............:*@@@@@@@@@@@@@@%****#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+:::::::::    //
//    @@@%-...........:..=@@@@@@@@@@@@@@@@%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+:::-:::::    //
//    @@@%=..............:%@@@@@@@@@@@@@@@%#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=:::--::::    //
//    @@@@+........:.....:*@@@@@@@@@@@@@@@*#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=:::-=::::    //
//    @@@@+..:..:::-:::.::#@@@@@@@@@@@@@@%*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-:::-+-:::    //
//    @@@@%=::-+*******-:-%@@@@@@@@@@@@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%-:::=+-:::    //
//    @@@@%%#*+****#*+++=-%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%-:--==--+#    //
//    @@@@%%###****#*=+=--%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#----==-=#%    //
//    @@@@@%#####****+*==-%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*----===#@%    //
//    @@@@@%########*++===%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+----=+#@@%    //
//    @@@@@%#########**++=@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+--==+#@@@%    //
//    @@@@@%%##########+++@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*==+*%@@@@%    //
//    @@@@@@%%%%#######+=+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%@@@@@@@%    //
//    @@@@@@%%%%%####%#+=*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%    //
//    @@@@@@@%%%%%%%#%#*++@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@%%%##*+++@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@%%%#*++*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract REAS2 is ERC721Creator {
    constructor() ERC721Creator("REAS-UFS", "REAS2") {}
}