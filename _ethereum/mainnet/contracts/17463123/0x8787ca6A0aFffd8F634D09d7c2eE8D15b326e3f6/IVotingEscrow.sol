// SPDX-License-Identifier: GPL-3.0
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

pragma solidity >=0.6.11;

pragma experimental ABIEncoderV2;

// For compatibility, we're keeping the same function names as in the original Curve code, including the mixed-case
// naming convention.
// solhint-disable func-name-mixedcase

interface IVotingEscrow {
    struct Point {
        int128 bias;
        int128 slope; // - dweight / dt
        uint256 ts;
        uint256 blk; // block
    }

    function epoch() external view returns (uint256);

    function user_point_epoch(address user) external view returns (uint256);

    function slope_changes(uint256 i) external view returns (int128);

    function point_history(
        uint256 timestamp
    ) external view returns (Point memory);

    function user_point_history(
        address user,
        uint256 timestamp
    ) external view returns (Point memory);

    function checkpoint() external;
}
