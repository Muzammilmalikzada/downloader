// The rules are simple,

// Buy 1,100,000 or more tokens and become the Ponzi Leader
// Remaining leader for a total of 15 minutes without being disturbed and the prize pot will be yours.
// However, if someone else buys 11,000 or more tokens during your reign you will be removed as leader and a new one will be put in your place. Resetting the timer back to 15 minutes. 
//Thinking of swing trading? If you sell your tokens within 15 minutes of buying them you will be penalized with a double sell tax. With all the taxes going to the pot.

// Telegram - https://t.me/babyponzi
// Twitter - https://twitter.com/Baby_Ponzi
// Website - https://babyponzi.com/

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@%@@@@@@@@@@@@@@@@@
// @@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@&@@&@@@@@  @@@@@&@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@  @@&@@@@@/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@  @@@&@@@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@&@@@@@@@@@@@@@@&@&@@@  @@@@%@@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@&@@  @@@@@@@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@  @@@@@&@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@&@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@  @@%@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@&@@
// @@@@@@@@@  ........*&@@@@@@@@@@         ,%@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@@@@@@@@@@@@@   ,@@@@@@  #@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@&@
// @@@@@@@@@@@@@@@@@@@@@@@@  @@@@@  #@@@@@@@@@@@  #@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@@@@@@@@@@@@@@@@@  @@@@  #@@@@@@@&@@@@  @@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @#@@@@@@@@@@@@@@@@@@@@@@@  @@@@  #@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@@@@@@@@@@@@@@@,  @@@@@  #@@@@@@@@@@%  @@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@               @@@@@@@              @@@@@@@@@@@@@@&@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@  @@@@@@@@@@@@@   ,@@@  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@  @@@@@@@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@  @@  #@@#@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@  @@@@@@@@@@@@@@@@@  @  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@&@  @@@@@@@@@@@@@@@@@  @  #@@@@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@&@@@@@@  @@@@@@@@@@@@@@@.  @@  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@
// @@@@@@@@@  ..........      @@@@                   . ..... .... . ....  @@@@@@@@@
// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(@@@@&@@

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.15;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
 
    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}
 
interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
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

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    event Mint(address indexed sender, uint amount0, uint amount1);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);
    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;
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
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
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
 
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
 
        _beforeTokenTransfer(address(0), account, amount);
 
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
 
        _beforeTokenTransfer(account, address(0), amount);
 
        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
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
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
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
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
} 
library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);
    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;
        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }
    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256);
        return a / b;
    }
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }
    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    }
 
 
    function toUint256Safe(int256 a) internal pure returns (uint256) {
        require(a >= 0);
        return uint256(a);
    }
}
library SafeMathUint {
  function toInt256Safe(uint256 a) internal pure returns (int256) {
    int256 b = int256(a);
    require(b >= 0);
    return b;
  }
}
interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
 
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);
 
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
contract BABY is ERC20, Ownable {
        using SafeMath for uint256;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    bool private swapping;
    address private marketingWallet;
    address private devWallet;
    uint256 public buyTotalFees;
    uint256 public buyMarketingFee;
    uint256 public buyLiquidityFee;
    uint256 public buyDevFee;
    uint256 public sellTotalFees;
    uint256 public sellMarketingFee;
    uint256 public sellLiquidityFee;
    uint256 public sellDevFee;
    uint256 public tokensForMarketing;
    uint256 public tokensForLiquidity;
    uint256 public tokensForDev;
    uint256 public maxTransactionAmount;
    uint256 public swapTokensAtAmount;
    uint256 public maxWallet;
    bool public limitsInEffect = true;
    bool public tradingActive = false;
    bool public swapEnabled = false;
    mapping(address => uint256) private _holderLastTransferTimestamp;
    mapping(address => uint256) private _holderFirstBuyTimestamp;
    mapping(address => bool) private _blacklist;
    bool public transferDelayEnabled = false;

    uint256 launchedAt;	
 	mapping (address => bool) private _isExcludedFromFees;	
    mapping (address => bool) public _isExcludedMaxTransactionAmount;	
    mapping (address => bool) public automatedMarketMakerPairs;
    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
    event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
    event PonziCrowned(address indexed newPonzi, uint256 ponziTimerStart);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );
    event AutoNukeLP();
    event ManualNukeLP();
    uint256 public minPonziTokens;
    uint256 public ponziTimerDuration = 15 minutes;
    uint256 public ponziTimerStart;
    address public currentPonzi;
    bool public ponziTimerActive = false;
    event NewPonzi(address indexed ponzi, uint256 timestamp);
    event PonziRewarded(address indexed ponzi, uint256 amount, uint256 timestamp);
    uint256 private constant defaultPonziTimerDuration = 15 minutes;
    address private constant defaultCurrentPonzi = address(0);
    bool private constant defaultPonziTimerActive = false;
    bool public gameEnabled = true;
    event MinPonziTokensUpdated(uint256 newMinPonziTokens);

    constructor() ERC20("BabyPonzi", "BPONZI") {
 
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
 
        excludeFromMaxTransaction(address(_uniswapV2Router), true);
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        excludeFromMaxTransaction(address(uniswapV2Pair), true);
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
        currentPonzi = address(0);
 
        uint256 _buyMarketingFee = 2;
        uint256 _buyLiquidityFee = 3;
        uint256 _buyDevFee = 1;
 
        uint256 _sellMarketingFee = 2;
        uint256 _sellLiquidityFee = 3;
        uint256 _sellDevFee = 1;
 
 
        uint256 totalSupply = 1 * 1e9 * 1e18;
 
        maxTransactionAmount = totalSupply * 20 / 1000; // 1.5% maxTransactionAmountTxn
        maxWallet = totalSupply * 20 / 1000; // 1.5% maxWallet
        swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
 
        buyMarketingFee = _buyMarketingFee;
        buyLiquidityFee = _buyLiquidityFee;
        buyDevFee = _buyDevFee;
        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
 
        sellMarketingFee = _sellMarketingFee;
        sellLiquidityFee = _sellLiquidityFee;
        sellDevFee = _sellDevFee;
        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
 
        minPonziTokens = totalSupply * 11 / 10000; // 0.1% of the supply   
        marketingWallet = address(owner());
        devWallet = address(owner()); 
        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);
        excludeFromMaxTransaction(owner(), true);
        excludeFromMaxTransaction(address(this), true);
        excludeFromMaxTransaction(address(0xdead), true);
        _mint(msg.sender, totalSupply);
    }
 
    receive() external payable {
 
    }

    function claimPonziReward() private {
        require(ponziTimerActive, "No ponzi has been crowned yet.");
        require(currentPonzi == _msgSender(), "You are not the current ponzi.");
        require(block.timestamp >= ponziTimerStart + ponziTimerDuration, "The ponzi's reign is not over yet.");
        uint256 rewardAmount = address(this).balance; // Changed from token balance to Ether balance
        payable(currentPonzi).transfer(rewardAmount); // Changed from _transfer to Ether transfer
        emit PonziRewarded(currentPonzi, rewardAmount, block.timestamp);

        // Reset the ponzi timer and current ponzi
        ponziTimerActive = false;
        currentPonzi = address(0);
    }
    function claimReward() public {
        require(gameEnabled, "The game is currently disabled.");
        require(ponziTimerActive, "No ponzi has been crowned yet.");
        require(currentPonzi == _msgSender(), "You are not the current ponzi.");
        require(block.timestamp >= ponziTimerStart + ponziTimerDuration, "The ponzi's reign is not over yet.");

        claimPonziReward();
    }
    function crownNewPonzi(address newPonzi) private {
        require(newPonzi != address(0), "New ponzi address cannot be zero.");
        currentPonzi = newPonzi;
        ponziTimerStart = block.timestamp;
        ponziTimerActive = true;
        emit PonziCrowned(newPonzi, ponziTimerStart);
    }

    function updatePonzi(address to, uint256 amount) internal {
    require(gameEnabled, "The game is currently disabled.");

    if (getRemainingPonziTime() > 0) {
        if (amount >= totalSupply().mul(1).div(1000) && !automatedMarketMakerPairs[to]) {
            crownNewPonzi(to);
            ponziTimerActive = true;
            ponziTimerStart = block.timestamp;
        }
    } else {

        if (ponziTimerActive) {

            uint256 rewardAmount = address(this).balance;
            payable(currentPonzi).transfer(rewardAmount);
            emit PonziRewarded(currentPonzi, rewardAmount, block.timestamp);


            ponziTimerActive = false;
            currentPonzi = address(0);
        }
        
        if (amount >= totalSupply().mul(1).div(1000) && !automatedMarketMakerPairs[to]) {
            crownNewPonzi(to);
            ponziTimerActive = true;
            ponziTimerStart = block.timestamp;
        }
    }
}
    function getRemainingPonziTime() public view returns (uint256) {
        if (!ponziTimerActive) {
            return 0;
        }
        uint256 elapsedTime = block.timestamp - ponziTimerStart;
        if (elapsedTime >= ponziTimerDuration) {
            return 0;
        }
        return ponziTimerDuration - elapsedTime;
    }
    function resetGame() public onlyOwner {
        ponziTimerDuration = defaultPonziTimerDuration;
        currentPonzi = defaultCurrentPonzi;
        ponziTimerActive = defaultPonziTimerActive;
    }

    function updateMinPonziTokens(uint256 newMinPonziTokens) public onlyOwner {
            minPonziTokens = newMinPonziTokens; // Convert to smallest unit
            emit MinPonziTokensUpdated(minPonziTokens);
        }

    function togglePonziState() external onlyOwner {
        gameEnabled = !gameEnabled;
    }

    function enableTrading() external onlyOwner {
        tradingActive = true;
        swapEnabled = true;
        launchedAt = block.number;
    }

    function removeLimits() external onlyOwner returns (bool){
        limitsInEffect = false;
        return true;
    }

    function disableTransferDelay() external onlyOwner returns (bool){
        transferDelayEnabled = false;
        return true;
    }

    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
        swapTokensAtAmount = newAmount;
        return true;
    }
    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
        require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
        maxTransactionAmount = newNum * (10**18);
    }
    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
        require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
        maxWallet = newNum * (10**18);
    }
 
    function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
        _isExcludedMaxTransactionAmount[updAds] = isEx;
    }
    function updateSwapEnabled(bool enabled) external onlyOwner(){
        swapEnabled = enabled;
    }
    function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
        buyMarketingFee = _marketingFee;
        buyLiquidityFee = _liquidityFee;
        buyDevFee = _devFee;
        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
    }

    function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
        sellMarketingFee = _marketingFee;
        sellLiquidityFee = _liquidityFee;
        sellDevFee = _devFee;
        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
    }
    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }
    function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
        _blacklist[account] = isBlacklisted;
    }
    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
        require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
 
        _setAutomatedMarketMakerPair(pair, value);
    }
    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
 
        emit SetAutomatedMarketMakerPair(pair, value);
    }
    function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
        emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
        marketingWallet = newMarketingWallet;
    }
    function updateDevWallet(address newWallet) external onlyOwner {
        emit devWalletUpdated(newWallet, devWallet);
        devWallet = newWallet;
    }
    function isExcludedFromFees(address account) public view returns(bool) {
        return _isExcludedFromFees[account];
    }
    event BoughtEarly(address indexed sniper);
    event Debug(string message, address addr);

function _transfer(
    address from,
    address to,
    uint256 amount
) internal override {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");
    
    if(amount == 0) {
        super._transfer(from, to, 0);
        return;
    }

    emit Debug("Before require statements", from);
    if(limitsInEffect){
        if (
            from != owner() &&
            to != owner() &&
            to != address(0) &&
            to != address(0xdead) &&
            !swapping
        ){
            if(!tradingActive){
                require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
            }

            //when buy
            if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
                require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
                require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
            }

            //when sell
            else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
                require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
            }
            else if(!_isExcludedMaxTransactionAmount[to]){
                require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
            }
        }
    } 
 
        uint256 contractTokenBalance = balanceOf(address(this));
 
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;
 
        if( 
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
        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }
 
        uint256 fees = 0;
        // only take fees on buys/sells, do not take on wallet transfers
        if(takeFee){
            // on sell
            if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
                fees = amount.mul(sellTotalFees).div(100);
                tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
                tokensForDev += fees * sellDevFee / sellTotalFees;
                tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
            }
            // on buy
            else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
                fees = amount.mul(buyTotalFees).div(100);
                tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
                tokensForDev += fees * buyDevFee / buyTotalFees;
                tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
            }
 
            if(fees > 0){    
                super._transfer(from, address(this), fees);
            }
 
            amount -= fees;
        }
  if (gameEnabled && automatedMarketMakerPairs[from]) {
        updatePonzi(to, amount);
    }
    super._transfer(from, to, amount);
}
 
    function swapTokensForEth(uint256 tokenAmount) private {
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
            address(this),
            block.timestamp
        );
    }
 
    function swapBack() private {
    uint256 contractBalance = balanceOf(address(this));
    uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
    bool success;

    if(contractBalance == 0 || totalTokensToSwap == 0) {return;}

    if(contractBalance > swapTokensAtAmount * 20){
        contractBalance = swapTokensAtAmount * 20;
    }

    uint256 initialETHBalance = address(this).balance;
    uint256 ethToSwap = tokensForMarketing + tokensForDev;
    uint256 newCommunityPot = ethToSwap * buyMarketingFee / buyTotalFees;
    ethToSwap -= newCommunityPot;
    swapTokensForEth(contractBalance);

    uint256 ethBalance = address(this).balance.sub(initialETHBalance);

    uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
    uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);

    tokensForLiquidity = 0;
    tokensForMarketing = 0;
    tokensForDev = 0;

    (success,) = address(devWallet).call{value: ethForDev}("");
    (success,) = address(marketingWallet).call{value: ethForMarketing}("");

}
}