// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;

import "./IMintableBurnableERC20.sol";
import "./ERC20Permit.sol";

contract MintableBurnablePermitableERC20 is ERC20Permit, IMintableBurnableERC20 {

    address public owner;
    mapping (address => bool) public isMinter;

    constructor(string memory _name, string memory _symbol) ERC20Permit(_name) ERC20(_name, _symbol) {
        owner = msg.sender;
    }

    function transferOwner(address _owner) external override {
        require(msg.sender == owner, "!owner");
        owner = _owner;
    }

    function setMinter(address _minter, bool _status) external override {
        require(msg.sender == owner, "!owner");
        isMinter[_minter] = _status;
    }

    function mint(address _to, uint256 _amount) external override {
        require(isMinter[msg.sender] == true, "!minter");
        _mint(_to, _amount);
    }

    function burn(uint256 _amount) external override {
        _burn(msg.sender, _amount);
    }
}
