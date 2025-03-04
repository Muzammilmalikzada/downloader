// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.6.6. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

interface IDefinitiveVault {
    event AddLiquidity(uint256[] amounts, uint256 lpTokenAmount);
    event CancelWithdrawal(
        address indexed actor,
        address indexed erc20Token,
        uint256 amount,
        address indexed recipient
    );
    event Deposit(
        address indexed actor,
        address[] erc20Tokens,
        uint256[] amounts
    );
    event Enter(uint256[] amounts, uint256 stakedAmount);
    event Exit(uint256 unstakedAmount, uint256[] amounts);
    event ExitOne(uint256 unstakedAmount, address erc20Token, uint256 amount);
    event HandlerDisabled(address indexed handler, address indexed disabler);
    event HandlerEnabled(address indexed handler, address indexed enabler);
    event RemoveLiquidity(uint256 lpTokenAmount, uint256[] amounts);
    event RequestWithdrawal(
        address indexed actor,
        address indexed erc20Token,
        uint256 amount
    );
    event RewardTokenUpdate(address actor, address rewardToken, bool isEnabled);
    event RewardsClaimed(
        address[] rewardTokens,
        uint256[] rewardAmounts,
        address recipient
    );
    event RewardsHandled(
        address[] rewardTokens,
        uint256[] rewardAmounts,
        address outputToken,
        uint256 outputAmount,
        uint256 feeAmount
    );
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    event Stake(uint256 amount);
    event StopGuardianUpdate(address indexed actor, bool indexed isEnabled);
    event Unstake(uint256 amount);
    event Withdrawal(
        address indexed approver,
        address indexed erc20Token,
        uint256 amount,
        address indexed recipient
    );

    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);

    function DEFAULT_DEADLINE() external view returns (uint256);

    function FEE_ACCOUNT() external view returns (address);

    function LP_DEPOSIT_POOL() external view returns (address);

    function LP_STAKING() external view returns (address);

    function LP_STAKING_POOL_ID() external view returns (uint256);

    function LP_TOKEN() external view returns (address);

    function LP_UNDERLYING_TOKENS(uint256) external view returns (address);

    function LP_UNDERLYING_TOKENS_COUNT() external view returns (uint256);

    function MAX_FEE_PCT() external view returns (uint256);

    function ROLE_CLIENT() external view returns (bytes32);

    function ROLE_DEFINITIVE() external view returns (bytes32);

    function STOP_GUARDIAN_ENABLED() external view returns (bool);

    function WITHDRAWAL_2FA_ENABLED() external view returns (bool);

    function addLiquidity(
        uint256[] memory amounts,
        uint256 minAmount
    ) external returns (uint256 lpTokenAmount);

    function approveWithdrawalRequest(uint16 index) external returns (bool);

    function cancelPendingWithdrawal(uint16 index) external;

    function claimAllRewards(
        uint256 feePct
    ) external returns (address[] memory, uint256[] memory);

    function deposit(
        uint256[] memory amounts,
        address[] memory erc20Tokens
    ) external payable;

    function disableHandlers(address[] memory handlers) external;

    function disableRewardTokens(address[] memory rewardTokens) external;

    function disableStopGuardian() external;

    function enableHandlers(address[] memory handlers) external;

    function enableRewardTokens(address[] memory rewardTokens) external;

    function enableStopGuardian() external;

    function enter(
        uint256[] memory amounts,
        uint256 minAmount
    ) external returns (uint256 stakedAmount);

    function exit(
        uint256 lpTokenAmount,
        uint256[] memory minAmounts
    ) external returns (uint256[] memory amounts);

    function exitOne(
        uint256 lpTokenAmount,
        uint256 minAmount,
        uint8 index
    ) external returns (uint256 amount);

    function getAmountStaked() external view returns (uint256);

    function getBalance(address tokenAddress) external view returns (uint256);

    function getPendingWithdrawal(
        uint16 index
    ) external view returns (PendingWithdrawal memory);

    function getPendingWithdrawalsCount() external view returns (uint256 count);

    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    function grantRole(bytes32 role, address account) external;

    function handleRewards(
        HandleRewardPayload[] memory payloads,
        address outputToken,
        uint256 feePct
    ) external;

    function hasRole(
        bytes32 role,
        address account
    ) external view returns (bool);

    function isHandlerEnabled(address handler) external view returns (bool);

    function isRewardTokenEnabled(
        address rewardToken
    ) external view returns (bool);

    function multicall(
        bytes[] memory data
    ) external returns (bytes[] memory results);

    function removeLiquidity(
        uint256 lpTokenAmount,
        uint256[] memory minAmounts
    ) external returns (uint256[] memory amounts);

    function removeLiquidityOneCoin(
        uint256 lpTokenAmount,
        uint256 minAmount,
        uint8 index
    ) external returns (uint256[] memory amounts);

    function renounceRole(bytes32 role, address account) external;

    function revokeRole(bytes32 role, address account) external;

    function stake(uint256 amount) external;

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function supportsNativeAssets() external pure returns (bool);

    function unclaimedRewards()
        external
        view
        returns (address[] memory, uint256[] memory);

    function unstake(uint256 amount) external;

    function updateFeeAccount(address _feeAccount) external;

    function withdraw(
        uint256 amount,
        address erc20Token
    ) external returns (bool);
}

struct CoreAccessControlConfig {
    address admin;
    address[] definitive;
    address[] client;
}

struct CoreHandlerStoreConfig {
    address[] handlers;
}

struct CoreWithdrawConfig {
    bool withdrawal2FA;
}

struct CoreRewardsConfig {
    address[] rewardTokens;
    address feeAccount;
}

struct LPStakingConfig {
    address[] lpUnderlyingTokens;
    address lpDepositPool;
    address lpStaking;
    address lpToken;
    uint256 stakingPoolId;
}

struct PendingWithdrawal {
    address requester;
    uint256 amount;
    address erc20Token;
    address to;
    uint256 blockNumber;
}

struct HandleRewardPayload {
    address handler;
    uint256 amount;
    address rewardToken;
    bytes handlerCalldata;
    bool isDelegate;
}

// THIS FILE WAS AUTOGENERATED FROM THE FOLLOWING ABI JSON:
/*
[{"inputs":[{"components":[{"internalType":"address","name":"admin","type":"address"},{"internalType":"address[]","name":"definitive","type":"address[]"},{"internalType":"address[]","name":"client","type":"address[]"}],"internalType":"struct CoreAccessControlConfig","name":"coreAccessControlConfig","type":"tuple"},{"components":[{"internalType":"address[]","name":"handlers","type":"address[]"}],"internalType":"struct CoreHandlerStoreConfig","name":"coreHandlerStoreConfig","type":"tuple"},{"components":[{"internalType":"bool","name":"withdrawal2FA","type":"bool"}],"internalType":"struct CoreWithdrawConfig","name":"coreWithdrawConfig","type":"tuple"},{"components":[{"internalType":"address[]","name":"rewardTokens","type":"address[]"},{"internalType":"address payable","name":"feeAccount","type":"address"}],"internalType":"struct CoreRewardsConfig","name":"coreRewardsConfig","type":"tuple"},{"components":[{"internalType":"address[]","name":"lpUnderlyingTokens","type":"address[]"},{"internalType":"address","name":"lpDepositPool","type":"address"},{"internalType":"address","name":"lpStaking","type":"address"},{"internalType":"address","name":"lpToken","type":"address"},{"internalType":"uint256","name":"stakingPoolId","type":"uint256"}],"internalType":"struct LPStakingConfig","name":"lpConfig","type":"tuple"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256[]","name":"amounts","type":"uint256[]"},{"indexed":false,"internalType":"uint256","name":"lpTokenAmount","type":"uint256"}],"name":"AddLiquidity","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"actor","type":"address"},{"indexed":true,"internalType":"address","name":"erc20Token","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":true,"internalType":"address","name":"recipient","type":"address"}],"name":"CancelWithdrawal","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"actor","type":"address"},{"indexed":false,"internalType":"address[]","name":"erc20Tokens","type":"address[]"},{"indexed":false,"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256[]","name":"amounts","type":"uint256[]"},{"indexed":false,"internalType":"uint256","name":"stakedAmount","type":"uint256"}],"name":"Enter","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"unstakedAmount","type":"uint256"},{"indexed":false,"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"name":"Exit","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"unstakedAmount","type":"uint256"},{"indexed":false,"internalType":"address","name":"erc20Token","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"ExitOne","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"handler","type":"address"},{"indexed":true,"internalType":"address","name":"disabler","type":"address"}],"name":"HandlerDisabled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"handler","type":"address"},{"indexed":true,"internalType":"address","name":"enabler","type":"address"}],"name":"HandlerEnabled","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"lpTokenAmount","type":"uint256"},{"indexed":false,"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"name":"RemoveLiquidity","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"actor","type":"address"},{"indexed":true,"internalType":"address","name":"erc20Token","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"RequestWithdrawal","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"actor","type":"address"},{"indexed":false,"internalType":"address","name":"rewardToken","type":"address"},{"indexed":false,"internalType":"bool","name":"isEnabled","type":"bool"}],"name":"RewardTokenUpdate","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"contract IERC20[]","name":"rewardTokens","type":"address[]"},{"indexed":false,"internalType":"uint256[]","name":"rewardAmounts","type":"uint256[]"},{"indexed":false,"internalType":"address","name":"recipient","type":"address"}],"name":"RewardsClaimed","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address[]","name":"rewardTokens","type":"address[]"},{"indexed":false,"internalType":"uint256[]","name":"rewardAmounts","type":"uint256[]"},{"indexed":false,"internalType":"address","name":"outputToken","type":"address"},{"indexed":false,"internalType":"uint256","name":"outputAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"feeAmount","type":"uint256"}],"name":"RewardsHandled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"bytes32","name":"previousAdminRole","type":"bytes32"},{"indexed":true,"internalType":"bytes32","name":"newAdminRole","type":"bytes32"}],"name":"RoleAdminChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleGranted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleRevoked","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Stake","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"actor","type":"address"},{"indexed":true,"internalType":"bool","name":"isEnabled","type":"bool"}],"name":"StopGuardianUpdate","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Unstake","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"approver","type":"address"},{"indexed":true,"internalType":"address","name":"erc20Token","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":true,"internalType":"address","name":"recipient","type":"address"}],"name":"Withdrawal","type":"event"},{"inputs":[],"name":"DEFAULT_ADMIN_ROLE","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"DEFAULT_DEADLINE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"FEE_ACCOUNT","outputs":[{"internalType":"address payable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"LP_DEPOSIT_POOL","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"LP_STAKING","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"LP_STAKING_POOL_ID","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"LP_TOKEN","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"LP_UNDERLYING_TOKENS","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"LP_UNDERLYING_TOKENS_COUNT","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"MAX_FEE_PCT","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"ROLE_CLIENT","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"ROLE_DEFINITIVE","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"STOP_GUARDIAN_ENABLED","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"WITHDRAWAL_2FA_ENABLED","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"},{"internalType":"uint256","name":"minAmount","type":"uint256"}],"name":"addLiquidity","outputs":[{"internalType":"uint256","name":"lpTokenAmount","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint16","name":"index","type":"uint16"}],"name":"approveWithdrawalRequest","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint16","name":"index","type":"uint16"}],"name":"cancelPendingWithdrawal","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"feePct","type":"uint256"}],"name":"claimAllRewards","outputs":[{"internalType":"contract IERC20[]","name":"","type":"address[]"},{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"},{"internalType":"address[]","name":"erc20Tokens","type":"address[]"}],"name":"deposit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"handlers","type":"address[]"}],"name":"disableHandlers","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"rewardTokens","type":"address[]"}],"name":"disableRewardTokens","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"disableStopGuardian","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"handlers","type":"address[]"}],"name":"enableHandlers","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"rewardTokens","type":"address[]"}],"name":"enableRewardTokens","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"enableStopGuardian","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"},{"internalType":"uint256","name":"minAmount","type":"uint256"}],"name":"enter","outputs":[{"internalType":"uint256","name":"stakedAmount","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"lpTokenAmount","type":"uint256"},{"internalType":"uint256[]","name":"minAmounts","type":"uint256[]"}],"name":"exit","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"lpTokenAmount","type":"uint256"},{"internalType":"uint256","name":"minAmount","type":"uint256"},{"internalType":"uint8","name":"index","type":"uint8"}],"name":"exitOne","outputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getAmountStaked","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"tokenAddress","type":"address"}],"name":"getBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint16","name":"index","type":"uint16"}],"name":"getPendingWithdrawal","outputs":[{"components":[{"internalType":"address","name":"requester","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"address","name":"erc20Token","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"blockNumber","type":"uint256"}],"internalType":"struct PendingWithdrawal","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getPendingWithdrawalsCount","outputs":[{"internalType":"uint256","name":"count","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"getRoleAdmin","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"grantRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"components":[{"internalType":"address","name":"handler","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"address","name":"rewardToken","type":"address"},{"internalType":"bytes","name":"handlerCalldata","type":"bytes"},{"internalType":"bool","name":"isDelegate","type":"bool"}],"internalType":"struct HandleRewardPayload[]","name":"payloads","type":"tuple[]"},{"internalType":"address","name":"outputToken","type":"address"},{"internalType":"uint256","name":"feePct","type":"uint256"}],"name":"handleRewards","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"hasRole","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"handler","type":"address"}],"name":"isHandlerEnabled","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"rewardToken","type":"address"}],"name":"isRewardTokenEnabled","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes[]","name":"data","type":"bytes[]"}],"name":"multicall","outputs":[{"internalType":"bytes[]","name":"results","type":"bytes[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"lpTokenAmount","type":"uint256"},{"internalType":"uint256[]","name":"minAmounts","type":"uint256[]"}],"name":"removeLiquidity","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"lpTokenAmount","type":"uint256"},{"internalType":"uint256","name":"minAmount","type":"uint256"},{"internalType":"uint8","name":"index","type":"uint8"}],"name":"removeLiquidityOneCoin","outputs":[{"internalType":"uint256[]","name":"amounts","type":"uint256[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"renounceRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"revokeRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"stake","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"supportsNativeAssets","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"unclaimedRewards","outputs":[{"internalType":"contract IERC20[]","name":"","type":"address[]"},{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"unstake","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address payable","name":"_feeAccount","type":"address"}],"name":"updateFeeAccount","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"address","name":"erc20Token","type":"address"}],"name":"withdraw","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}]
*/
