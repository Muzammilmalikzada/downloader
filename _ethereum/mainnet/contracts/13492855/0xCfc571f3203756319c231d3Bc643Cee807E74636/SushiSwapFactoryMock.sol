// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
import "./IUniswapV2Factory.sol";
import "./UniswapV2Factory.sol";

contract SushiSwapFactoryMock is UniswapV2Factory {
    constructor() public UniswapV2Factory(msg.sender) {
        return;
    }
}
