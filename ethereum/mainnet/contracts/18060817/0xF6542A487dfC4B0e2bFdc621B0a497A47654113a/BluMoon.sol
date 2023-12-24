// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./ERC20.sol";
import "./Ownable.sol";
import "./ERC20Burnable.sol";



contract BluMoon is ERC20, Ownable, ERC20Burnable {
    constructor(uint256 initialSupply) ERC20("BluMoon", "BLU") {
        _mint(msg.sender, initialSupply);
    }
    function specialThing() public onlyOwner {
        // only the owner can call specialThing()!
    }

}

