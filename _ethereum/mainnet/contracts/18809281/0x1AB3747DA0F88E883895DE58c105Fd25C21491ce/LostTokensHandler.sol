// Copyright (C) 2023 Zerion Inc. <https://zerion.io>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
//
// SPDX-License-Identifier: LGPL-3.0

pragma solidity 0.8.21;

import "./ILostTokensHandler.sol";

import "./Base.sol";
import "./Ownable.sol";

/**
 * @title Abstract contract returning tokens lost on the contract
 */
abstract contract LostTokensHandler is ILostTokensHandler, Ownable {
    /**
     * @inheritdoc ILostTokensHandler
     */
    function returnLostTokens(
        address token,
        address payable receiver
    ) external override onlyOwner {
        Base.transfer(token, receiver, Base.getBalance(token));
    }
}
