// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Willco Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
//                                                                                    @(                      //
//                                                                              *..........@@#*,,*#@          //
//                    @........#                *..............&%#&   @&*...................*..........       //
//           @......%...................../*...........................&................................      //
//       @.........,...................%..................................&..(.........................,      //
//      .........................@..........................................%#.........................       //
//      .........................(...&......*(................../ &...*......,........................*       //
//       ........................@.......%    ,................      #....&...*......................@        //
//       &.............................        &..............         .............................@         //
//        *.....................@....       @@. #............,&@@@@(     &.....,...................@          //
//         /.......................(     @. /@@@@...........(@/ ,@@@@     /......................./           //
//          @......................     #@@@@@@@@@..........@@@@@@@@@#     .......................            //
//            ................*....     (@@@@@@@@@..........(@@@@@@@@     %........,............./            //
//             *.............,....../    &@@@@@@@&..........# @@@@@@     ............&..........#             //
//              @..........@.........%@     %@   ............#    *&....................,.......              //
//               @.......,.......................,/./@@@@@@/............................@                     //
//                #...., ..........@&&%.(,......@@@@@@@@@@@@@@#......@....&&&&..........#                     //
//                      &...........(&&&......*..@@@@@@@@@@@@@...........&&&*.........(.                      //
//                       *.........../&&&....,....#@@@@@@@@@...#.*.....,&&&.........@.                        //
//                          /.........#&&&...........@@@@@............%&&&.........                           //
//                             ........(&&&*.........................&&&@......(*                             //
//                               .&.....(&&&&......................@&&&......%                                //
//                                *.#....(&&&&&&@,.,&@&&&&@...(@&&&&&@......                                  //
//                                 ...#....&&&&&&&&&&&&&&&&&&&&&&&&%......                                    //
//                                %@....%....&&&&&&@**(#****@&&&&......(.@                                    //
//                               &###.....,....@&&*****(******(......*.%%                                     //
//                               %####(......&...&***********(....#...&###                                    //
//                              ..%#####........,#************#......&####&                                   //
//                            /....%######.......#************......######%,                                  //
//                           .......&#######*....../********&.....*######@....                                //
//                        %..........,########&..................#######&........*                            //
//                       ..............##########..............########(..........,                           //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Willco is ERC1155Creator {
    constructor() ERC1155Creator("Willco Editions", "Willco") {}
}
