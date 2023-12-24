// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "./ERC20Snapshot.sol";
import "./Ownable.sol";

contract WowGuyTheEddyWallyCoin is ERC20, ERC20Burnable, ERC20Snapshot, Ownable {
    constructor() ERC20("Wow Guy, the Eddy Wally Coin", "WOWGUY") {
        _mint(msg.sender, 120719320 * 10 ** decimals());
    }

    function snapshot() public onlyOwner {
        _snapshot();
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
