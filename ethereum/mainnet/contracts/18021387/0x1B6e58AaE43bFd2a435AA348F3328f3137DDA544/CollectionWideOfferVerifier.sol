// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "./IERC721.sol";

import "./ISignatureVerifier.sol";
import "./IVaultFactory.sol";

import "./Lending.sol";

/**
 * @title CollectionWideOfferVerifier
 * @author Non-Fungible Technologies, Inc.
 *
 * This contract can be used for verifying a collection-wide offer for
 * an ERC721, and is agnostic in that it can verify both vaulted
 * and unbundled collateral. This is a common use case for many lenders,
 * who do not care whether the collateral is vauled.
 *
 * Predicates for this verify are _always_ wildcards: the caller's
 * predicate payload is a NFT address only, and the verifier will
 * check for _any_ balance of that asset.
 */
contract CollectionWideOfferVerifier is ISignatureVerifier {
    // ==================================== COLLATERAL VERIFICATION =====================================

    /**
     * @notice Verify that the items specified by the predicate calldata match the loan terms
     *         based on reported collateral address and ID, or that the collateral address
     *         is a vault factory and the vault contains the specified item.
     *
     * @param collateralAddress             The address of the loan's collateral.
     * @param collateralId                  The tokenId of the loan's collateral.
     * @param data                          The calldata needed for the verifier.
     *
     * @return verified                     Whether the bundle contains the specified items.
     */
    function verifyPredicates(
        address, address,
        address collateralAddress,
        uint256 collateralId,
        bytes calldata data
    ) external view override returns (bool) {
        // Unpack items
        (address token) = abi.decode(data, (address));

        // Unvaulted case - collateral will be escrowed directly
        if (collateralAddress == token) return true;

        // Do vault check
        address vaultAddress = IVaultFactory(collateralAddress).instanceAt(collateralId);

        // Make sure vault address, converted back into uint256, matches the original
        // collateralId. An arbitrary collateralId could theoretically collide with the
        // another vault's address, meaning the wrong vault would be checked.
        if (collateralId != uint256(uint160(vaultAddress))) revert IV_InvalidCollateralId(collateralId);

        return IERC721(token).balanceOf(vaultAddress) > 0;
    }
}
