// SPDX-License-Identifier: GPL-2.0-or-later
// Gearbox Protocol. Generalized leverage for DeFi protocols
// (c) Gearbox Foundation, 2023.
pragma solidity ^0.8.17;

import "./IERC20.sol";
import "./PhantomERC20.sol";
import "./IERC20Metadata.sol";

/// @title Convex staked position token
/// @notice Phantom ERC-20 token that represents the balance of the staking position in Convex pools
contract ConvexStakedPositionToken is PhantomERC20 {
    address public immutable pool;

    /// @notice Constructor
    /// @param _pool The Convex pool where the balance is tracked
    /// @param _lptoken The Convex LP token that is staked in the pool
    constructor(address _pool, address _lptoken)
        PhantomERC20(
            _lptoken,
            string(abi.encodePacked("Convex Staked Position ", IERC20Metadata(_lptoken).name())),
            string(abi.encodePacked("stk", IERC20Metadata(_lptoken).symbol())),
            IERC20Metadata(_lptoken).decimals()
        )
    {
        pool = _pool;
    }

    /// @notice Returns the amount of Convex LP tokens staked in the pool
    /// @param account The account for which the calculation is performed
    function balanceOf(address account) public view returns (uint256) {
        return IERC20(pool).balanceOf(account);
    }
}
