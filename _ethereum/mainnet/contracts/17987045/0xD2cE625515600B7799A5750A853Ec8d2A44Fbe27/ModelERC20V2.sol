// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./console.sol";

// Telegram Chat: https://t.me/saintbot_deployers
// TOKEN DEPLOYED USING Saintbot!
// CONTRACT RENOUNCED AUTOMATICALLY
// THIS HAS LIQUIDITY LOCKED FOR 30 DAYS on UNCX, 0 OWNER TOKENS, ANTI-RUG BY DEFAULT!
// Saintbot
// Deploy and manage fair launch anti-rug tokens seamlessly and lightning-fast with low gas on our free-to-use Telegram bot.
// Website: saintbot.app/
// Twitter: twitter.com/TeamSaintbot
// Telegram Bot: https://t.me/saintbot_deployer_bot
// Docs: https://saintbots-organization.gitbook.io/saintbot-docs/

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

interface Factory {
    function ethLiquidityTax() external view returns (address);
    function tradingTaxes() external view returns (address);
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

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
}

contract ModelERC20V2 is Context, IERC20 {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private bots;
    mapping(address => uint256) private _holderLastTransferTimestamp;

    bool public transferDelayEnabled = true;
    address payable public _taxWallet;

    uint256 public _buyTax;
    uint256 public _sellTax;
    uint256 public constant _preventSwapBefore = 5;
    uint256 public _buyCount = 0;

    uint8 public constant _decimals = 9;
    uint256 public _tTotal;
    string public _name;
    string public _symbol;

    // 3% of supply
    uint256 public _maxTxAmount;
    // 6% of supply
    uint256 public _maxWalletSize;
    // 0.5% of supply
    uint256 public _taxSwapThreshold;
    // 0.5% of supply
    uint256 public _maxTaxSwap;

    IUniswapV2Router02 private uniswapV2Router;

    address public uniswapV2Pair;
    address public ref;

    bool private tradingOpen;
    bool private inSwap;
    bool private swapEnabled;

    bool private initialized;

    address public factory;

    // Since our contracts dont have ownership by default, we set this so scanners realize this
    address private constant _owner = address(0);

    event MaxTxAmountUpdated(uint256 _maxTxAmount);

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    function init(
        string memory _nameIn,
        string memory _symbolIn,
        address _user,
        address _refAddress,
        uint256 _totalS,
        uint256 _buyTaxes,
        uint256 _sellTaxes
    ) external payable returns (address poolAddress) {
        require(!initialized, "reinit");

        uint256 totalSupply_ = _totalS * 10 ** _decimals;

        _maxTxAmount = (totalSupply_ * 3) / 100;
        _maxWalletSize = (totalSupply_ * 6) / 100;
        _tTotal = totalSupply_;
        _taxSwapThreshold = (totalSupply_ * 5) / 1000;
        _maxTaxSwap = _taxSwapThreshold;
        _buyTax = _buyTaxes;
        _sellTax = _sellTaxes;

        _name = _nameIn;
        _symbol = _symbolIn;

        _taxWallet = payable(_user);
        _balances[address(this)] = _tTotal;
        _isExcludedFromFee[address(this)] = true;

        factory = msg.sender;

        ref = _refAddress;

        inSwap = false;

        initialized = true;

        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        if (_refAddress != address(0)) {
            // If user has a ref code, take 0.9% fees
            // Send 0.7% to Saintbot
            uint256 saintbot = (7 * msg.value) / 1000;
            // Send 0.2% to ref owner
            uint256 refTax = (2 * msg.value) / 1000;

            // Rev receiver must not be a contract (checked upon ref creation), then 2300 gas forwarded should be enough.
            payable(_refAddress).transfer(refTax);

            // This a gnosis controlled by Saintbot, so needs to use call.
            (bool success,) = payable(Factory(msg.sender).ethLiquidityTax()).call{value: saintbot}("");
            require(success, "failed sending eth");
        } else {
            // If user has not used a ref code, take 1% that go to Saintbot entirely.
            (bool success,) = payable(Factory(msg.sender).ethLiquidityTax()).call{value: msg.value / 100}("");
            require(success, "failed sending eth");
        }

        _approve(address(this), address(uniswapV2Router), _tTotal);

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());

        uniswapV2Router.addLiquidityETH{value: address(this).balance}(
            address(this), balanceOf(address(this)), 0, 0, msg.sender, block.timestamp
        );

        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max);

        swapEnabled = true;
        tradingOpen = true;

        emit Transfer(address(0), _msgSender(), _tTotal);

        return uniswapV2Pair;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
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
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
        );
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

        uint256 taxAmount;

        if (from != _taxWallet && to != _taxWallet) {
            taxAmount = amount.mul(_buyTax).div(100);
            if (transferDelayEnabled) {
                if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
                    require(
                        _holderLastTransferTimestamp[tx.origin] < block.number,
                        "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
                    );
                    _holderLastTransferTimestamp[tx.origin] = block.number;
                }
            }

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                _buyCount++;
            }

            if (to == uniswapV2Pair && from != address(this)) {
                taxAmount = amount.mul(_sellTax).div(100);
            }

            uint256 contractTokenBalance = balanceOf(address(this));

            if (
                !inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold
                    && _buyCount > _preventSwapBefore
            ) {
                swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if (contractETHBalance > 5000000000000000) {
                    sendETHToFee(address(this).balance);
                }
            }
        }

        if (!tradingOpen) {
            taxAmount = 0;
        }

        if (taxAmount > 0) {
            _balances[address(this)] = _balances[address(this)].add(taxAmount);
            emit Transfer(from, address(this), taxAmount);
        }

        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount.sub(taxAmount));

        emit Transfer(from, to, amount.sub(taxAmount));
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return (a > b) ? b : a;
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount, 0, path, address(this), block.timestamp
        );
    }

    function sendETHToFee(uint256 amount) private {
        Factory _factory = Factory(factory);

        if (ref == address(0)) {
            // If user has not entered a ref code, he will receive 4% fees
            uint256 taxWalletAmount = (amount * 80) / 100;

            _taxWallet.transfer(taxWalletAmount);

            address payable revShareMultisig = payable(_factory.tradingTaxes());

            (bool success,) = revShareMultisig.call{value: amount - taxWalletAmount}("");

            require(success, "failed sending eth");
        } else {
            // If he did enter a ref code, he will receive 4.1% fees
            uint256 taxWalletAmount = (amount * 82) / 100;

            _taxWallet.transfer(taxWalletAmount);

            // 0.15% to ref address, meaning that its 3% out of the 5%
            payable(ref).transfer((amount * 3) / 100);
            address payable revShareMultisig = payable(_factory.tradingTaxes());

            (bool success,) = revShareMultisig.call{value: (amount * 15) / 100}("");

            require(success, "failed sending eth");
        }
    }

    receive() external payable {}

    function manualSwap() external {
        require(Factory(factory).tradingTaxes() == _msgSender());

        uint256 tokenBalance = balanceOf(address(this));
        if (tokenBalance > 0) {
            swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            sendETHToFee(ethBalance);
        }
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function updateTaxWallet(address _updateTaxWallet) external {
        require(msg.sender == _taxWallet, "auth");
        require(_updateTaxWallet != address(0), "address(0)");

        _taxWallet = payable(_updateTaxWallet);
    }
}
