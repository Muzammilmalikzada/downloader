// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ERC20PausableUpgradeable.sol";
import "./Math.sol";

import "./Configurable.sol";
import "./ICToken.sol";

/**
 * @title Staked token.
 * @author GenesisLRT
 * @notice cToken accumulates interest through their exchange ratio — over time, cToken becomes convertible into an increasing
 * amount of ETH, even while the number of cTokens in your wallet stays the same.
 *
 * This contract allows the minting and burning of "shares" (represented using the ERC20 inheritance) in exchange for
 * ETH. This contract extends the ERC20 standard.
 */
contract cToken is Configurable, ERC20PausableUpgradeable, ICToken {
    using Math for uint256;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;

    /*******************************************************************************
                        CONSTRUCTOR
    *******************************************************************************/

    /// @dev https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable#initializing_the_implementation_contract
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        IProtocolConfig config,
        string memory name,
        string memory symbol
    ) external initializer {
        __Configurable_init(config);
        __ERC20_init(name, symbol);
        __Pausable_init();
        __ERC20Pausable_init();
        __cToken_init();
    }

    function __cToken_init() internal {}

    /*******************************************************************************
                        WRITE FUNCTIONS
    *******************************************************************************/

    /**
     * @notice Mints exactly `shares` to `account`.
     * - emit the Transfer event from zero address.
     */
    function mint(
        address account,
        uint256 shares
    ) external override whenNotPaused onlyRestakingPool {
        _mint(account, shares);
    }

    /**
     * @notice Burns exactly `shares` from `account`.
     * - emit the Transfer event to zero address.
     * - revert if all of shares cannot be burned (due to the owner not having enough shares).
     */
    function burn(
        address account,
        uint256 shares
    ) external override whenNotPaused onlyRestakingPool {
        _burn(account, shares);
    }

    /*******************************************************************************
                        READ FUNCTIONS
    *******************************************************************************/

    /**
     * @notice Returns the `amount` of ETH that the cToken would exchange for the amount of `shares` provided, in an ideal
     * scenario where all the conditions are met.
     */
    function convertToAmount(
        uint256 shares
    ) public view override returns (uint256) {
        return shares.mulDiv(1 ether, ratio(), Math.Rounding.Ceil);
    }

    /**
     * @notice Returns the amount of `shares` that the cToken would exchange for the `amount` of ETH provided, in an ideal
     * scenario where all the conditions are met.
     */
    function convertToShares(
        uint256 amount
    ) public view override returns (uint256) {
        return amount.mulDiv(ratio(), 1 ether, Math.Rounding.Floor);
    }

    /**
     * @notice Returns ratio of cToken from ratio feed
     */
    function ratio() public view override returns (uint256) {
        return config().getRatioFeed().getRatio(address(this));
    }

    /**
     * @dev Returns the total amount of the ETH that is “managed” by Genesis.
     * @return totalManagedEth Total ETH amount into Genesis protocol.
     */
    function totalAssets()
        external
        view
        override
        returns (uint256 totalManagedEth)
    {
        return convertToAmount(totalSupply());
    }

    /*******************************************************************************
                        GOVERNANCE FUNCTIONS
    *******************************************************************************/

    /**
     * @dev Reimplemented to apply {onlyGovernance} modifier.
     */
    function pause() external virtual onlyGovernance {
        _pause();
    }

    /**
     * @dev Reimplemented to apply {onlyGovernance} modifier.
     */
    function unpause() external virtual onlyGovernance {
        _unpause();
    }
}
