// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title iNVM_SafetyChecker
 */
interface iNVM_SafetyChecker {

    /********************
     * Public Functions *
     ********************/

    function isBytecodeSafe(bytes calldata _bytecode) external pure returns (bool);
}
