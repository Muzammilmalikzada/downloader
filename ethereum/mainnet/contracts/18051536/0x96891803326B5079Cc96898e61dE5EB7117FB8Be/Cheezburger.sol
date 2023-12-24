/**
 /**
     CheezBurgerToken
**/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
pragma experimental ABIEncoderV2;

// ================
//     IMPORTS
// ================
import "./Context.sol";
import "./Ownable.sol";
import "./IERC20.sol";
import "./IERC20Metadata.sol";
import "./ERC20Burnable.sol";
import "./ERC20.sol";
import "./SafeMath.sol";
import "./IUniswapV2Factory.sol";
import "./IUniswapV2Pair.sol";
import "./IUniswapV2Router02.sol";

contract CheezBurgerToken is ERC20Burnable, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    address public constant deadAddress = address(0xdead);

    bool private swapping;

    address public teamWallet;
    address public operationalWallet;

    uint256 public maxTransactionAmount;
    uint256 public swapTokensAtAmount;
    uint256 public maxWallet;

    bool public limitsInEffect = true;
    bool public tradingActive = false;
    bool public swapEnabled = false;

    bool public blacklistRenounced = false;
    

    // Anti-bot and anti-whale mappings and variables
    mapping(address => bool) blacklisted;

    uint256 public buyTotalFees;
    uint256 public buyTeamFee;
    uint256 public buyLiquidityFee;
    uint256 public buyOperationalFee;

    uint256 public sellTotalFees;
    uint256 public sellTeamFee;
    uint256 public sellLiquidityFee;
    uint256 public sellOperationalFee;

    uint256 public tokensForTeam;
    uint256 public tokensForLiquidity;
    uint256 public tokensForOperations;

    /******************/

    // exclude from fees and max transaction amount
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) public _isExcludedMaxTransactionAmount;

    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
    // could be subject to a maximum transfer amount
    mapping(address => bool) public automatedMarketMakerPairs;

    event UpdateUniswapV2Router(
        address indexed newAddress,
        address indexed oldAddress
    );

    event ExcludeFromFees(address indexed account, bool isExcluded);

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    event teamWalletUpdated(
        address indexed newWallet,
        address indexed oldWallet
    );

    event operationalWalletUpdated(
        address indexed newWallet,
        address indexed oldWallet
    );

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );

    constructor(address _teamWallet, address _v2Router) ERC20("CheezBurgerToken", "$CZBR") {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            _v2Router
        );

        excludeFromMaxTransaction(address(_uniswapV2Router), true);
        uniswapV2Router = _uniswapV2Router;

        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        excludeFromMaxTransaction(address(uniswapV2Pair), true);
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

        // 3%
        uint256 _buyTeamFee = 10; //1%
        uint256 _buyLiquidityFee = 10; //1%
        uint256 _buyOperationalFee = 10; //1%

        // 5%
        uint256 _sellTeamFee = 30; //3%
        uint256 _sellLiquidityFee = 10; //1%
        uint256 _sellOperationalFee= 10; // 1%
        
        uint256 totalSupply =  100_000_000_000 * 1e18; //100 billion

        maxTransactionAmount = (totalSupply / 100) * 1e18; // 1%
        maxWallet = (totalSupply / 100) * 1e18; // 1%
        swapTokensAtAmount = (totalSupply * 5) / 10_000; // 0.05% //50_000_000

        //set buy fees
        buyTeamFee = _buyTeamFee;
        buyLiquidityFee = _buyLiquidityFee;
        buyOperationalFee = _buyOperationalFee;
        buyTotalFees = buyTeamFee + buyLiquidityFee + buyOperationalFee;

        //set sell fees
        sellTeamFee = _sellTeamFee;
        sellLiquidityFee = _sellLiquidityFee;
        sellOperationalFee = _sellOperationalFee;
        sellTotalFees = sellTeamFee + sellLiquidityFee + sellOperationalFee;

        teamWallet = _teamWallet; 
        operationalWallet = 0xAb98C50f3fFC335B755b1C4C8B0FE41317ab2996;

        // exclude from paying fees or having max transaction amount
        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);

        excludeFromMaxTransaction(owner(), true);
        excludeFromMaxTransaction(address(this), true);
        excludeFromMaxTransaction(address(0xdead), true);

        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        _mint(msg.sender, totalSupply);
    }

    receive() external payable {}

    
    function enableTrading() external onlyOwner {
        tradingActive = true;
        swapEnabled = true;
    }
   
    function disableTrading() external onlyOwner {
        tradingActive = false;
        swapEnabled = false;
    }
    // remove limits after token is stable
    function removeLimits() external onlyOwner returns (bool) {
        limitsInEffect = false;
        return true;
    }

    // change the minimum amount of tokens to sell from fees
    function updateSwapTokensAtAmount(
        uint256 newAmount
    ) external onlyOwner returns (bool) {
        require(
            newAmount >= (totalSupply() * 1) / 100000,
            "Swap amount cannot be lower than 0.001% total supply."
        );
        require(
            newAmount <= (totalSupply() * 5) / 1000,
            "Swap amount cannot be higher than 0.5% total supply."
        );
        swapTokensAtAmount = newAmount;
        return true;
    }

    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
        require(
            newNum >= ((totalSupply() * 5) / 1000) / 1e18,
            "Cannot set maxTransactionAmount lower than 0.5%"
        );
        maxTransactionAmount = newNum * (10 ** 18);
    }

    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
        require(
            newNum >= ((totalSupply() * 10) / 1000) / 1e18,
            "Cannot set maxWallet lower than 1.0%"
        );
        maxWallet = newNum * (10 ** 18);
    }

    function excludeFromMaxTransaction(
        address updAds,
        bool isEx
    ) public onlyOwner {
        _isExcludedMaxTransactionAmount[updAds] = isEx;
    }

    // only use to disable contract sales if absolutely necessary (emergency use only)
    function updateSwapEnabled(bool enabled) external onlyOwner {
        swapEnabled = enabled;
    }

    function updateBuyFees(
        uint256 _buyTeamFee,
        uint256 _buyLiquidityFee,
        uint256 _buyOperationalFee
    ) external onlyOwner {
        buyTeamFee = _buyTeamFee;
        buyLiquidityFee = _buyLiquidityFee;
        buyOperationalFee = _buyOperationalFee;
        buyTotalFees = buyTeamFee + buyLiquidityFee + buyOperationalFee;
        require(buyTotalFees <= 50, "Buy fees must be <= 5%");
    }

    function updateSellFees(
        uint256 _sellTeamFee,
        uint256 _sellLiquidityFee,
        uint256 _sellOperationalFee
    ) external onlyOwner {
        sellTeamFee = _sellTeamFee;
        sellLiquidityFee = _sellLiquidityFee;
        sellOperationalFee = _sellOperationalFee;
        sellTotalFees = sellTeamFee + sellLiquidityFee + sellOperationalFee;
        require(sellTotalFees <= 100, "Sell fees must be <= 10%");
    }


    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function setAutomatedMarketMakerPair(
        address pair,
        bool value
    ) public onlyOwner {
        require(
            pair != uniswapV2Pair,
            "The pair cannot be removed from automatedMarketMakerPairs"
        );

        _setAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;

        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function updateTeamWallet(
        address newTeamWallet
    ) external onlyOwner {
        emit teamWalletUpdated(newTeamWallet, teamWallet);
        teamWallet = newTeamWallet;
    }

    function updateOperationalWallet(address newWallet) external onlyOwner {
        emit operationalWalletUpdated(newWallet, operationalWallet);
        operationalWallet = newWallet;
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function isBlacklisted(address account) public view returns (bool) {
        return blacklisted[account];
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(!blacklisted[from], "Sender blacklisted");
        require(!blacklisted[to], "Receiver blacklisted");


        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (limitsInEffect) {
            if (
                from != owner() &&
                to != owner() &&
                to != address(0) &&
                to != address(0xdead) &&
                !swapping
            ) {
                if (!tradingActive) {
                    require(
                        _isExcludedFromFees[from] || _isExcludedFromFees[to],
                        "Trading is not active."
                    );
                }

                //when buy
                if (
                    automatedMarketMakerPairs[from] &&
                    !_isExcludedMaxTransactionAmount[to]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "Buy transfer amount exceeds the maxTransactionAmount."
                    );
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "Max wallet exceeded"
                    );
                }
                //when sell
                else if (
                    automatedMarketMakerPairs[to] &&
                    !_isExcludedMaxTransactionAmount[from]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "Sell transfer amount exceeds the maxTransactionAmount."
                    );
                } else if (!_isExcludedMaxTransactionAmount[to]) {
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "Max wallet exceeded"
                    );
                }
            }
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;
       
        if (
            canSwap &&
            swapEnabled &&
            !swapping &&
            !automatedMarketMakerPairs[from] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            swapping = true;

            swapBack();

            swapping = false;
        }

        bool takeFee = !swapping;

        // if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        // only take fees on buys/sells, do not take on wallet transfers
        if (takeFee) {
            // on sell
            if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
                fees = amount.mul(sellTotalFees).div(1000);
                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
                tokensForOperations += (fees * sellOperationalFee) / sellTotalFees;
                tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
            }
            // on buy
            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
                fees = amount.mul(buyTotalFees).div(1000);
                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
                tokensForOperations += (fees * buyOperationalFee) / buyTotalFees;
                tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        uint256 totalTokensToSwap = tokensForLiquidity +
            tokensForTeam +
            tokensForOperations;
        bool success;

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            return;
        }

        if (contractBalance > swapTokensAtAmount * 20) {
            contractBalance = swapTokensAtAmount * 20;
        }

        // Halve the amount of liquidity tokens
        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
            totalTokensToSwap /
            2;
        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);

        uint256 initialETHBalance = address(this).balance;

        swapTokensForEth(amountToSwapForETH);

        uint256 ethBalance = address(this).balance.sub(initialETHBalance);

        uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(
            totalTokensToSwap - (tokensForLiquidity / 2)
        );

        uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(
            totalTokensToSwap - (tokensForLiquidity / 2)
        );

        uint256 ethForLiquidity = ethBalance - ethForTeam - ethForOperations;


        tokensForLiquidity = 0;
        tokensForTeam = 0;
        tokensForOperations = 0;

        (success, ) = address(operationalWallet).call{value: ethForOperations}("");

        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            addLiquidity(liquidityTokens, ethForLiquidity);
            emit SwapAndLiquify(
                amountToSwapForETH,
                ethForLiquidity,
                tokensForLiquidity
            );
        }
        (success, ) = address(teamWallet).call{
            value: address(this).balance
        }("");

        
    }

    function withdrawStuckCheezBurger() external onlyOwner {
        uint256 balance = IERC20(address(this)).balanceOf(address(this));
        IERC20(address(this)).transfer(msg.sender, balance);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawStuckToken(
        address _token,
        address _to
    ) external onlyOwner {
        require(_token != address(0), "_token address cannot be 0");
        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(_to, _contractBalance);
    }

    function withdrawStuckEth(address toAddr) external onlyOwner {
        (bool success, ) = toAddr.call{value: address(this).balance}("");
        require(success);
    }

    // @dev team renounce blacklist commands
    function renounceBlacklist() public onlyOwner {
        blacklistRenounced = true;
    }

    function blacklist(address _addr) public onlyOwner {
        require(!blacklistRenounced, "Team has revoked blacklist rights");
        require(
            _addr != address(uniswapV2Pair) &&
                _addr != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D),
            "Cannot blacklist token's v2 router or v2 pool."
        );
        blacklisted[_addr] = true;
    }

    // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
    function blacklistLiquidityPool(address lpAddress) public onlyOwner {
        require(!blacklistRenounced, "Team has revoked blacklist rights");
        require(
            lpAddress != address(uniswapV2Pair) &&
                lpAddress !=
                address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D),
            "Cannot blacklist token's v2 router or v2 pool."
        );
        blacklisted[lpAddress] = true;
    }

    // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
    function unblacklist(address _addr) public onlyOwner {
        blacklisted[_addr] = false;
    }
}