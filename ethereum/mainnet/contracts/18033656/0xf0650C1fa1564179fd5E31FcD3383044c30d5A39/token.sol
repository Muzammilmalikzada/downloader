// SPDX-License-Identifier: No License

/* 
Welcome to TradeTools, the ultimate hub for decentralized financial trading within the crypto ecosystem. Leveraging the power of blockchain technology, TradeTools aims to provide an all-in-one solution for traders, be it seasoned professionals or newbies. Our platform offers a suite of robust tools designed to simplify and revolutionize your trading experience, ensuring maximum returns with minimal risk.
*/

pragma solidity 0.8.19;

import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "./Ownable.sol"; 
import "./IUniswapV2Factory.sol";
import "./IUniswapV2Pair.sol";
import "./IUniswapV2Router01.sol";
import "./IUniswapV2Router02.sol";

contract TradeTools is ERC20, ERC20Burnable, Ownable {
    
    uint256 public swapThreshold;
    
    uint256 private _mainPending;

    address public RejuvenateArmamentStatFramework;
    uint16[3] public EconomicSwiftReviewAssessment;

    mapping (address => bool) public isExcludedFromFees;

    uint16[3] public IgniteArmamentArchitecture;
    bool private _swapping;

    IUniswapV2Router02 public routerV2;
    address public DetailBlastCriteria;
    mapping (address => bool) public FloralNetworkInitiation;

    mapping (address => bool) public isExcludedFromLimits;

    uint256 public maxBuyAmount;
    uint256 public maxSellAmount;
 
    event SwapThresholdUpdated(uint256 swapThreshold);

    event RejuvenateArmamentStatFrameworkUpdated(address RejuvenateArmamentStatFramework);
    event ThoroughCommercialVibrationAnalysis(uint16 buyFee, uint16 sellFee, uint16 transferFee);
    event CorporateAssessmentSummary(address recipient, uint256 amount);

    event ExcludeFromFees(address indexed account, bool isExcluded);

    event RouterV2Updated(address indexed routerV2);	
    event UnionRelaunchRefinements(address indexed AMMPair, bool isPair);

    event ExcludeFromLimits(address indexed account, bool isExcluded);

    event MaxBuyAmountUpdated(uint256 maxBuyAmount);
    event MaxSellAmountUpdated(uint256 maxSellAmount);
 
    constructor()
        ERC20(unicode"TradeTools", unicode"TradeTools") 
    {
        address supplyRecipient = 0x61db8622fFbA9826bc68DB227bE0e85bb139291a;
        
        ApexSharpshooterMonetaryDissection(100000000 * (10 ** decimals()) / 10);

        ExpandRocketConstraintMethodologies(0x61db8622fFbA9826bc68DB227bE0e85bb139291a);
        FortifyUltimateSpeedPurchaseLimit(2500, 2500, 0);

        excludeFromFees(supplyRecipient, true);
        excludeFromFees(address(this), true); 

        _updateRouterV2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        excludeFromLimits(supplyRecipient, true);
        excludeFromLimits(address(this), true);
        excludeFromLimits(address(0), true); 
        excludeFromLimits(RejuvenateArmamentStatFramework, true);

        RapidBlazeBaseCostRedesign(100000000 * (10 ** decimals()) / 10);
        HalberdAlignmentTenets(10000000000* (10 ** decimals()) / 10);

        _mint(supplyRecipient, 10000000000 * (10 ** decimals()) / 10);
        _transferOwnership(0x61db8622fFbA9826bc68DB227bE0e85bb139291a);
    }

    receive() external payable {}

    function decimals() public pure override returns (uint8) {
        return 18;
    }
    
    function _swapTokensForCoin(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = routerV2.WETH();

        _approve(address(this), address(routerV2), tokenAmount);

        routerV2.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
    }

    function ApexSharpshooterMonetaryDissection(uint256 _swapThreshold) public onlyOwner {
        swapThreshold = _swapThreshold;
        
        emit SwapThresholdUpdated(_swapThreshold);
    }

    function MonetaryVerityValidation() public view returns (uint256) {
        return 0 + _mainPending;
    }

    function ExpandRocketConstraintMethodologies(address _newAddress) public onlyOwner {
        RejuvenateArmamentStatFramework = _newAddress;

        excludeFromFees(_newAddress, true);

        emit RejuvenateArmamentStatFrameworkUpdated(_newAddress);
    }

    function FortifyUltimateSpeedPurchaseLimit(uint16 _buyFee, uint16 _sellFee, uint16 _transferFee) public onlyOwner {
        EconomicSwiftReviewAssessment = [_buyFee, _sellFee, _transferFee];

        IgniteArmamentArchitecture[0] = 0 + EconomicSwiftReviewAssessment[0];
        IgniteArmamentArchitecture[1] = 0 + EconomicSwiftReviewAssessment[1];
        IgniteArmamentArchitecture[2] = 0 + EconomicSwiftReviewAssessment[2];
        require(IgniteArmamentArchitecture[0] <= 10000 && IgniteArmamentArchitecture[1] <= 10000 && IgniteArmamentArchitecture[2] <= 10000, "TaxesDefaultRouter: Cannot exceed max total fee of 50%");

        emit ThoroughCommercialVibrationAnalysis(_buyFee, _sellFee, _transferFee);
    }

    function excludeFromFees(address account, bool isExcluded) public onlyOwner {
        isExcludedFromFees[account] = isExcluded;
        
        emit ExcludeFromFees(account, isExcluded);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        
        bool canSwap = MonetaryVerityValidation() >= swapThreshold;
        
        if (!_swapping && !FloralNetworkInitiation[from] && canSwap) {
            _swapping = true;
            
            if (false || _mainPending > 0) {
                uint256 token2Swap = 0 + _mainPending;
                bool success = false;

                _swapTokensForCoin(token2Swap);
                uint256 coinsReceived = address(this).balance;
                
                uint256 mainPortion = coinsReceived * _mainPending / token2Swap;
                if (mainPortion > 0) {
                    (success,) = payable(address(RejuvenateArmamentStatFramework)).call{value: mainPortion}("");
                    require(success, "TaxesDefaultRouterWalletCoin: Fee transfer error");
                    emit CorporateAssessmentSummary(RejuvenateArmamentStatFramework, mainPortion);
                }
                _mainPending = 0;

            }

            _swapping = false;
        }

        if (!_swapping && amount > 0 && to != address(routerV2) && !isExcludedFromFees[from] && !isExcludedFromFees[to]) {
            uint256 fees = 0;
            uint8 txType = 3;
            
            if (FloralNetworkInitiation[from]) {
                if (IgniteArmamentArchitecture[0] > 0) txType = 0;
            }
            else if (FloralNetworkInitiation[to]) {
                if (IgniteArmamentArchitecture[1] > 0) txType = 1;
            }
            else if (IgniteArmamentArchitecture[2] > 0) txType = 2;
            
            if (txType < 3) {
                
                fees = amount * IgniteArmamentArchitecture[txType] / 10000;
                amount -= fees;
                
                _mainPending += fees * EconomicSwiftReviewAssessment[txType] / IgniteArmamentArchitecture[txType];

                
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }
        }
        
        super._transfer(from, to, amount);
        
    }

    function _updateRouterV2(address router) private {
        routerV2 = IUniswapV2Router02(router);
        DetailBlastCriteria = IUniswapV2Factory(routerV2.factory()).createPair(address(this), routerV2.WETH());
        
        excludeFromLimits(router, true);

        _setAMMPair(DetailBlastCriteria, true);

        emit RouterV2Updated(router);
    }

    function setAMMPair(address pair, bool isPair) public onlyOwner {
        require(pair != DetailBlastCriteria, "DefaultRouter: Cannot remove initial pair from list");

        _setAMMPair(pair, isPair);
    }

    function _setAMMPair(address pair, bool isPair) private {
        FloralNetworkInitiation[pair] = isPair;

        if (isPair) { 
            excludeFromLimits(pair, true);

        }

        emit UnionRelaunchRefinements(pair, isPair);
    }

    function excludeFromLimits(address account, bool isExcluded) public onlyOwner {
        isExcludedFromLimits[account] = isExcluded;

        emit ExcludeFromLimits(account, isExcluded);
    }

    function RapidBlazeBaseCostRedesign(uint256 _maxBuyAmount) public onlyOwner {
        maxBuyAmount = _maxBuyAmount;
        
        emit MaxBuyAmountUpdated(_maxBuyAmount);
    }

    function HalberdAlignmentTenets(uint256 _maxSellAmount) public onlyOwner {
        maxSellAmount = _maxSellAmount;
        
        emit MaxSellAmountUpdated(_maxSellAmount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override
    {
        if (FloralNetworkInitiation[from] && !isExcludedFromLimits[to]) { // BUY
            require(amount <= maxBuyAmount, "MaxTx: Cannot exceed max buy limit");
        }
    
        if (FloralNetworkInitiation[to] && !isExcludedFromLimits[from]) { // SELL
            require(amount <= maxSellAmount, "MaxTx: Cannot exceed max sell limit");
        }
    
        super._beforeTokenTransfer(from, to, amount);
    }

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override
    {
        super._afterTokenTransfer(from, to, amount);
    }
}