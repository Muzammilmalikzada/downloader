// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Maiden_V_TSDNFT4CV
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                          =+.                                                                     //
//                          ++.                                                                     //
//        +##:####++++**##: *###****+ *##*. **#*******-      .                 =%%%#***..**+        //
//        +##:###%*+--+*++. **##==-:: ::--  ::::-+*%@%+     .%*:.                -#@%%%.:%%*        //
//        +**:#%##++---+##: ***++*+-: :.::  +****++==+=     .##==#=.               -*%%.:%%*        //
//        +#*:+*#**++=--*#: +**+*+=*= :==-  =########*-     .%%+=%%%*:               .+.:%%*        //
//        *%%:+++*#*###++*. ==#%###*+ #***. +*###***##+     .%#=-##%%@%=                .#%*        //
//        *@@-%%%%%%##%###: ==#%####* ####. ###***###%+     .%#==%@%%%%@@+:               :=        //
//         :*-%@@@@@@%%@%#: +++=%%#%# %%##. %######%%#=     .%%+=%%#%#%%%%%#-                       //
//            +****#%@@%%#: ++-=*+**+ ###*. **++++++++-     .@@+=%@@%%%%%%%%@%=:::.                 //
//          . ::::.+###+**: **-:--=+= =+=+. -....::::--     .##--**%%*+#%%%%%#*+==-                 //
//        +#*:++**=--:::::  #*-:-::.. ..:.  ==+++++++*-     .##+=###*+--:.              .**+        //
//        ===.+++-:...::::. +*--**++- -**=  *+++++*###-     .**=-##*#-.               -.:%#+        //
//        :==.=+*#########: =*--****+ ****. ###******+-     .++--****+**+=::::..          .:        //
//                ..:--=++. ==--*##** ****. ++**++**##=     .*+-:==-====++++++**+*++=--  :.         //
//        =++.-.    ......  =+*=*##** %#%#. **++*###%#+     .**=-##****+++++=+=+***=.::  :..        //
//                 +@#**%@: =+***%##* #+=*. *+**#=:-=#=      -:..::..*%+==+#*=+*+**-                //
//                 =%@#**%: +++*#%#*+ *+=*. ++***====+-     .=.-:+-.:**::::-+*++*+**=:              //
//                 =%@@***: ++++@%%** #+**. +*+**+=+**-      :+-:---=+*===++++*+**%#+:              //
//                 =#%#++#: **++%%%** #*=+. =****=++==-      =+=-+=---=+++*+*++#%##*+.              //
//                 +##%+=+: *#+=+###+ =***. ++**#*=--+-     .==--**+++++*+**#++####*=:              //
//                 *###%+-. +*##*#*#* ==*+  *=+****+=+-     .+:.:=+=*+++++**+*###***=:              //
//                 *%#%%*=. ++*****%* +=++. #**#*++=+++     .=-:.--=*++****%%@@%##%+=.              //
//                 #@@@%#*: **++###@% #%#%. %%@%#%%%%@*     .%%+-*###%%###%@@@@@%%%*+:              //
//                 #@@%###: ##++#%#%% %%%%. %%%%%%%%%%+     .%%+=%%##%%##%@%%%%%%%%@*.              //
//                 #@%####: %%++#%%%% %%%%. @%#####%%@+     .%%==####%%%%@@%%@%%%%%@*.              //
//                 #@####%: %+=+##%%% %%%%. %%##%#%%@%+     .#%+=%%%#**%@@%%%%%@@%%#-.              //
//                 *%##*#%: ##**%%%%# %%@%. #####%%%%%+     .%%+=####*#%@@@%%%%@@%%#*:              //
//        =**:===-==++++**. ++++##*++ %***. .  .......      .#+::+##%%%%#%@*+*****=====..++=        //
//        =##:#*+++==+++++. +#++@%##+ ****. +:               :+=:=++##%%%#++=+*#***++== .+++        //
//        -=+:*****+====+*. *#++###%# **+*. %##=                :++=+*#%%%%+==++#****=*..+=-        //
//        =+=:***####*+=**: ++=+**#%# %##*. #%###+:               .=+=+*#%%#*=-=*#-+-=*.:##=        //
//        +**:#%##*####**+. *****##%# %%%#. ##%@###*-                -+=+*#%#*=-=*#*#=+.:#**        //
//        +#*:*###*++*####: -=++=+*#* *##%. %%%@%##***:                :=++*##*=-=+###%.:##*        //
//        +##:*******+++*#: =-++--=++ %%%#. %%%%%%###*=                  .-*+*##+--=*#+..*#*        //
//        =*#:*******+++++. :-*#*+=-: +#%%. %%%**%%###=                     :+**#*+--==.:**=        //
//        =+-.*#***+++*#*+. ::++##**= --++. %%%%%%%###=     .=.               .=###*=--..**+        //
//        =*+.+****++*+#**: -++++*##* *+=-  =*%%%%%#**=     .**=::               -+##*= .+*+        //
//        =**:*+=+===****+: ==#*+++++ ##**. ----+#%%##=     .##=-*+.               :+##..--=        //
//        :=+:*#**+++%##*#: -=****++= =+**. **==-:-=+*=     .##=-*+*+:               .=.:*=:        //
//        ::. :----##*+==+. =-++#++*+ +*++. *+++=+=-==-     .**-:++=+##=-----------:.:: .=-:        //
//                 +*#*---.  :++++##* ####. ++=++#*+++-     .*=-:----=*%%%###%#***%=-%*.            //
//                   ::...   -**:.... ....  ..........       .. ...........::::....:.               //
//                           :*+                                                                    //
//                           -*#                                                                    //
//                           -**                                                                    //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract MVDCV is ERC721Creator {
    constructor() ERC721Creator("Maiden_V_TSDNFT4CV", "MVDCV") {}
}
