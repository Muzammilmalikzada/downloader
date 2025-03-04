// SPDX-License-Identifier: MIT
pragma solidity >=0.7.6 <0.9.0;

import "./Ownable.sol";
import "./AccessControl.sol";
import "./Pausable.sol";
import "./Address.sol";


contract Base is Ownable, AccessControl, Pausable {
    event DebugLog(string info);

    modifier isContract(address account) {
        require(Address.isContract(account), 'Caller is not a contract address');
        _;
    }

    modifier isExternal(address account) {
        require(!Address.isContract(account), 'Caller is not a external address');
        _;
    }

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, owner());
    }

    function debugLog(string memory info) internal {
        emit DebugLog(info);
    }
}