// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/***************************************************************\
 .    . . . . . . .... .. ...................... . . . .  .   .+
   ..  .   . .. . ............................ ... ....  . .. .+
 .   .  .. .. ....... ..;@@@@@@@@@@@@@@@@@@@;........ ... .  . +
  .   .  .. ...........X 8@8X8X8X8X8X8X8X8X@ 8  ....... .. .. .+
.  .. . . ... ... .:..% 8 88@ 888888888888@%..8  .:...... . .  +
 .  . ... . ........:t:88888888@88888@8@888 ;  @......... .. ..+
.  . . . ........::.% 8 888@888888X888888  .   88:;:.:....... .+
.   . .. . .....:.:; 88888888@8888888@88      S.88:.:........ .+
 . . .. .......:.:;88 @8@8@888888@@88888.   .888 88;.:..:..... +
.  .. .......:..:; 8888888888888@88888X :  :Xt8 8 :S:.:........+
 .  .......:..:.;:8 8888888%8888888888 :. .888 8 88:;::::..... +
 . .. .......:::tS8@8888888@88%88888X ;. .@.S 8  %:  8:..:.....+
. .........:..::8888@S888S8888888888 ;. :88SS 8t8.    @::......+
 . . .....:.::.8@ 88 @88 @8 88@ 88 @::  8.8 8 8@     88:.:.....v
. . .......:.:;t8 :8 8 88.8 8:8.:8 t8..88 8 8 @ 8   88;::.:....+
.. .......:.:::;.%8 @ 8 @ .8:@.8 ;8;8t8:X@ 8:8X    88t::::.....+
. .. ......:..:::t88 8 8 8 t8 %88 88.@8 @ 888 X 8 XX;::::.::...+
..........:::::::;:X:8 :8 8 ;8.8.8 @ :88 8:@ @   8X;::::::.:...+
  . .......:.:::::; 8 8.:8 8 t8:8 8 8.;88 XX  8 88t;:::::......+
.. .......:.:.:::::; @:8.;8 8.t8 8 tt8.%8@. 8  88t;:;::::.:....+
 ... ....:.:.:.::;::; 8:8 ;8 8 t8 8:8 8.t8S. 888;;:;::::.:..:..+
.  ........::::::::;:;.t 8 ;8 8 ;88:;8.8 ;88 88S:::::::.:.:....+
 .. .. .....:.:.:::::;; 888X8S8 X@XSSS88 888X:t;;;::::::.:.....+
 .. ........:..:::::;::;%;:   .t. ;ttS:;t. .  :;;:;:::.::......+
 . . ......:.:..::::::;;;t;;:;;;;;;;;t;;;;;:: :;:;:::.:........+
/***************************************************************/

import "./IDiamond.sol";

interface IDiamondCut is IDiamond {    

  /// @notice Add/replace/remove any number of functions and optionally execute
  ///         a function with delegatecall
  /// @param _diamondCut Contains the facet addresses and function selectors
  /// @param _init The address of the contract or facet to execute _calldata
  /// @param _calldata A function call, including function selector and arguments
  ///                  _calldata is executed with delegatecall on _init
  function diamondCut(
    FacetCut[] calldata _diamondCut,
    address _init,
    bytes calldata _calldata
  ) external;    
}
