// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Flight - Episode One
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                        //
//                                                                                                                        //
//    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////    //
//    //                                                                                                            //    //
//    //                                                                                                            //    //
//    //    ~~~~~~~~~~~~~~~~^^^^^^~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~~~^^~~~~~~~    //    //
//    //    ?????????????777777777??7777??777777777!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!777777777777777???    //    //
//    //    PPPP5555555555555555555555555555555555555Y55555555YYYYYYYYYYYYYYYYYYYYYYY55555555555555555PPP5PPPPPP    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5P55PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5YJ?7??7!~~~~7JY5PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPYY?7!!!!!77~~!7!!~^~~~!!7JYPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5?!!~!!!777!!??77!!~^^^^^^^~7J55PPPPPPPPPPPPPPPPPPPPPPPPPPPGGGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPJ7~!7?JJ77JJY5PY?7??!~~~~^^^^^^^^75PPPPPPPPPPPPPPPPPPPPPPPGGGGGGGGGGG    //    //
//    //    GPGPPPPPPPPPPPPPPPPPPPPPPPPPPPJ!~!?7?JJY5555YJJ??7~!777!~~~~~~~^:!YPPPPPPPPPPPPPPPPPPPPPPGGGGGGGGGGG    //    //
//    //    GGGGGGGPPPPPPPPPPPPPPPPPPPPPPY!~!77??JJP5YYYJJYJ??7777!!!!!~^^~!!~!5PPPPPPPPPPPPPPPPPGGGGGGGGGGGGGGG    //    //
//    //    GGGGGPPPPPPPPPPPPPPPPPPPPPPP5!~!??77!?Y5J?JJJ???????J?7!!!!77!~~!~~YPPPPPPPPPPPPPPPPPPGGGGGGGGGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPP55?!77?77??7YY?J??JYYYYYYYYYYJ???JYJ?77~!JPPPPPPPPPPPPPPPPPPPPPPGGGGGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPP557??77J7??JY?JJJJYJJJJ?????7777!!!!!~^^75PPPPPPPPPPPPPPPPPPPPPPPPPPPGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPP5?JY??YJY5YYJJ??JJJ???????7777!!!!~^^^^!5PPPPPPPPPPPPPPPPPPPPPPPPPPGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPP57?YY5P555YYYJ7?JJJ??????77777!!!!!~^::?PPPPPPPPPPPPPPPPPPPPPPPPPPGGGGGGG    //    //
//    //    GGGPPPPPPPPPPPPPPPPPPPPPPP5Y775PGYPPY555YYYJ??7777777?????77?JJ?7~?PPPPPPPPPPPPPPPPPPPPPPPPPGGGGGGGG    //    //
//    //    GGPPPPPPPPPPPPPPPPPPPPPPPP555JP555GGGGGGP5YJ??JYY55PGGGGY?!7YYYP5!YPPPPPPPPPPPPPPPPPPPPPPPPPGGGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPP5Y5P5PGBBGP5J??Y5PP555PPP55YJ!~??7!^:?PPPPPPPPPPPPPPPPPPPPPPPPPPPGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5P5YPGPPP5J7777?777????JJJJ??!^^^^^:!PPPPPPPPPPPPPPPPPPPPPPPPPPPPPGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5YYP5J5G5J??77!!!!!!!77?J????!^~~^^^YPPPPPPPPPPPPPPPPPPPPPPPGGGGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPYJJJYYPPPYJ???777777JY5555YY?!7J7~^?PPPPPPPPPPPPPPPPPPPPPPPPGPPPPGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP55Y??JJJ55YJJJJYYJJYYYJ?J5555?~~!J?!YPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5555YJYJJYY5G5YYYYJJJJJJ???7!~!7?PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5P5JJYYY555P5JYYPGPYYJ?!!!7?77!5PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPY?JY5PPP555YJYJJYYYYJJ?7!^~!YPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP57?JYPPPPP55YJYYYYYYJJ?7!~~YPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5PPPY7?JJY5PPP55YJ?JJJJ????7~^7PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP5555?7??JYY555PPP55YYYYJ????!75555PPPPPPPPPPPPPPPPPPPPPPPPPGGGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPP5PPPPPPPPPPPPPPPPPJ!7?JJJYYYY5PPGGGGGP5YJ?75PPPPPPPPPPPPPPPPPPPPPPPPPPGGGGGGGGGGGG    //    //
//    //    PPPPPPPPPPPPPPPPPP5PPPPPPPPPPPPP55Y?!77?JJYYJJJYY55PP5Y?!!!~~PPPPPPPPPPPPPPPPPPPPPPPPPPPPGGGPPPPPGGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPPPPPPP5YJJ7!!777??JJJJJYYYYYY??7!~!~~^?YY55PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPGG    //    //
//    //    PPPPPPPPPPPPPPPPPPPPPPPP55YYJJYYY7!!777????JJJJJYYYJ?7!~~!~~^:77???JY555PPPPPPPPPPPPPPPPPPPPPPPPPPPP    //    //
//    //    PPPPPPPPPPPPPPPPPPP5YYYJJYYYY55555?!!7??????JJJJJJJ?7!~~!~~^^:?JJJ7?????JJY55PPPPPPPPPPPPPPPPPPPGGGG    //    //
//    //    PPPPPPPPPPPPPP5YJJJJJJJY55YY5555555J77??????JJJJJJJJ?7!!!~~~^~JJYJJ?YYJJJJJ??JJJY55PPPPPPPPPPPPGGGGG    //    //
//    //    PPPPPPPPP5YYJJJJYYYYYY555YY55555555P5J????JJJJJJYJJ??777!!~~7JJYYYY?JYYJYYJJJJJJJJ???YPPPPPPPPGGGGGG    //    //
//    //    PPPPPP5YJJJJYYY555YYY55YY55Y55555555555YJJJJJ?JJJJJ???7!!!7JYYYYJYYJJYYYY5YYYYYYYYYJ??7JYPPPPGGGGGGG    //    //
//    //    PPPP5JJJJYYYYY5555Y555Y55555555555Y555555555YYJJJJJ?JJJJJYYYYYYYYYYYJYYYY5555YYYYYYYJ??77?5GGGGGGGGG    //    //
//    //    PP5YJJYYY5555555555555555555555555555555555555555555555555YYYYYYYYYYYYYY555555555555YJJJ??7YGGGGGGGG    //    //
//    //    PPJJY555555P5555555555555555555555555555555555555555555Y5YYYYYYYYYYYYYYY5555PPP5555555YYYJJ?YGGGGGGG    //    //
//    //    PYY55PPPPPPGP5555555555555555555555555555555555Y5YYYYYYYYYYYYYYYYYYYYYYYY5555PPPPPPP5555YYJ?75GPPPGG    //    //
//    //    YY55PPPPGGGGGPPPPPPPPPPPP55555555555555555555YYYYYYYYYYYYYYYYYYYYYYYYYYYYY555PP5PPGP5555555Y??PPPGGG    //    //
//    //    Y55PPGGGGGGGGGPPPPPPPPPP5555555555555555555555Y55YYYYYYYYYYYYYYYYYYYYYYYYY55PP55PGGPPPYP55PPJ7YGGPPG    //    //
//    //    5PPPPGGGGGGGGBPPPPPPPPPP5555555555555555555555555555555555555YYYYYYYYYYYYYYY5PP55GGPGG5PPPPGP?JGGGPG    //    //
//    //    PPPPGGGGGGGGGBGPPPPPPPP5P555555555555555555555555555555555555555YYYYYYYYYYYYY5PPYPGPGG5PPPGGGJ?5GGGG    //    //
//    //    PPPPGGGGGGGBGBGPPPPPPPP55555555555555555555555555555555555555555555YYYYYYYYYYY5P55BPBPPPPPGGGYJYPPGG    //    //
//    //                                                                                                            //    //
//    //                                                                                                            //    //
//    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////    //
//                                                                                                                        //
//                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract flyep1 is ERC1155Creator {
    constructor() ERC1155Creator("Flight - Episode One", "flyep1") {}
}
