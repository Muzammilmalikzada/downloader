// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ParaSwapDebtSwapAdapter.sol";
import "./IPoolAddressesProvider.sol";
import "./IParaSwapAugustusRegistry.sol";
import "./AaveV2.sol";

/**
 * @title ParaSwapDebtSwapAdapter
 * @notice ParaSwap Adapter to perform a swap of debt to another debt.
 * @author BGD labs
 **/
contract ParaSwapDebtSwapAdapterV2 is ParaSwapDebtSwapAdapter {
  constructor(
    IPoolAddressesProvider addressesProvider,
    address pool,
    IParaSwapAugustusRegistry augustusRegistry,
    address owner
  ) ParaSwapDebtSwapAdapter(addressesProvider, pool, augustusRegistry, owner) {}

  function _getReserveData(address asset) internal view override returns (address, address, address) {
    DataTypes.ReserveData memory reserveData = ILendingPool(address(POOL)).getReserveData(asset);
    return (
      reserveData.variableDebtTokenAddress,
      reserveData.stableDebtTokenAddress,
      reserveData.aTokenAddress
    );
  }

  function _supply(
    address asset,
    uint256 amount,
    address to,
    uint16 referralCode
  ) internal override {
    ILendingPool(address(POOL)).deposit(asset, amount, to, referralCode);
  }
}
