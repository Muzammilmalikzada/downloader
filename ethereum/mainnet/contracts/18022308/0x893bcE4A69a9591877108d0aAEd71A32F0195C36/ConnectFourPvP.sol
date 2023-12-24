/**
    Connect Four PvP - Elevate your Connect Four experience with real-time PvP battles, wagers, and big wins!

    Website: https://connect.fourpvp.com/
    Telegram: https://t.me/ConnectFourPvP
    Twitter: https://twitter.com/ConnectFourPvP

**/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
// OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)

/* pragma solidity ^0.8.0; */

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
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

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
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

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
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

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
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
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    )
    external payable;
}

interface IUniswapV2Pair {
    function sync() external;
}

contract ConnectFourPvP is Context, IERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public routerUniswapV2;

    address public pairUniswapV2;
    bool public isTradingActive = false;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;

    uint256 private percentageFeeForLiquidity;
    uint256 private percentageFeeForRevenue;
    address public addressForLiquidityFee;
    address public addressForRevenueFee;

    string private constant _name = "Connect Four PvP";
    string private constant _symbol = "C4PVP";

    uint8 private constant _decimals = 9;

    uint256 private _tTotal = 1000000 * 10 ** _decimals;
    uint256 public _maxAmountPerWallet = 35000 * 10 ** _decimals;
    uint256 public _maxAmountPerTx = 35000 * 10 ** _decimals;
    uint256 public swapTokenThreshold = 10000 * 10 ** _decimals;
    uint256 public forceSwapCounter;

    struct BuyFeesConfig {
        uint256 liquidity;
        uint256 revenue;
    }

    struct SellFeesConfig {
        uint256 liquidity;
        uint256 revenue;
    }

    BuyFeesConfig public buyFeeSetup;
    SellFeesConfig public sellFeeSetup;

    bool private isInSwapFlag;

    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);

    constructor (address marketingAddress, address liquidityAddress) {
        addressForRevenueFee = marketingAddress;
        addressForLiquidityFee = liquidityAddress;
        balances[_msgSender()] = _tTotal;

        sellFeeSetup.liquidity = 2;
        sellFeeSetup.revenue = 1;
        buyFeeSetup.liquidity = 2;
        buyFeeSetup.revenue = 1;


        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

        routerUniswapV2 = _uniswapV2Router;
        pairUniswapV2 = _uniswapV2Pair;

        _isExcludedFromFee[msg.sender] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[address(0x00)] = true;
        _isExcludedFromFee[address(0xdead)] = true;


        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public pure returns (string memory) {return _name;}

    function symbol() public pure returns (string memory) {return _symbol;}

    function decimals() public pure returns (uint8) {return _decimals;}

    function totalSupply() public view override returns (uint256) {return _tTotal;}

    function balanceOf(address account) public view override returns (uint256) {return balances[account];}

    function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(_msgSender(), recipient, amount);
        return true;}

    function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}

    function approve(address spender, uint256 amount) public override returns (bool) {_approve(_msgSender(), spender, amount);
        return true;}

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
        return true;}

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;}

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
        return true;}

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFee[address(account)] = excluded;}

    function openTrading() external onlyOwner {
        isTradingActive = true;
    }

    receive() external payable {}

    function takeBuyFeeSetup(uint256 amount, address from) private returns (uint256) {
        uint256 liquidityFeeToken = amount * buyFeeSetup.liquidity / 100;
        uint256 marketingFeeTokens = amount * buyFeeSetup.revenue / 100;

        balances[address(this)] += liquidityFeeToken + marketingFeeTokens;
        emit Transfer(from, address(this), marketingFeeTokens + liquidityFeeToken);
        return (amount - liquidityFeeToken - marketingFeeTokens);
    }

    function takeSellFeeSetup(uint256 amount, address from) private returns (uint256) {
        uint256 liquidityFeeToken = amount * sellFeeSetup.liquidity / 100;
        uint256 marketingFeeTokens = amount * sellFeeSetup.revenue / 100;

        balances[address(this)] += liquidityFeeToken + marketingFeeTokens;
        emit Transfer(from, address(this), marketingFeeTokens + liquidityFeeToken);
        return (amount - liquidityFeeToken - marketingFeeTokens);
    }

    function updateMaxTxConfig(uint256 _maxTx, uint256 _maxWallet) public onlyOwner {
        require(_maxTx + _maxWallet > _tTotal / 1000, "Should be bigger than 0,1%");
        _maxAmountPerTx = _maxTx;
        _maxAmountPerWallet = _maxWallet;
    }

    function updateMaxAmountFee(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _sellMarketingFee, uint256 _sellLiquidityFee) public onlyOwner {
        require(_buyMarketingFee + _buyLiquidityFee < 500 || _sellLiquidityFee + _sellMarketingFee < 500, "Can't change fee higher than 49%");

        buyFeeSetup.liquidity = _buyLiquidityFee;
        buyFeeSetup.revenue = _buyMarketingFee;

        sellFeeSetup.liquidity = _sellLiquidityFee;
        sellFeeSetup.revenue = _sellMarketingFee;
    }


    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        balances[from] -= amount;
        uint256 transferAmount = amount;

        bool takeFee;

        if (!isTradingActive) {
            require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active.");
        }
        if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
            takeFee = true;
        }

        if (takeFee) {
            if (to != pairUniswapV2) {
                require(amount <= _maxAmountPerTx, "Transfer Amount exceeds the maxTxnsAmount");
                require(balanceOf(to) + amount <= _maxAmountPerWallet, "Transfer amount exceeds the maxWalletAmount.");
                transferAmount = takeBuyFeeSetup(amount, to);
            }

            if (from != pairUniswapV2) {
                require(amount <= _maxAmountPerTx, "Transfer Amount exceeds the maxTxnsAmount");
                transferAmount = takeSellFeeSetup(amount, from);
                forceSwapCounter += 1;

                if (balanceOf(address(this)) >= swapTokenThreshold && !isInSwapFlag) {
                    isInSwapFlag = true;
                    swapForFee(swapTokenThreshold);
                    isInSwapFlag = false;
                    forceSwapCounter = 0;
                }

                if (forceSwapCounter > 5 && !isInSwapFlag) {
                    isInSwapFlag = true;
                    swapForFee(balanceOf(address(this)));
                    isInSwapFlag = false;
                    forceSwapCounter = 0;
                }
            }

            if (to != pairUniswapV2 && from != pairUniswapV2) {
                require(amount <= _maxAmountPerTx, "Transfer Amount exceeds the maxTxnsAmount");
                require(balanceOf(to) + amount <= _maxAmountPerWallet, "Transfer amount exceeds the maxWalletAmount.");
            }
        }

        balances[to] += transferAmount;
        emit Transfer(from, to, transferAmount);
    }

    function swapForFee(uint256 amount) private {
        uint256 contractBalance = amount;
        uint256 liquidityTokens = contractBalance * (buyFeeSetup.liquidity + sellFeeSetup.liquidity) / (buyFeeSetup.revenue + buyFeeSetup.liquidity + sellFeeSetup.revenue + sellFeeSetup.liquidity);
        uint256 marketingTokens = contractBalance * (buyFeeSetup.revenue + sellFeeSetup.revenue) / (buyFeeSetup.revenue + buyFeeSetup.liquidity + sellFeeSetup.revenue + sellFeeSetup.liquidity);
        uint256 totalTokensToSwap = liquidityTokens + marketingTokens;

        uint256 tokensForLiquidity = liquidityTokens.div(2);
        uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
        uint256 initialETHBalance = address(this).balance;
        swapTokensForEth(amountToSwapForETH);
        uint256 ethBalance = address(this).balance.sub(initialETHBalance);

        uint256 ethForLiquidity = ethBalance.mul(liquidityTokens).div(totalTokensToSwap);
        addLiquidity(tokensForLiquidity, ethForLiquidity);
        payable(addressForRevenueFee).transfer(address(this).balance);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = routerUniswapV2.WETH();

        _approve(address(this), address(routerUniswapV2), tokenAmount);

        routerUniswapV2.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(routerUniswapV2), tokenAmount);

        routerUniswapV2.addLiquidityETH{value: ethAmount} (
            address(this),
            tokenAmount,
            0,
            0,
            addressForLiquidityFee,
            block.timestamp
        );
    }
}