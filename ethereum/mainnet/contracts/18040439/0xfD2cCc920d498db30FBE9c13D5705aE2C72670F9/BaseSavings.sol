// SPDX-License-Identifier: BUSL-1.1

/*
                      *                                                  █                              
                    *****                                               ▓▓▓                             
                      *                                               ▓▓▓▓▓▓▓                         
                                       *            ///.           ▓▓▓▓▓▓▓▓▓▓▓▓▓                       
                                     *****        ////////            ▓▓▓▓▓▓▓                          
                                       *       /////////////            ▓▓▓                             
                         ▓▓                  //////////////////          █         ▓▓                   
                       ▓▓  ▓▓             ///////////////////////                ▓▓   ▓▓                
                     ▓▓       ▓▓        ////////////////////////////           ▓▓        ▓▓              
                  ▓▓            ▓▓    /////////▓▓▓///////▓▓▓/////////       ▓▓             ▓▓            
                ▓▓                ,////////////////////////////////////// ▓▓                 ▓▓         
              ▓▓                 //////////////////////////////////////////                     ▓▓      
            ▓▓                //////////////////////▓▓▓▓/////////////////////                          
                           ,////////////////////////////////////////////////////                        
                        .//////////////////////////////////////////////////////////                     
                         .//////////////////////////██.,//////////////////////////█                     
                           .//////////////////////████..,./////////////////////██                       
                            ...////////////////███████.....,.////////////////███                        
                              ,.,////////////████████ ........,///////////████                          
                                .,.,//////█████████      ,.......///////████                            
                                   ,..//████████           ........./████                               
                                     ..,██████                .....,███                                 
                                        .██                     ,.,█                                    
                                                                                                    
                                                                                                    
                                                                                                    
                   ▓▓            ▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▓▓▓        ▓▓               ▓▓▓▓▓▓▓▓▓▓          
                 ▓▓▓▓▓▓          ▓▓▓    ▓▓▓       ▓▓▓               ▓▓               ▓▓   ▓▓▓▓         
               ▓▓▓    ▓▓▓        ▓▓▓    ▓▓▓       ▓▓▓    ▓▓▓        ▓▓               ▓▓▓▓▓             
              ▓▓▓        ▓▓      ▓▓▓    ▓▓▓       ▓▓▓▓▓▓▓▓▓▓        ▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▓▓▓          
*/

pragma solidity ^0.8.19;

import "./ERC4626Upgradeable.sol";
import "./IERC20.sol";
import "./SafeERC20.sol";

import "./IAgToken.sol";

import "./AccessControl.sol";

import "./Constants.sol";
import "./Errors.sol";

/// @title BaseSavings
/// @author Angle Labs, Inc.
/// @notice Angle Savings contracts are contracts where users can deposit an `asset` and earn a yield on this asset
/// when it is distributed
/// @dev These contracts are functional within the Transmuter system if they have mint right on `asset` and
/// if they are trusted by the Transmuter contract
/// @dev Implementations assume that `asset` is safe to interact with, on which there cannot be reentrancy attacks
/// @dev The ERC4626 interface does not allow users to specify a slippage protection parameter for the main entry points
/// (like `deposit`, `mint`, `redeem` or `withdraw`). Even though there should be no specific sandwiching
/// issue with current implementations, it is still recommended to interact with Angle Savings contracts
/// through a router that can implement such a protection.
abstract contract BaseSavings is ERC4626Upgradeable, AccessControl {

}

