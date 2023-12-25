// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Merry Spirited Christmas
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                                                                                                                    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdollodxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddddddxkkxxxxxxxxxxxxxxxxxkxxxxxxxxxxxxddlcll;',lxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkOOOkxxkOkxxxxxxxxxxkkkkxxxxxxxxxxxxxxxl;:dOd;'.,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkOOO000000kodxxxxxxkkkkkkkxxxddxxxxkkkkkOOkxl;:oxc''.;oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkOOO    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdxO0000000OxxkOOOOOOOkxxxxxxkkOOOOOO000Okxdddol:'....;oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkOOOkkkkkxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdooodxO00000000000000000OkkOO0000000000Okxddoddl;,',;c:,..;cdxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkxxkO000000OO00000000000000000000000Okxxxddxkdc,,;lodkkl;:,..,;ldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkOOO000000OkxdxOO0000000000000000000000Oxxxxxxxxo,':dxxxxxxl;::,,;'':dxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkOOO0000000OkxxdooddxkkkkkkkxxkO000000000OOkxxxdddddd:';lddloxkkko;;c::::'.,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkOO000000OOkxddooooddxxkxxxdddddddxkkkkkkxxxxxddddxxxxxl,,okkkxddxxkkx:',;::c:,.'cdxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxk    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddddooooddxxxxxxxxxxxxxxxxxxxxxxdddddddxxxxxxxxdc.,ldxxxxkOOOOOkl,;;:cc:c:..:dxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkOOO    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxo;'cxddOOOxdxxxodxo,,;;cclll;..,lxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdl''lkdloxxxxxxkkdxOk:,:c::::::,'..cdxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxd:.:dxxxxkOOOOkkxxdxxxl',:clllc;;:;,.;oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxl,'lO0OOOOkxxxxdddddddxo;',,;:cl:;cll:.'ldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxk    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdc..cxxkOkkxooddxxddddxxxo:,;,,,;;:,,;::;..:dxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxo;.,:ldddxxxdddddxxxxdxxdoc:clccc::;;,,,,,'..,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddoo:,cdddddxxxkkxddoollcc:;,,'.',;:clooolc::;,,'.,coodxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddooddddddddxxxxxdddoollc:;,,'.......'.......',;:cloolcc:;;,;:ccloddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxd::oddddxxxxxdddooolc:;;,''..............'.............',:cloollc::;;:::clloxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxo,.;looooddlc:;;,''......   .............'..................',;:cllclc:;;'.'oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdolcc::::cc;,..........     .   .........'......        .........';;;;;;;,,cdxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddddddxxxxxxxxxxxxxxdddxxxxxxxxxxxddolc;,.......    ......  .   .....'..... .       .  .......;ccloddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddxxxxkkkOOOO00OOO000OOOkkkxxxxxxxxxxxxxxxdc,......  ....',,,'..     .........    .......   .....'lxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdxxxxkOO00000000000000000000000000OOkxxxkkxxxxxd:,.....   .',',,,,,'..... ....''...   ..',','..   ....'lxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddxxxkOO00000000000000000000000000000000000OkOOOOkxxdcc,... . ..','',,,,,.. ....''';;...   ..','','...  ...'lxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddxxkO00000000000000000000000000000000000000000000000Okdloc,,.....','..,;;;:,..''.,::;::...   .'''..','.   ...'lxxxddoooodddxxdoooddddddddxdddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddxxO00000000000000000000000000000000000000000000000000000kooc:;'.'.':c;',c:;;:;''..';c:;::...   .','..',,..   ..'lddodxxkkOOOOOOkkxxxxxkkkxkkkxxxxxxxxxxxxddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddxkO0000000000000000000000000000000000000000000000000000000koll:;',,',c:,,clcc:,..''.,:c:;:;...   .',,'',,,.    ..,lxxkO000000000000000000000000000000000000OOOkkxxxxddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddxkO0000000000000000000000000000000000000000000000000000000000klll::'...';:,;:cc;,''..,:::::::;......;::,'',,'.   ..';d000000000000000000000000000000000000000000000000OOkkkxdddddddddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddkO000000000000000000000000000000000000000000000000000000000000klll:c;'','''','','..'';::;,;:::;...............    ..';d000000000000000000000000000000000000000000000000000000Okkxxxxkkkkkkkkkkxxxxddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddxO00000000000000000000000000000000000000000000000000000000000000kool:::;,'..',,'.','',:c:;;:::;;,.......  .        ...';d00000000000000000000000000000000000000000000000000000000000000000000000000OOkkxxddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdodk0000000000000000000000000000000000000000000000000000000000000000kool::;::;,',,'''',,;:::;;;;;:c;'..........      .....';d0000000000000000000000000000000000000000000000000000000000000000000000000000000Okdoodddddddddxxxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdoxO0000000000000000000000000000000000000000000000000000OOOO000000000kodl::::cc::;;;;;;;::cclooodxkOo;;;,,'''..............';d000000000000000000000000000000000000000000000000000000000000000000000000000000000Okxxkkkkkkxoodxxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdodk0000000000000000000000000000000000000000000000000000OOOOOOOOOOOO000kodo:::::;;:::cloodxxkkkkkxoolc,..',,;;;;;,,'''........;d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000Oxodxxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdoxO000000000000000000000000000000000000000000000000000OOOOOOOOOOOOOOOO0klllcclooddxxkkkkxolc:;,,''.....''''....'',,;:;;,,,'...;d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000Oxodxxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdodkO000000000000000000000000000000000000000000000000000OOOOOOOOOOOOOOOOOOkllxkkkkxdolc::;,'''..''''''''.',.'',,,,''....'',;;:;;,;x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000Ododxxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddodkO00000000000000000000000000000000000000000000000000000OOOOOOOOOOOOOOOOOOkl::::::;'.'''''''''...........'.........''''....,''''':x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000kdodxxxxxxxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddoooooddxddxxxxkxxkO00000000000000000000000000000000000000000000000000000000OOOOOOOOOOOOOOOOOOkxollcc;''.................''''. ..............'::cccoxO000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000kxxdddoddxxxxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxxxdoooddxxkkkkkOOOOOOOOO000000000000000000000000000000000000000000000000000000000000000OOOOOOOOOOOOOOO000000Odc'.......'',,;::cclloc,................lOO0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000Okkxxxddxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxxxdoodkOO0000000000000000000000000000000000000000000000000000000000000000000000000000000000OOOOOOOOOOO000000000xc,';;,';llooollooodddc,...............'o000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000Okxxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxxdodxO00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000OOOO0000000000000kl;:ddollollllclllooddc'...............'o000000000000000000000000000OOOOOOOOOOOOOOOOOO00000000000000000000000000000000000000000000000000000000000000000000000kxxxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxxdoxO000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000xc;cddlclllollllc:clodc................'o000000000000000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO00000000000000000000000000000000000000000000000000000000000000000000kddxxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxdox00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000xc;lddooddooolll:,;lodc................'o00000000000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO0000000000000000000000000000000000000000000000000000000000000000000kodxxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxodO00000000000000000000000000000000000000000000000000000O00000000000000000000000000000000000000000000000000000000xc,:ddolol:clllllloodd:................'o0000000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO000000000000000000000000000000000000000000000000000000000000000000xodxxxxx    //
//    xxxxxxxxxxxxxxxxxxxxodO00000000000000000000000000000000000000000000000000OOOOOOOOOO00000000000000000000000000000000000000000000000000xc,:oo:;cloddddddddddd:................'o000000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO000000000000000000000000000000000000000000000000000000000000000000Ododxxxx    //
//    xxxxxxxxxxxxxxxxxxxxooO0000000000000000000000000000000000000000000000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOO000000OOOO0000000000000000000000xc;cdollllooollllcclod:................'oO000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO0000000000000000000000000000000000000000000000000000000000000000000kooxxxx    //
//    xxxxxxxxxxxxxxxxxxxxdoxO0000000000000000000000000000000000000000000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO00OOOOOO00000000000000000000kl;cddollcllloooollddd:................'o0000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkO0000000000000000000000000000000000000000000000000000000000000Ododxxx    //
//    xxxxxxxxxxxxxxxxxxxxxdodO000000000000000000000000000000000000000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO000000000000000000000kl:lddllodddddddddddddc'...............'o000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOxdl,'..;oxO0000000000000000                                                     //
//                                                                                                                                                                                                                                                                                                                    //
//                                                                                                                                                                                                                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MSC is ERC721Creator {
    constructor() ERC721Creator("Merry Spirited Christmas", "MSC") {}
}