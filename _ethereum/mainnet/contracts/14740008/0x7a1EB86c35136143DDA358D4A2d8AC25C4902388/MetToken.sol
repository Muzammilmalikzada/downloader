// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.4;
import "./Ownable.sol";
import "./ERC20.sol";
import "./ERC20Burnable.sol";


contract MetToken is ERC20, ERC20Burnable, Ownable {

  mapping(address => bool) controllers;
  
  constructor() ERC20("Metroverse", "MET") { }

  function mint(address to, uint256 amount) external {
    require(controllers[msg.sender], "Only controllers can mint");
    _mint(to, amount);
  }

  function burnFrom(address account, uint256 amount) public override {
      if (controllers[msg.sender]) {
          _burn(account, amount);
      }
      else {
          super.burnFrom(account, amount);
      }
  }

  function addController(address controller) external onlyOwner {
    controllers[controller] = true;
  }

  function removeController(address controller) external onlyOwner {
    controllers[controller] = false;
  }
}
