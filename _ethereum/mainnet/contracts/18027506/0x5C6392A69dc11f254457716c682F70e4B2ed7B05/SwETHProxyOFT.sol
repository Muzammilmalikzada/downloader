// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "./ProxyOFT.sol";

contract SwETHProxyOFT is ProxyOFT {
    constructor(address _layerZeroEndpoint, address _token) ProxyOFT(_layerZeroEndpoint, _token) {}
}
