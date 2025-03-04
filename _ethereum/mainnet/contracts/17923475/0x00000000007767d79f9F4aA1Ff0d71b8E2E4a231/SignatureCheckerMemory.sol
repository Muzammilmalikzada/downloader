// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Interfaces
import "./IERC1271.sol";

// Constants
import "./StandardConstants.sol";

// Errors
import "./SignatureCheckerErrors.sol";

/**
 * @title SignatureCheckerMemory
 * @notice This library is used to verify signatures for EOAs (with lengths of both 65 and 64 bytes)
 *         and contracts (ERC1271).
 * @author LooksRare protocol team (👀,💎)
 */
library SignatureCheckerMemory {
    /**
     * @notice This function verifies whether the signer is valid for a hash and raw signature.
     * @param hash Data hash
     * @param signer Signer address (to confirm message validity)
     * @param signature Signature parameters encoded (v, r, s)
     * @dev For EIP-712 signatures, the hash must be the digest (computed with signature hash and domain separator)
     */
    function verify(bytes32 hash, address signer, bytes memory signature) internal view {
        if (signer.code.length == 0) {
            if (_recoverEOASigner(hash, signature) == signer) return;
            revert SignatureEOAInvalid();
        } else {
            if (IERC1271(signer).isValidSignature(hash, signature) == ERC1271_MAGIC_VALUE) return;
            revert SignatureERC1271Invalid();
        }
    }

    /**
     * @notice This function is internal and splits a signature into r, s, v outputs.
     * @param signature A 64 or 65 bytes signature
     * @return r The r output of the signature
     * @return s The s output of the signature
     * @return v The recovery identifier, must be 27 or 28
     */
    function splitSignature(bytes memory signature) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        uint256 length = signature.length;

        if (length == 65) {
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
        } else if (length == 64) {
            assembly {
                r := mload(add(signature, 0x20))
                let vs := mload(add(signature, 0x40))
                s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
                v := add(shr(255, vs), 27)
            }
        } else {
            revert SignatureLengthInvalid(length);
        }

        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            revert SignatureParameterSInvalid();
        }

        if (v != 27 && v != 28) {
            revert SignatureParameterVInvalid(v);
        }
    }

    /**
     * @notice This function is private and recovers the signer of a signature (for EOA only).
     * @param hash Hash of the signed message
     * @param signature Bytes containing the signature (64 or 65 bytes)
     * @return signer The address that signed the signature
     */
    function _recoverEOASigner(bytes32 hash, bytes memory signature) private pure returns (address signer) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(signature);

        // If the signature is valid (and not malleable), return the signer's address
        signer = ecrecover(hash, v, r, s);

        if (signer == address(0)) {
            revert NullSignerAddress();
        }
    }
}
