// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;   
                                                                      
/*
    __  ________   ____________  ___   _____ ______   __________  __ __ _______   __   ___ 
   /  |/  /  _/ | / / ____/ __ )/   | / ___// ____/  /_  __/ __ \/ //_// ____/ | / /  |__ \
  / /|_/ // //  |/ / __/ / __  / /| | \__ \/ __/      / / / / / / ,<  / __/ /  |/ /   __/ /
 / /  / // // /|  / /___/ /_/ / ___ |___/ / /___     / / / /_/ / /| |/ /___/ /|  /   / __/ 
/_/  /_/___/_/ |_/_____/_____/_/  |_/____/_____/    /_/  \____/_/ |_/_____/_/ |_/   /____/ 
                                                                   
*/

import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "./Ownable.sol";

contract CreativeTokenProduction is ERC20, ERC20Burnable, Ownable {
    uint256 private immutable _maxTokenSupply;

    constructor(
        address _contractOwner,
        address _tokenOwner,
        uint256 _preMintAmount,
        uint256 _maxTokenAmount,
        string memory _tokenName,
        string memory _tokenSymbol
    ) ERC20(_tokenName, _tokenSymbol) {
        require(_maxTokenAmount > 0, "ERC20MaxSupply: maxTokenSupply is 0");
        _maxTokenSupply = _maxTokenAmount * 10**decimals();
        _mint(_tokenOwner, _preMintAmount * 10**decimals());
        _transferOwnership(_contractOwner);
    }

    function maxSupply() public view virtual returns (uint256) {
        return _maxTokenSupply;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(ERC20.totalSupply() + amount <= maxSupply(), "ERC20MaxSupply: maxTokenSupply exceeded");
        _mint(to, amount);
    }
}