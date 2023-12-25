// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "./BaseLendingStrategy.sol";
import "./BaseFlashloanStrategy.sol";
import "./ApyFlowVault.sol";
import "./IERC4626Minimal.sol";
import "./SafeAssetConverter.sol";
import "./PricesLibrary.sol";
import "./Utils.sol";

/// @author YLDR <admin@apyflow.com>
abstract contract BaseHedgedStrategyWrapper is ApyFlowVault, BaseLendingStrategy, BaseFlashloanStrategy {
    using SafeAssetConverter for IAssetConverter;
    using PricesLibrary for ChainlinkPriceFeedAggregator;

    error LTVIsOK();

    IERC4626Minimal public immutable strategy;
    uint256 public immutable initialLTV;
    uint256 public immutable LTVToRebalance;

    ChainlinkPriceFeedAggregator public immutable pricesOracle;
    IAssetConverter public immutable assetConverter;

    constructor(
        IERC4626Minimal _strategy,
        uint256 _initialLTV,
        uint256 _LTVToRebalance,
        ChainlinkPriceFeedAggregator _pricesOracle,
        IAssetConverter _assetConverter
    ) {
        strategy = _strategy;
        initialLTV = _initialLTV;
        LTVToRebalance = _LTVToRebalance;

        pricesOracle = _pricesOracle;
        assetConverter = _assetConverter;

        require(initialLTV < LTVToRebalance, "Invalid configuration (LTV)");
        require(asset() == address(collateral), "Invalid configuration (collateral)");
        require(strategy.asset() == address(tokenToBorrow), "Invalid configuration (tokenToBorrow)");

        Utils.approveIfZeroAllowance(address(tokenToBorrow), address(strategy));
        Utils.approveIfZeroAllowance(address(collateral), address(assetConverter));
        Utils.approveIfZeroAllowance(address(tokenToBorrow), address(assetConverter));
    }

    function _totalAssets() internal view override returns (uint256 assets) {
        uint256 amountInUSD;
        BaseLendingStrategy.LendingPositionState memory lending = getLendingPositionState();
        amountInUSD += pricesOracle.convertToUSD(address(collateral), lending.collateral);
        amountInUSD += pricesOracle.convertToUSD(
            address(tokenToBorrow), strategy.convertToAssets(strategy.balanceOf(address(this)))
        );
        amountInUSD -= pricesOracle.convertToUSD(address(tokenToBorrow), lending.debt);

        assets = pricesOracle.convertFromUSD(amountInUSD, asset());
    }

    function _deposit(uint256 assets) internal override {
        uint256 ltv = _getCurrentLTV();
        if (ltv == 0) {
            ltv = initialLTV;
        }
        uint256 amountToBorrow = _getNeededDebt(assets, ltv);
        _supply(assets);
        _borrow(amountToBorrow);
        strategy.deposit(amountToBorrow, address(this));
    }

    function _redeem(uint256 shares) internal override returns (uint256 assets) {
        uint256 amountToRedeem = strategy.balanceOf(address(this)) * shares / totalSupply();
        uint256 debtToRepay = _getCurrentDebt() * shares / totalSupply();

        uint256 borrowTokenReceived = strategy.redeem(amountToRedeem, address(this), address(this));

        if (borrowTokenReceived >= debtToRepay) {
            assets = _repayAndWithdrawProportionally(debtToRepay);
            assets += assetConverter.safeSwap(address(tokenToBorrow), asset(), borrowTokenReceived - debtToRepay);
        } else {
            // Capture collateral and debt before
            uint256 collateralBefore = _getCurrentCollateral();
            uint256 debtBefore = _getCurrentDebt();

            // Repay with funds withdrawn from strategy
            _repay(borrowTokenReceived);
            // Repay rest via flashloaned funds
            _takeFlashloan(
                asset(), pricesOracle.convert(address(tokenToBorrow), asset(), debtToRepay - borrowTokenReceived), ""
            );

            // Capture collateral and debt after
            uint256 collateralAfter = _getCurrentCollateral();
            uint256 debtAfter = _getCurrentDebt();

            // We want to decrease collateral and debt proportionally
            uint256 targetCollateralAfter = debtAfter * collateralBefore / debtBefore;

            uint256 amountToWithdraw = collateralAfter - targetCollateralAfter;
            assets = amountToWithdraw;
            _withdraw(amountToWithdraw);
        }
    }

    function _insideFlashloan(address, uint256 _amount, uint256 _amountOwed, bytes memory) internal override {
        uint256 amountToRepay = assetConverter.safeSwap(asset(), address(tokenToBorrow), _amount);

        _repay(amountToRepay);
        _withdraw(_amountOwed);
    }

    function rebalance() public {
        uint256 ltv = _getCurrentLTV();

        if (ltv < LTVToRebalance) {
            revert LTVIsOK();
        }
        
        uint256 currentCollateral = _getCurrentCollateral();
        uint256 currentDebt = _getCurrentDebt();
        uint256 neededDebt = _getNeededDebt(currentCollateral, initialLTV);

        uint256 sharesToRedeem = strategy.convertToShares(currentDebt - neededDebt);

        _repay(strategy.redeem(sharesToRedeem, address(this), address(this)));
    }
}