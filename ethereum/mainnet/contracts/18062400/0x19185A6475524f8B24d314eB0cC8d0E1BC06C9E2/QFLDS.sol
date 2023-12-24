// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Quantum Fields
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                              //
//                                                                                              //
//      .--.     /).--.     /).--.     /).--.     /).--.     /)                                 //
//     /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/                                  //
//    (/    `---'(.--. `---/).--. `---/).--. `---/).--. `---/).--.     /)                       //
//               /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/                        //
//              (/    `---'.--.  `--/).--.  `--/).--.  `--/).--.  `--/).--.     /)              //
//                        /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/               //
//                       (/    `---'.--.  `--/).--.  `--/).--.  `--/).--.  `--/).--.     /)     //
//                                 /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/      //
//                                (/.--.`---'/).--.`---'/).--.`---'/).--.`---'/).--.`---'/)     //
//                                 /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/      //
//                         .--.   (//).--.--'(//).--.--'(//).--.--'(//).--.--'(//)  `---'       //
//                        /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/               //
//                .--.   (//).--.--'(//).--.--'(//).--.--'(//).--.--'(//)  `---'                //
//               /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/                        //
//      .--.    (/).--.---'(/).--.---'(/).--.---'(/).--.---'(/)   `---'                         //
//     /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/                                  //
//    (/.--.`---'/).--.`---'/).--.`---'/).--.`---'/).--.`---'/)                                 //
//     /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/                                  //
//    (/    `---'(.--. `---/).--. `---/).--. `---/).--. `---/).--.     /)                       //
//               /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/                        //
//              (/    `---'.--.  `--/).--.  `--/).--.  `--/).--.  `--/).--.     /)              //
//                        /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/               //
//                       (/    `---'.--.  `--/).--.  `--/).--.  `--/).--.  `--/).--.     /)     //
//                                 /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/      //
//                                (/.--.`---'/).--.`---'/).--.`---'/).--.`---'/).--.`---'/)     //
//                                 /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/      //
//                         .--.   (//).--.--'(//).--.--'(//).--.--'(//).--.--'(//)  `---'       //
//                        /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/               //
//                .--.   (//).--.--'(//).--.--'(//).--.--'(//).--.--'(//)  `---'                //
//               /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/                        //
//      .--.    (/).--.---'(/).--.---'(/).--.---'(/).--.---'(/)   `---'                         //
//     /.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'//.''\\._.'/                                  //
//    (/    `---'(/    `---'(/    `---'(/    `---'(/    `---'                                   //
//                                                                                              //
//                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////


contract QFLDS is ERC721Creator {
    constructor() ERC721Creator("Quantum Fields", "QFLDS") {}
}
