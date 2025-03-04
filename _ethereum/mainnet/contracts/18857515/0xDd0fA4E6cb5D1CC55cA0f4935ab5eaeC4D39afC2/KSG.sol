// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Kintsugi
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    *****++=:=*###%%%#%@@@@@@@@@@@@@@@%#*#%@@@@%@@@@@@@@@@@%%@@%%%%*-##%%%%%%%%@@@%%%%%%%%@@@@    //
//    +**+=:::.:***#%%%%#%@@@@@@@@@%#@%#**+++###%%%@@@@@@@@@%%@%%#*##-.=--*%%#%%%@@%%%%%###%%%@@    //
//    ++*+=-:-.:**==#%#*%%%%@@@@%#+-+*==-:-:-==-==*#%%@@@@@@%##%#+=*#=:=-+#%%%%%%%%#####%%%%%%@@    //
//    ++++=---::**=-+**+*#%%%%%+--=*%@@%+====#@@%*=-+*#%%%%%*+##*-+##-::=#%%%#%%###%%%#*#%%%@@@@    //
//    =+++-:=-:-++=-=-***##*#+::-*%@@@@%+-:-+#@@@@%+:.:=#*##*#*=+-+##=::+%%%%#%%%@%%%%%##%%@%@@@    //
//    ++++==#+-=+==:=-+*++#++-:-+*#%%@@%*-:-#%@@%%%#+-:-=+#*=*+==-+**+=*%%%%%#%%%@%%%%%%%%@%%@@%    //
//    +*+++=%*+=+=--++++-=#*+*+=++=--==++-:-=+=+===**=++++*=:==++--+#+*%%%%%%%%%*@%#%%%%@%@%%@%%    //
//    **+*++%*=+*+==***+-=##*##%%*+=++*##***###+++*#%%#**++-:=+*#=+##**%%%%#%%%%*@%*%%%@@%@%#%%%    //
//    *+****%+=*+===*#++=*#%###@@%@%@%%#%@%@%@@@@@@@@@%*+*===++##==+**+*#%%#%#%@%%%*%%%%%%%%*%%%    //
//    ******#-:+*++=*++*#%*%###@%%@@@%%%@@%@@@@@@@@@@@@#++=*+++*#+++*#==####%#%@%%%+%%%%%%%#%%%%    //
//    ++****#-.=+-++++=*#%*#+*%#%%@@@%%#%%%%%@@@@@@@@@@%++**+=-+#*++**.-######%%#%%*%%%%%%#%%%%%    //
//    **##*##=-++:-**==+*%+%*####%%@#*++++**###%@@@@@@@@#++==--+**=-*#-+#%##%#%##%#+%%%%%#%%%%%%    //
//    ####*##*+*+=-+++-==#*%%##*##%@%++##-=%%-*@@@%@@@@@%++=---+**==*#*#%%%%%%%*%%#-*%%%%#%%%%%%    //
//    ##*+==+*+*+++*+==-=#*%%%**##@@%*++:.+@@@##@@%@@@%@@*++---=***+*#*#%%%%%%%*#@%*=#%%##%%%%@@    //
//    #***+=**+*+-+++==+#%*%%#+###@@#-::::=@@@%@@@%%%@@@@%*#*+++***=*#*#%%%%%#%%+#%%#%%%%%#%%@@@    //
//    *##*++++=+*+==*++*#%*%##**#%@@%=:::-*@@@@@@@%%%@@@@@#%%#+*#*++##*+%%%%%#%*=*%#*%#%%%##%%@@    //
//    **#*+++--++---+++#%%*%%#**#%%@@%=:-=%@@@@@@@%%%@@@@%%%%#+*#*==**==%%%%%##%%+%*+%#%%%%%%%@@    //
//    ######=:=++-=-=++*##*%%##%#%%@@@@%+-*@@@@@@@@%@@%@@@@%%#++**+=*#+-*%%%%++%%*%*+%%%%%*#%@@@    //
//    ######=+==++====+*%%%%%#%#%%%@@@@@@@@@@@@@@@@@@@@@@@@@@#+++*=#*****%@%%*+%#%%++%%%%%*#%@@@    //
//    #######*=::=-=+=*#@@@%%##*%#%%@@%@@@@@@@@@@@@@@@@@@@@@@%#**+=*--*#%%@@@%#%#*@%%%%%%%##%%%%    //
//    ######*=:.::--==++%@@@%#%+%#%@%@%@%@@@@@@@@@@@@@@@@@@@@*++*+=--:=#%%@@@%#%%#%%%%%%%%%%##%@    //
//    ###*=-+*+::---+=-:*%@@%#%*%#%@%@%@@@@@@@@@@@@@@@@@@@@@#-==++==--*%%%@@%######%#%%%@%%*##@@    //
//    ###*--+**+-=-==-::#@@@%#%*%#%@%@%%@@@@@@@@@@@@@@@@@@@@%=-=++=+=#%%%@@@%%%%%%%%####%%%#%@@@    //
//    ##%#++#*##=-:::-++%@@@%#%*@%%@%@%%@@@@@@%@@@@@@@@@@@@@%**=:--++%%#%@@@@%%%%#%%#####%%%@@@@    //
//    %%##+#%#*#**--==##@@@@%#%#@%%@%@%%%###%@%@@@@@@@@@@@@@%##=+-=**%%%@@@@%%#%%%#%#*###%%%%@@@    //
//    %%%#+#%##%#*==++#%@@@@@%%#@%%%%@%%#+-+#%%@@@@@@@@@@@@@@%#**=+*####%@%@@%%%%%#######%%%%@@@    //
//    %%%#+##%%%%=:.--*%@@@@@%%@@%#%%@%%*-:-+%%@@@@@@@@@@@%@%%*--::--:=*%@@%@@#@%%%##%###%%*%@@@    //
//    %%%#*#%%%@%*:..:+%@@@@@%#@@@%%%%%#+:::=%%@@@@%@@@@@@@@%#*::..:::=*##@@%%%%#%%%###=#@%%#@@@    //
//    %%%#*#%%%@@*:.-=*%@@@%%%#%@@#%%###=-::=###%@@@@%%#***###*=-..-+#%%%%@@%%%%%%%%###+*%%%%@@@    //
//    %%%%*%%%%%@*::=+%@@@%@@@%@@@%%@%%%+::-+%%%@@@@@%#**%#*#*++=::+%@#@@@@@%@%@%%%%###**%%@%@@@    //
//    %%%%*%%%%@@#-::+%@@@%@@@%@@@%%%%%##==-*#%%%@@@%@%@%%#+-==:::-+%*%@@@@@%@#@%%%%%*#=#%%%%@@@    //
//    %%#+=**#%@@%+*+=*#%%%%@@%@%@%%%####*++#**##%%#@@@@%%*-::::-==+%@%@@@@#%%#%%%##%%#*#%%##@@@    //
//    %%%#+=#%%@@@#%#*::+#*%@@%@@%###**#++++++=-*#%#++*%#*+-:::-+++#%@%%@%%%%%**######+*#%%*##%@    //
//    %%%#*+#%%%@@@@%%#++#=-*#%%%##*+=--::::::::=***=***+::--=*#+#*#%#%%@@@%@%##%%%##**##%##%@@@    //
//    %%%#++*%@%%@@@%%@%%%#====+#+=---==-:::-+=-:::-----:::*%%%##**@%#@%@%@@%%%%%%%%%###%@%%@@@@    //
//    %%%%%%@@@@@@@@%@@@@@@**#*****-::-:::---==--=====-:::==%#%*###%@@@%@@@@@%%%%%%%%#%##@%%@@@@    //
//    %%%%%@@@@%@@@%@@%#%%##**##*+**=-::::::-===-=-===-:--=**###%#%%%@@%@%@@%%%%%%####%%%%%*#%@@    //
//    %%%%%@@@%#@@%%@@%%%#%####***++-=--::.::-:--:.:--++===*%%#*##%%%@%#@@@@@#*#%+=#*###%%@%**@@    //
//    %%%%%%@@@@@@#%@@#%#@#**++#*+*+:...........::::::=+===+*=%#%%%%%@%%@@@@@%=##*%#*###@%%###%@    //
//    %%%%#%%%@@@%%@@%%##%#+:.-+++=::.............::-::::-*=##%@%%%%%@%%@@@@@%*%*+%++*%%@#*##%%@    //
//    %%#*+=*%@@@#%@@%%#@%+++---::................:--:::-==++##%#%%%%%%%%%%%%*+%##%==*#%%%##%@@@    //
//    %%#+-:=#@@@#@@@@#%@#*+++++=-:................----==**+=%%%%%%##%%%%%%@%##%%*%**#%%%%%%%%@@    //
//    %%%*-=#%%%%#####*++====+=:.:::...............:..-=**+++%%*#%%####%%*#%%@%*+*%*=##%#+*%%+*%    //
//    %%%*-+##%%#*#%%%*#*+*+**=:::::................::::-=**=##%%%%%###%%%#%%%%#+*#*+#%#**+%%%%@    //
//    %%%*-+#%%##%%#####*++==+=-:=-:::::..........::=-::----=#%%%%%%#%%#%%%##%##*#**-+*%#++%%%%@    //
//    %%%*=*%%@@%@%#%%#+*+++*#*-:::::=-:...:::.-=:=#*=-::-=:-:+#*%%%###%%#*%%%%=+%%=-*#%#+*%%##@    //
//    %%%#+#%@@@@@@@@@%*+*#*+##=+-:--+=:--:-:::+#=+++#+--=++=+%#%%%%%##%%%#%%%%+#@#=*%@@%*%@@#%@    //
//    %%%#+#%@@@@@@@@@%+###%*#+==-+=-==-==-:::-++::=+%+=*#+*+*#%%%%#**#%%%#%%%%%*%#=%%@@###@%%%%    //
//    %%%#+%%@@@@@@@@@%#*##%%+#+*-#=++++*=-:.:==**-##%+++#%*+==+*#%%%*#%%%%%%%%%#%%=%@@%@@%%%@@@    //
//    %%%#*%%@@%@@@@@@#%#*#%*%#*#-#*#=:-#+=::-==*##+*=*%=+#++=:=++++#*#%%*+#%@%++%%-+#@@%**#%**%    //
//    %%#+=**#%%%%#%@@##%##*#%#*#-%%#*--##+:::-=*#*#==#%#=%##*#+#%#*+=+*###%@@@%*##-*%@@@%%%#%%@    //
//    %%#+--+%@@%%%@@%*%###*%%###-%###+=**+==:-**##%##%##+%%%##%+*%@%#=++###+****%%+#%@@%%###%%@    //
//    %%%*++#@@%%%%@@%*%%###%%###-%%##+-***=-=**-+#+#*%%+#%*#####*==+*#%%#*%*++--::=*%@@@%%%@%%@    //
//    %%%#==*%@%%%@@@%%%#*%#%%#*%-#++*+*#%#+-==+.=%%@%++#%%#%%%#%%%%#*+++==+==*+*#*++#@@%**%%+#%    //
//    @@@%%%@@%%%@@@%%%%%%#%@%*%+:+#%%####+-.=+#.==*%@#*=+%%%%%%%%@@%%%%%%#%%%#*-==+*#@@%%#%%#%@    //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract KSG is ERC721Creator {
    constructor() ERC721Creator("Kintsugi", "KSG") {}
}
