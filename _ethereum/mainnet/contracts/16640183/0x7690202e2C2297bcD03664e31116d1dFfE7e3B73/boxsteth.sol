// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/*                                                                    
            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        
          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        
         @@@@@@                                                    @@@@@        
         @@@@@                                                     @@@@@        
         @@@@@                                                     @@@@@        
         @@@@@                      @@                             @@@@@        
         @@@@@                      @@@@@@                         @@@@         
         @@@@@                        @@@@@@@                                   
         @@@@@            @@@         @@@@@@@@@@@                               
         @@@@@             @@@@@@    @@@@@@@@@@@@@@@                            
         @@@@@              @@@@@@@@@@@@@@@@@@@@   @@@@                         
         @@@@@               @@@@@@@@@@@@@@@    @@  @@@@@@                       
         @@@@@                @@@@@@@@@@  @@@     @@@@@@@                       
         @@@@@                 @@@@@   @@  @@@@@@@@@@@@                         
         @@@@@                  @@@@       @@@@@@@@@@@                          
         @@@@@                   @@@@@@@@@@@@@@@@@@@@@                          
         @@@@@                   @@@@@@@@@@@@@@@@@@@@@@@                        
         @@@@@                      @@@@@       @@@@@@@@@                       
         @@@@@                                  @@@@@@@@@@                      
          @@@@@                                @@@@@@@@@@@@                     
           @@@@@                              @@@@@@@@@@@@@                     
            @@@@@@                          @@@@@@@@@@@@@@@                     
              @@@@@@                       @@@@@@@@@@@@@@@@                     
                @@@@@@@                  @@@@@@@@@@@@@@@@@@                     
                   @@@@@@@@@          @@@@@@@@@@@@@@@@@@@@                      
                       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*/

import "./ERC20.sol";
import "./AccessControl.sol";
import "./SafeERC20.sol";

contract boxsteth is ERC20, AccessControl {

    using SafeERC20 for ERC20;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _setupRole(ADMIN_ROLE, _msgSender());
        _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE); 
    }

    function mint(address recipient, uint256 amount) external onlyRole(ADMIN_ROLE) {
        _mint(recipient, amount);
    }

    function burn(uint256 amount) external {
        _burn(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) external {
        require(allowance(account, _msgSender()) - amount >= 0, "burn amount exceeds allowance");
        uint256 newAllowance = allowance(account, _msgSender());
        _approve(account, _msgSender(), newAllowance);
        _burn(account, amount);
    }
}
