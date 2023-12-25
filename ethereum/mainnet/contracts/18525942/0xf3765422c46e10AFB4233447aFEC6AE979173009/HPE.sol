// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Hoshi Peach Editions
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                       :::.      #@@%=                                            //
//                                     -%@@@@@@%###%@@@@@.                                          //
//                =@@@+     =#%+      *@@@@@@@@@@@@@@@@%-                                           //
//                @@@@@-    @@@@+    .@@@@@=:--==+**+=:   =++:    :*#+     ..                       //
//                @@@@@-    @@@@+    .@@@@#-:...         *@@@@-   *@@@+  .%@@@+                     //
//               .@@@@@-    @@@@+     %@@@@@@@@@@@%=     +@@@@*   *@@@%   +@@@@.                    //
//               .@@@@@#****@@@@+      =*#@@@@@@@@@@@+   =@@@@@..:#@@@@     ::                      //
//               .@@@@@@@@@@@@@@+             .:+@@@@@*  :@@@@@@@@@@@@@: .*##+:                     //
//               :@@@@@*+++*@@@@*    -*%@@@@%+   +@@@@@: .@@@@@@%##@@@@- -@@@@@#                    //
//               :@@@@@:   :@@@@*  :@@@@@@@@@@@:  @@@@@=  @@@@@-  :@@@@+  *@@@@@=                   //
//               -@@@@@.   :@@@@*  @@@@@*-+@@@@*  %@@@@+  %@@@@=  .@@@@*   @@@@@+                   //
//               =@@@@@    .@@@@* -@@@@.   %@@@@  #@@@@*  #@@@@+   @@@@%   @@@@@+                   //
//               =@@@@@    .@@@@* +@@@@    *@@@@. *@@@@#  *@@@@*   %@@@@   @@@@@+                   //
//               +@@@@@    .@@@@* +@@@@.  .%@@@@. *@@@@%  +@@@@%   #@@@@.  @@@@@+                   //
//               *@@@@@    .@@@@* =@@@@+=*@@@@@%  #@@@@%  =@@@@@   *@@@@:  @@@@@+                   //
//               *@@@@@    .@@@@* .@@@@@@@@@@@#.  @@@@@%  :@@@@@   +@@@@=  @@@@@+                   //
//               #@@@@@    .@@@@*  :#%@@@%#+-.  :%@@@@@+  .@@@@@   =@@@@+  @@@@@%+.                 //
//               #@@@@#    .@@@@#         .::=+%@@@@@@*    %@@@*    #@@@*  #@@@@@@#                 //
//               .***+:     *@@@=   -*%@@@@@@@@@@@@@#:      ..        ..    =+**+-                  //
//                                +@@@@@@@@@@@@@@@*:     ..          ...                            //
//          :+*****###****+==:    #@@@@%*+=---::.      +@@@@@*.   .+@@@@@#-  :+*+:  -@@@-           //
//          %@@@@@@@@@@@@@@@@@@+   :-:                #@@@@@@@*  :@@@@@@@@@  %@@@%  +@@@*           //
//          :+*@@@@@#+++++++@@@@*     :=*#%%%%%#+    *@@@@@@@@%  %@@@-..++:  @@@@%  *@@@*           //
//             @@@@@+       =@@@@.  :@@@@@@@@@@@@.  +@@@@++@@@@  @@@#        @@@@@++%@@@#           //
//             #@@@@*       +@@@@. .@@@@@%##**+=.  -@@@@% =@@@@: %@@%:       @@@@@@@@@@@#           //
//             +@@@@#   .:-*@@@@*  =@@@%.      .+**@@@@@+-*@@@@- -@@@@#*#@@. @@@@@#*%@@@%           //
//             =@@@@@@@@@@@@@@@#   @@@@-       *@@@@@@@@@@@@@@@+  =@@@@@@@@- %@@@#  *@@@@           //
//             -@@@@@@%%#*+=-:    *@@@@%@@@#:   -*@@@@@@@@@@@@@*    =#%%%*-  #@@@#  +@@@@           //
//             :@@@@@-         -*%@@@@@@@@@@*    %@@@@:   .@@@@%             #@@@*  +@@@@.          //
//             .@@@@@=      .*@@@@@@@@#*+=-.    +@@@@#     @@@@@     :-=-    #@@@*  +@@@@-          //
//              @@@@@+      %@@@@%+-.           @@@@@.     @@@@@.   #@@@@.  .%@@@+  =@@@@=          //
//              %@@@@*     -@@@@%--=+*#%%#=  .#@@@@@@@=    %@@@@:   @@@@@@%@@@@@@-  -@@@@+          //
//              #@@@@*     .@@@@@@@@@@@@@@@. =@@@@@@@@-    *@@@@.   +@@@@@@@@@@%=    %@@@=          //
//              =@@@@:      :#@@@@@@@@%*+-.   .--::..       -**-     .-===-::.        -=-           //
//                ::           .:::.                                                                //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract HPE is ERC721Creator {
    constructor() ERC721Creator("Hoshi Peach Editions", "HPE") {}
}