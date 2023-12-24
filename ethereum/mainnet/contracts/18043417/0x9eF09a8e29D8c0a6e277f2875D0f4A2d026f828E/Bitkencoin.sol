// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./IUniswapV2Router02.sol";
import "./IUniswapV2Factory.sol";

/**
 * @title Bitken Coin (BITKEN)
 * @dev The main Bitken Coin smart contract.
 * Website: https://www.bitkencoin.com
 * Twitter(X): https://twitter.com/TheApesKing
 * Telegram: https://t.me/Bitkencoin
 */
                                                                              
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

contract BitkenCoin is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _bots;
    bool public transferDelayEnabled = true;
    address payable private _burnWallet;

    uint8 private constant _decimals = 9;
    uint256 private _totalSupply = 1000000000 * 10**uint256(_decimals);
    string private constant _name = "Bitken Coin";
    string private constant _symbol = "BITKEN";
    uint256 private _maxTxAmount = _totalSupply * 2 / 100; // 2% of total supply
    uint256 private _taxBurnThreshold = _totalSupply * 1 / 100; // 1% of total supply

    uint256 private _burnStartTime;
    uint256 private _burnInterval = 1 days;
    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;

    event MaxTxAmountUpdated(uint256 _maxTxAmount);
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() {
    uint256 initialSupply = 1000000000 * 10**uint256(_decimals); 
    _totalSupply = initialSupply;
    _burnWallet = payable(0x000000000000000000000000000000000000dEaD);
    _balances[_msgSender()] = initialSupply;
    _isExcludedFromFee[owner()] = true;
    _isExcludedFromFee[address(this)] = true;
    _isExcludedFromFee[_burnWallet] = true;
    _burnStartTime = block.timestamp;
    emit Transfer(address(0), _msgSender(), initialSupply);
}

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        uint256 burnAmount = 0;

        // Calculate burn amount if the burn interval has passed
        if (block.timestamp >= _burnStartTime.add(_burnInterval)) {
            burnAmount = _totalSupply * 1 / 100; // 1% of total supply
            _burnStartTime = block.timestamp;
            _totalSupply = _totalSupply.sub(burnAmount);
            _balances[_burnWallet] = _balances[_burnWallet].add(burnAmount);
            emit Transfer(address(0), _burnWallet, burnAmount);
        }

        uint256 transferAmount = amount;

        if (from != owner() && to != owner()) {
            require(!_bots[from] && !_bots[to]);
            require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");

            if (transferDelayEnabled) {
                if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
                    require(
                        _balances[tx.origin] < _maxTxAmount,
                        "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
                    );
                }
            }

            if (to == uniswapV2Pair) {
                // Selling
                // Set transferAmount to 99% of the original amount
                transferAmount = amount.mul(99).div(100);
            }
        }

        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(transferAmount);

        emit Transfer(from, to, transferAmount);
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function openTrading() external onlyOwner() {
        require(!tradingOpen, "Trading is already open");
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapV2Router), _totalSupply);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        swapEnabled = true;
        tradingOpen = true;
    }

    function removeLimits() external onlyOwner {
        _maxTxAmount = _totalSupply;
        transferDelayEnabled = false;
        emit MaxTxAmountUpdated(_totalSupply);
    }

    function setBots(address[] memory bots_) public onlyOwner {
        for (uint256 i = 0; i < bots_.length; i++) {
            _bots[bots_[i]] = true;
        }
    }

    function removeBots(address[] memory notBot) public onlyOwner {
        for (uint256 i = 0; i < notBot.length; i++) {
            _bots[notBot[i]] = false;
        }
    }

    function isBot(address a) public view returns (bool) {
        return _bots[a];
    }

    receive() external payable {}

    function manualSwap() external {
        require(_msgSender() == _burnWallet);
        uint256 tokenBalance = balanceOf(address(this));
        if (tokenBalance > 0) {
            swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            payable(_msgSender()).transfer(ethBalance);
        }
    }
}
