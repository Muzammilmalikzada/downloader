// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./Proxy.sol";
import "./IDiamondBase.sol";
import "./DiamondBaseStorage.sol";

/**
 * @title EIP-2535 "Diamond" proxy base contract
 * @dev see https://eips.ethereum.org/EIPS/eip-2535
 */
abstract contract DiamondBase is IDiamondBase, Proxy {
    /**
     * @inheritdoc Proxy
     */
    function _getImplementation() internal view override returns (address) {
        // inline storage layout retrieval uses less gas
        DiamondBaseStorage.Layout storage l;
        bytes32 slot = DiamondBaseStorage.STORAGE_SLOT;
        assembly {
            l.slot := slot
        }

        address implementation = address(bytes20(l.facets[msg.sig]));

        if (implementation == address(0)) {
            implementation = l.fallbackAddress;
            if (implementation == address(0))
                revert DiamondBase__NoFacetForSignature();
        }

        return implementation;
    }
}
