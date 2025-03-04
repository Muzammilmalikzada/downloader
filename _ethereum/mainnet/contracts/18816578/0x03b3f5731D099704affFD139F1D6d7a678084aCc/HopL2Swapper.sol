// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.8.0;

import "./BytesHelpers.sol";
import "./IHopL2Amm.sol";
import "./IHopSwapConnector.sol";

import "./BaseSwapTask.sol";
import "./IHopL2Swapper.sol";

/**
 * @title Hop L2 swapper
 * @dev Task that extends the base swap task to use Hop
 */
contract HopL2Swapper is IHopL2Swapper, BaseSwapTask {
    using FixedPoint for uint256;
    using BytesHelpers for bytes;

    // Execution type for relayers
    bytes32 public constant override EXECUTION_TYPE = keccak256('HOP_L2_SWAPPER');

    // List of AMMs per token
    mapping (address => address) public override tokenAmm;

    /**
     * @dev Token amm config. Only used in the initializer.
     */
    struct TokenAmm {
        address token;
        address amm;
    }

    /**
     * @dev Hop L2 swap config. Only used in the initializer.
     */
    struct HopL2SwapConfig {
        TokenAmm[] tokenAmms;
        BaseSwapConfig baseSwapConfig;
    }

    /**
     * @dev Initializes the Hop L2 swapper
     * @param config Hop L2 swap config
     */
    function initialize(HopL2SwapConfig memory config) external virtual initializer {
        __HopL2Swapper_init(config);
    }

    /**
     * @dev Initializes the Hop L2 swapper. It does call upper contracts initializers.
     * @param config Hop L2 swap config
     */
    function __HopL2Swapper_init(HopL2SwapConfig memory config) internal onlyInitializing {
        __BaseSwapTask_init(config.baseSwapConfig);
        __HopL2Swapper_init_unchained(config);
    }

    /**
     * @dev Initializes the Hop L2 swapper. It does not call upper contracts initializers.
     * @param config Hop L2 swap config
     */
    function __HopL2Swapper_init_unchained(HopL2SwapConfig memory config) internal onlyInitializing {
        for (uint256 i = 0; i < config.tokenAmms.length; i++) {
            _setTokenAmm(config.tokenAmms[i].token, config.tokenAmms[i].amm);
        }
    }

    /**
     * @dev Sets an AMM for a hToken
     * @param hToken Address of the hToken to be set
     * @param amm AMM address to be set for the hToken
     */
    function setTokenAmm(address hToken, address amm) external authP(authParams(hToken, amm)) {
        _setTokenAmm(hToken, amm);
    }

    /**
     * @dev Execution function
     */
    function call(address hToken, uint256 amount, uint256 slippage)
        external
        override
        authP(authParams(hToken, amount, slippage))
    {
        if (amount == 0) amount = getTaskAmount(hToken);
        _beforeHopL2Swapper(hToken, amount, slippage);

        address tokenOut = getTokenOut(hToken);
        address dexAddress = IHopL2Amm(tokenAmm[hToken]).exchangeAddress();
        uint256 minAmountOut = amount.mulUp(FixedPoint.ONE - slippage);
        bytes memory connectorData = abi.encodeWithSelector(
            IHopSwapConnector.execute.selector,
            hToken,
            tokenOut,
            amount,
            minAmountOut,
            dexAddress
        );

        bytes memory result = ISmartVault(smartVault).execute(connector, connectorData);
        _afterHopL2Swapper(hToken, amount, slippage, tokenOut, result.toUint256());
    }

    /**
     * @dev Before Hop L2 swapper hook
     */
    function _beforeHopL2Swapper(address token, uint256 amount, uint256 slippage) internal virtual {
        _beforeBaseSwapTask(token, amount, slippage);
        if (tokenAmm[token] == address(0)) revert TaskMissingHopTokenAmm();
    }

    /**
     * @dev After Hop L2 swapper hook
     */
    function _afterHopL2Swapper(
        address tokenIn,
        uint256 amountIn,
        uint256 slippage,
        address tokenOut,
        uint256 amountOut
    ) internal virtual {
        _afterBaseSwapTask(tokenIn, amountIn, slippage, tokenOut, amountOut);
    }

    /**
     * @dev Set an AMM for a Hop token
     * @param hToken Address of the hToken to set an AMM for
     * @param amm AMM to be set
     */
    function _setTokenAmm(address hToken, address amm) internal {
        if (hToken == address(0)) revert TaskTokenZero();
        if (amm != address(0) && hToken != IHopL2Amm(amm).hToken()) revert TaskHopTokenAmmMismatch(hToken, amm);

        tokenAmm[hToken] = amm;
        emit TokenAmmSet(hToken, amm);
    }
}
