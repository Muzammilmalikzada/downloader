//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./console.sol";
import "./ERC20PresetMinterPauser.sol";
import "./ERC20Snapshot.sol";
import "./Ownable.sol";


contract KarateERC20 is Ownable, ERC20Snapshot {
   uint256 constant BILLION = 10**9;
   uint256 constant INIT_SUPPLY = 77 * BILLION * 10**18;
    constructor() ERC20("Karate", "KARATE") {
        uint256 initialSupply = INIT_SUPPLY;
        _mint(_msgSender(), initialSupply);
    }

    function createSnapshot() external onlyOwner returns (uint256 snapshotId) {
        return ERC20Snapshot._snapshot();
    }

    function getCurrentSnapshotId() external view returns (uint256 snapshotId) {
        return ERC20Snapshot._getCurrentSnapshotId();
    }

    function mint(address to, uint256 amount) public virtual onlyOwner {
        _mint(to, amount);
    }

}

