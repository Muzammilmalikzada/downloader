// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: AI ART BY KIN
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    --====---=+++++====+**#****###**#############+*#****++++*++=----==::::::::::::::::::::::::    //
//    =+*+===-----+*++====+**#**+++*####%%%%%%%%%%%%%#####***#*+++=-----::::::=-::::::::::::::::    //
//    =++=++===---=**++==++*++*+++++*##%%%%%%%%%%%%%%###*#####%##++----:-::::--==-::::::::::::::    //
//    ---=+++++====++****+**++++++*+*#%%%%%%%%%%%%%%%%#*++*#%%%%%#*+-------:--===-::::::::::::::    //
//    ------+**+==-=--=+#*===+++***###%%%%%###%%%%%%##*****#%%%%%%#*+-:-::----=+=--:::::::::::::    //
//    ----:::-+*+++-::::-::----=*##%%%%%%%##*##%%%%%#******##%%%%%%%#*+=-:-=--=+=------:::::::::    //
//    ----:::::-=**-:::::::::-=++#%%%%%%#*++==+*#############%%%%%%%%#**++=+===-------:-::::::::    //
//    ----::::::-==*+----::----+#%%%%#**+===---=**##**#%%%%%%%%%%%%%%%#####*++=------:::::::::::    //
//    ----::::::--====+==-----=#%%%%#*++==-------=+++*+#%%%%%%%%%%%%%%%%%%%#+=-=------::::::::::    //
//    -----::::::----=-===---=*#%%%##*+======---::-=+****%%%%%%%%%%%%%%%%%%#+-=---==-:::::::::::    //
//    ---------:::-------====+#%%%%#*++++++==----:::-=+**#%%%%%%%%%%%%%%%%#*=+=-==---::-::::::::    //
//    ------::--------------+*##%%%###***++####*==-----=+*#%%%%%%%%%%%%%#**+**+==--:::--::::::::    //
//    -------:::::::::-----==*#*%%##*###*++**==---::--:::-=#%%%%%%%%%%%#**+++++=--:::--:::::::::    //
//    --------::::--------=++#**%%###*+##=-=*#%%%%%#=-::::-+#%%%%%***%##***+***=-:--:-::::::::::    //
//    --------------------=+****%%%%%##+*-::-***+==-::::---=*%%%%%%######***+++-=----:::::::::::    //
//    --------------=====-==+***%###*+=+=::::-==--:::::-====*%%%%%#+##%##*+==*++==-:::::::::::::    //
//    -------------=+**+====++*##*+===++:::::----------=++=+*##*%%#+*###*===+=-:-=-:::::::::::::    //
//    -----------==+***+===+=*++##*+==*=-----=========++*+++***#**+*#%#++=++=---=----:::::::::::    //
//    ---------=+++***++===+=++++**+==*%##%*++==++*==+***+++***+**#%%%#*++++-==+---=-:::::::::::    //
//    --------===++++++++===++++==**++*%#*==-:--=+******+=+**#%%%%%%%#%#*+++++++-=*==:::::::::::    //
//    -------====+++=++**+==++++===***##***+-----=+*####*++*##%%%%%%%%%#***=+++--*++-:::::::::::    //
//    --------=====*+====++++==+++=+*##%#******+===++***#####%%%%%%%%%%##**#**+++**=---=-:::::::    //
//    --------=====**+===--=+++=++==+*######*+====++**###%%%%%%%%%%%%%%#######****=-==+=-:::::::    //
//    -------======**+==----===+==++++*###+=---==+**##%%#%%%%##%%%%%%%%#%###*****+=+==+-::::::::    //
//    -----------==+===-------=========+***+==++*####%%%%%%#***#%%%%%%%%%##****##*+==---::::::::    //
//    -------------=--------------=======+*******###%%%%##*++*##%%%%%%%%###**###*++=----=-::::::    //
//    ----------------=------------=--==-=+++**##%%%%%%###*****##%%%%%#######**+=--=------::::::    //
//    ----------------------::-----------==+++*##%%%%%%%#*+******#%%#%%%##*++==--====-:::::-::::    //
//    ---------------=-----------------------=+**#%%%%%#*+**############**+++==--=+++=::::::=:::    //
//    ------------------------::::::::----=++++*####%%###########%%%%##**+++==---==+=+=-:::::=::    //
//    -------------------=--:::::-::::---=+*#**####%%%%%#######%%%%#*##**+++++====++-+++=-:::--:    //
//    ---------------------::::----------=+**#***#%%%%%%%%##***####****###++++++++*+++++---:::=:    //
//    --------------------:-:::---------====+***#%%%%%%%%#*+**####*###*##**+++++++++++++=-----+:    //
//    -------------------:::---------======+**##%%%%%%%%#####*#*****##*******++++=====----:--:::    //
//    -----------------------------======+**#%%%%%%########****#*###*#*+**####*++=----:::-::::::    //
//    ---------------------------=====++**###%##%#**++***#*++++*###***#*######*=++--::::-:::::::    //
//    --------------------------===++**##%%####**+==--=+*#*++=++###****########+++=------:::::::    //
//    -------------------------===++**###%%##*++==----=+***++==+*##*=+*#####%##**++=--:---::::::    //
//    ------------------------===+***#*#####**++===---==+++++++++***+=++**##*###**+==-::::::::::    //
//    --------------------=====++*+****####++++**++===-====+++**+***+====#*+*###*+*=---:::::::::    //
//    -------------------==+++++******#%##*++++++++========+++*++*##+====**+####++*=----::::::::    //
//    ------------------=====++++****#%%#******+============+=++==*#+====***####*+*------:::::::    //
//    ---------------====++++++*++**####******#*+=================*+====+*+*##****+=--=---------    //
//    ==-----------=======+++++++**####**++***#*+==========-==++==+-=+==+*+*##+****==-=---------    //
//    ======-------=======++++*****#****+++++*##++=====+===-=======--====++***++**+*====--------    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract KIN is ERC1155Creator {
    constructor() ERC1155Creator("AI ART BY KIN", "KIN") {}
}
