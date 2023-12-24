// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IDebtController {
    /// @dev Computes the maximum interest
    /// @param _tokenAddress the token address
    /// @param _principal the principal borrowed
    /// @param _lastFundingTimestamp the timestamp where the loan was last funded
    /// @return maxInterest the maximum interest amount to pay for the loan
    function computeMaxInterest(
        address _tokenAddress,
        uint256 _principal,
        uint256 _lastFundingTimestamp
    ) external view returns(uint256 maxInterest);

    /// @dev Computes the maximum principal
    /// @param _collateralToken the collateral token address
    /// @param _principalToken the principal token address
    /// @param _downPayment the down payment the trader is paying
    /// @return maxPrincipal the maximum principal allowed to be borrowed
    function computeMaxPrincipal(
        address _collateralToken,
        address _principalToken,
        uint256 _downPayment
    ) external view returns (uint256 maxPrincipal);

    // function computeLiquidationThreshold(
    //     address _collateralToken,
    //     address _principalToken,
    //     uint256 _collateralAmount
    // ) external view returns (uint256 liquidationThreshold);
}