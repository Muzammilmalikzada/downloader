// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;

import "./IImmutableState.sol";

/// @title Immutable state
/// @notice Immutable state used by the swap router
abstract contract ImmutableState is IImmutableState {
    /// @inheritdoc IImmutableState
    address public immutable override positionManager;

    constructor(address _positionManager) {
        positionManager = _positionManager;
    }
}
