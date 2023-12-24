// SPDX-License-Identifier: UNLICENSED
// solhint-disable-next-line compiler-version
pragma solidity >=0.8.0;

interface IOwnable {
    function owner() external view returns (address);
}
