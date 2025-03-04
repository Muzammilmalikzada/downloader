pragma solidity 0.7.0;

import "./ERC20.sol";

contract CWAPToken is ERC20 {
    constructor(string memory name, string memory symbol, address owner, uint totalSupply) 
        public 
        ERC20(name, symbol)
    {
        _mint(owner, totalSupply);
    } 
}