// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IUniversalVaultEvents.sol";

/**
 * @notice IUniversalVault interface
 * @dev Source: https://github.com/ampleforth/token-geyser-v2/blob/c878fd6ba5856d818ff41c54bce59c9413bc93c9/contracts/UniversalVault.sol#L17-L87
 */
interface IUniversalVault is IUniversalVaultEvents {
    /* data types */

    struct LockData {
        address delegate;
        address token;
        uint256 balance;
    }

    /* initialize function */

    function initialize() external;

    /* user functions */

    function lock(address token, uint256 amount, bytes calldata permission) external;

    function unlock(address token, uint256 amount, bytes calldata permission) external;

    function rageQuit(address delegate, address token) external returns (bool notified, string memory error);

    function transferERC20(address token, address to, uint256 amount) external;

    function transferETH(address to, uint256 amount) external payable;

    /* pure functions */

    function calculateLockID(address delegate, address token) external pure returns (bytes32 lockID);

    /* getter functions */

    function getPermissionHash(bytes32 eip712TypeHash, address delegate, address token, uint256 amount, uint256 nonce)
        external
        view
        returns (bytes32 permissionHash);

    function getNonce() external view returns (uint256 nonce);

    function owner() external view returns (address ownerAddress);

    function getLockSetCount() external view returns (uint256 count);

    function getLockAt(uint256 index) external view returns (LockData memory lockData);

    function getBalanceDelegated(address token, address delegate) external view returns (uint256 balance);

    function getBalanceLocked(address token) external view returns (uint256 balance);

    function checkBalances() external view returns (bool validity);
}
