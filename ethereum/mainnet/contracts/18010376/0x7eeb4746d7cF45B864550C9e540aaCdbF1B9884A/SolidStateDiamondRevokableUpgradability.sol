// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "./Ownable.sol";
import "./SafeOwnable.sol";
import "./IERC165.sol";
import "./IERC173.sol";
import "./ERC165Base.sol";
import "./DiamondBase.sol";
import "./DiamondFallback.sol";
import "./DiamondReadable.sol";
import "./DiamondWritable.sol";
import "./DiamondWritableRevokable.sol";
import "./ISolidStateDiamond.sol";

/**
 * @title SolidState "Diamond" proxy reference implementation with DiamondWritableRevokable
 */
abstract contract SolidStateDiamondRevokableUpgradability is
    ISolidStateDiamond,
    DiamondBase,
    DiamondFallback,
    DiamondReadable,
    DiamondWritableRevokable,
    SafeOwnable,
    ERC165Base
{
    constructor() {
        bytes4[] memory selectors = new bytes4[](12);
        uint256 selectorIndex;

        // register DiamondFallback

        selectors[selectorIndex++] = IDiamondFallback.getFallbackAddress.selector;
        selectors[selectorIndex++] = IDiamondFallback.setFallbackAddress.selector;

        _setSupportsInterface(type(IDiamondFallback).interfaceId, true);

        // register DiamondWritable

        selectors[selectorIndex++] = IDiamondWritable.diamondCut.selector;

        _setSupportsInterface(type(IDiamondWritable).interfaceId, true);

        // register DiamondReadable

        selectors[selectorIndex++] = IDiamondReadable.facets.selector;
        selectors[selectorIndex++] = IDiamondReadable.facetFunctionSelectors.selector;
        selectors[selectorIndex++] = IDiamondReadable.facetAddresses.selector;
        selectors[selectorIndex++] = IDiamondReadable.facetAddress.selector;

        _setSupportsInterface(type(IDiamondReadable).interfaceId, true);

        // register ERC165

        selectors[selectorIndex++] = IERC165.supportsInterface.selector;

        _setSupportsInterface(type(IERC165).interfaceId, true);

        // register SafeOwnable
        selectors[selectorIndex++] = Ownable.owner.selector;
        selectors[selectorIndex++] = SafeOwnable.nomineeOwner.selector;
        selectors[selectorIndex++] = Ownable.transferOwnership.selector;
        selectors[selectorIndex++] = SafeOwnable.acceptOwnership.selector;

        _setSupportsInterface(type(IERC173).interfaceId, true);

        // diamond cut

        FacetCut[] memory facetCuts = new FacetCut[](1);

        facetCuts[0] = FacetCut({ target: address(this), action: FacetCutAction.ADD, selectors: selectors });

        _diamondCut(facetCuts, address(0), "");

        // set owner

        _setOwner(msg.sender);
    }

    receive() external payable {}

    function _transferOwnership(address account) internal virtual override(OwnableInternal, SafeOwnable) {
        super._transferOwnership(account);
    }

    /**
     * @inheritdoc DiamondFallback
     */
    function _getImplementation()
        internal
        view
        override(DiamondBase, DiamondFallback)
        returns (address implementation)
    {
        implementation = super._getImplementation();
    }
}
