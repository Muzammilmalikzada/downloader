// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Ownable.sol";
import "./IUniswapV2Factory.sol";
import "./IUniswapV2Pair.sol";
import "./IUniswapV2Router02.sol";

contract NGS is ERC20, Ownable {
    modifier lockSwap() {
        _inSwap = true;
        _;
        _inSwap = false;
    }

    modifier liquidityAdd() {
        _inLiquidityAdd = true;
        _;
        _inLiquidityAdd = false;
    }

    uint256 public constant MAX_MINT = 100_000_000 ether;
    uint256 public constant BPS_DENOMINATOR = 10_000;
    uint256 public constant SNIPE_BLOCKS = 2;

    IUniswapV2Router02 internal immutable _router;
    address internal immutable _pair;

    /// @notice Buy taxes in BPS
    uint256[2] public buyTaxes;
    /// @notice Sell taxes in BPS
    uint256[2] public sellTaxes;
    /// @notice Maximum that can be bought in a single transaction
    uint256 public maxBuy = 1_000_000 ether;
    /// @notice tokens that are allocated for each tax
    uint256[2] public totalTaxes;
    /// @notice addresses that each tax is sent to
    address payable[2] public taxWallets;
    /// @notice Maps each recipient to their tax exlcusion status
    mapping(address => bool) public taxExcluded;
    /// @notice Maps address to flag indicating if they can call goup
    mapping(address => bool) public goupable;
    /// @notice Maps address to flag indicating if they can receive goup
    mapping(address => bool) public goupReceiveable;

    /// @notice Contract NGS balance threshold before `_swap` is invoked
    uint256 public minTokenBalance = 1000 ether;
    /// @notice Flag for auto-calling `_swap`
    bool public autoSwap = true;
    /// @notice Flag indicating whether buys/sells are permitted
    bool public tradingActive = false;

    uint256 internal _totalSupply = 0;
    uint256 internal _minted = 0;
    mapping(address => uint256) private _balances;

    bool internal _inSwap = false;
    bool internal _inLiquidityAdd = false;

    event TaxWalletsChanged(
        address payable[2] previousWallets,
        address payable[2] nextWallets
    );
    event BuyTaxesChanged(uint256[2] previousTaxes, uint256[2] nextTaxes);
    event SellTaxesChanged(uint256[2] previousTaxes, uint256[2] nextTaxes);
    event MinTokenBalanceChanged(uint256 previousMin, uint256 nextMin);
    event MaxBuyChanged(uint256 previousMax, uint256 nextMax);
    event TaxesRescued(uint256 index, uint256 amount);
    event TradingActiveChanged(bool enabled);
    event TaxExclusionChanged(address user, bool taxExcluded);
    event AutoSwapChanged(bool enabled);
    event GoupableChanged(address user, bool goupable);
    event GoupReceiveableChanged(address user, bool goupReceiveable);

    constructor(
      IUniswapV2Router02 _uniswapRouter,
      address payable[2] memory _taxWallets,
      uint256[2] memory _buyTaxes,
      uint256[2] memory _sellTaxes,
      uint256 _goupAmount
    )
        ERC20("NoGas", "NGS")
        Ownable()
    {
        taxExcluded[owner()] = true;
        taxExcluded[address(this)] = true;
        taxWallets = _taxWallets;
        buyTaxes = _buyTaxes;
        sellTaxes = _sellTaxes;

        _router = _uniswapRouter;
        _pair = IUniswapV2Factory(_uniswapRouter.factory()).createPair(
            address(this),
            _uniswapRouter.WETH()
        );
        _goup(owner(), _goupAmount);
    }

    /// @notice Change the address of the tax wallets
    /// @param _taxWallets The new address of the tax wallets
    function setTaxWallets(address payable[2] memory _taxWallets)
        external
        onlyOwner
    {
        emit TaxWalletsChanged(taxWallets, _taxWallets);
        taxWallets = _taxWallets;
    }

    /// @notice Change the buy tax rates
    /// @param _buyTaxes The new buy tax rates
    function setBuyTaxes(uint256[2] memory _buyTaxes) external onlyOwner {
        require(
            _buyTaxes[0] + _buyTaxes[1] <= BPS_DENOMINATOR,
            "sum(_buyTaxes) cannot exceed BPS_DENOMINATOR"
        );
        emit BuyTaxesChanged(buyTaxes, _buyTaxes);
        buyTaxes = _buyTaxes;
    }

    /// @notice Change the sell tax rates
    /// @param _sellTaxes The new sell tax rates
    function setSellTaxes(uint256[2] memory _sellTaxes) external onlyOwner {
        require(
            _sellTaxes[0] + _sellTaxes[1] <= BPS_DENOMINATOR,
            "sum(_sellTaxes) cannot exceed BPS_DENOMINATOR"
        );
        emit SellTaxesChanged(sellTaxes, _sellTaxes);
        sellTaxes = _sellTaxes;
    }

    /// @notice Change the minimum contract NGS balance before `_swap` gets invoked
    /// @param _minTokenBalance The new minimum balance
    function setMinTokenBalance(uint256 _minTokenBalance) external onlyOwner {
        emit MinTokenBalanceChanged(minTokenBalance, _minTokenBalance);
        minTokenBalance = _minTokenBalance;
    }

    /// @notice Change the max buy amount
    /// @param _maxBuy The new max buy amount
    function setMaxBuy(uint256 _maxBuy) external onlyOwner {
        emit MaxBuyChanged(maxBuy, _maxBuy);
        maxBuy = _maxBuy;
    }

    /// @notice Add a user to goupable
    /// @param _user The user to add to goupable
    function goupableAdd(address _user) external onlyOwner {
        goupable[_user] = true;
        emit GoupableChanged(_user, true);
    }

    /// @notice Remove a user from goupable
    /// @param _user The user to remove from goupable
    function goupableRemove(address _user) external onlyOwner {
        goupable[_user] = false;
        emit GoupableChanged(_user, false);
    }

    /// @notice Add a user to goupReceiveable
    /// @param _user The user to add to goupReceiveable
    function goupReceiveableAdd(address _user) external onlyOwner {
        goupReceiveable[_user] = true;
        emit GoupReceiveableChanged(_user, true);
    }

    /// @notice Remove a user from goupReceiveable
    /// @param _user The user to remove from goupReceiveable
    function goupReceiveableRemove(address _user) external onlyOwner {
        goupReceiveable[_user] = false;
        emit GoupReceiveableChanged(_user, false);
    }

    /// @notice Rescue NGS from the taxes
    /// @dev Should only be used in an emergency
    /// @param _index The tax allocation to rescue from
    /// @param _amount The amount of NGS to rescue
    /// @param _recipient The recipient of the rescued NGS
    function rescueTaxTokens(
        uint256 _index,
        uint256 _amount,
        address _recipient
    ) external onlyOwner {
        require(0 <= _index && _index < totalTaxes.length, "_index OOB");
        require(
            _amount <= totalTaxes[_index],
            "Amount cannot be greater than totalTax"
        );
        _rawTransfer(address(this), _recipient, _amount);
        emit TaxesRescued(_index, _amount);
        totalTaxes[_index] -= _amount;
    }

    function addLiquidity(uint256 tokens)
        external
        payable
        onlyOwner
        liquidityAdd
    {
        _goup(address(this), tokens);
        _approve(address(this), address(_router), tokens);

        _router.addLiquidityETH{value: msg.value}(
            address(this),
            tokens,
            0,
            0,
            owner(),
            // solhint-disable-next-line not-rely-on-time
            block.timestamp
        );
    }

    /// @notice Enables or disables trading on Uniswap
    function setTradingActive(bool _tradingActive) external onlyOwner {
        tradingActive = _tradingActive;
        emit TradingActiveChanged(_tradingActive);
    }

    /// @notice Updates tax exclusion status
    /// @param _account Account to update the tax exclusion status of
    /// @param _taxExcluded If true, exclude taxes for this user
    function setTaxExcluded(address _account, bool _taxExcluded)
        external
        onlyOwner
    {
        taxExcluded[_account] = _taxExcluded;
        emit TaxExclusionChanged(_account, _taxExcluded);
    }

    /// @notice Enable or disable whether swap occurs during `_transfer`
    /// @param _autoSwap If true, enables swap during `_transfer`
    function setAutoSwap(bool _autoSwap) external onlyOwner {
        autoSwap = _autoSwap;
        emit AutoSwapChanged(_autoSwap);
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function _addBalance(address account, uint256 amount) internal {
        _balances[account] = _balances[account] + amount;
    }

    function _subtractBalance(address account, uint256 amount) internal {
        _balances[account] = _balances[account] - amount;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        if (taxExcluded[sender] || taxExcluded[recipient]) {
            _rawTransfer(sender, recipient, amount);
            return;
        }

        if (
            totalTaxes[0] + totalTaxes[1] >= minTokenBalance &&
            !_inSwap &&
            sender != _pair &&
            autoSwap
        ) {
            _swap();
        }

        uint256 send = amount;
        uint256[2] memory taxes;
        if (sender == _pair) {
            require(tradingActive, "Trading is not yet active");
            (send, taxes) = _getTaxAmounts(amount, true);
            require(amount <= maxBuy, "Buy amount exceeds maxBuy");
        } else if (recipient == _pair) {
            require(tradingActive, "Trading is not yet active");
            (send, taxes) = _getTaxAmounts(amount, false);
        }
        _rawTransfer(sender, recipient, send);
        _takeTaxes(sender, taxes);
    }

    /// @notice Perform a Uniswap v2 swap from NGS to ETH and handle tax distribution
    function _swap() internal lockSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _router.WETH();

        uint256 walletTaxes = totalTaxes[0] + totalTaxes[1];

        _approve(address(this), address(_router), walletTaxes);
        _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            walletTaxes,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
        uint256 contractEthBalance = address(this).balance;

        uint256 tax0Eth = (contractEthBalance * totalTaxes[0]) / walletTaxes;
        uint256 tax1Eth = (contractEthBalance * totalTaxes[1]) / walletTaxes;
        totalTaxes = [0, 0];

        if (tax0Eth > 0) {
            taxWallets[0].transfer(tax0Eth);
        }
        if (tax1Eth > 0) {
            taxWallets[1].transfer(tax1Eth);
        }
    }

    function swapAll() external {
        if (!_inSwap) {
            _swap();
        }
    }

    function withdrawAll() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    /// @notice Transfers NGS from an account to this contract for taxes
    /// @param _account The account to transfer NGS from
    /// @param _taxAmounts The amount for each tax
    function _takeTaxes(address _account, uint256[2] memory _taxAmounts)
        internal
    {
        require(_account != address(0), "taxation from the zero address");

        uint256 totalAmount = _taxAmounts[0] + _taxAmounts[1];
        _rawTransfer(_account, address(this), totalAmount);
        totalTaxes[0] += _taxAmounts[0];
        totalTaxes[1] += _taxAmounts[1];
    }

    /// @notice Get a breakdown of send and tax amounts
    /// @param amount The amount to tax in wei
    /// @return send The raw amount to send
    /// @return taxes The raw tax amounts
    function _getTaxAmounts(uint256 amount, bool buying)
        internal
        view
        returns (uint256 send, uint256[2] memory taxes)
    {
        if (buying) {
            taxes = [
                (amount * buyTaxes[0]) / BPS_DENOMINATOR,
                (amount * buyTaxes[1]) / BPS_DENOMINATOR
            ];
        } else {
            taxes = [
                (amount * sellTaxes[0]) / BPS_DENOMINATOR,
                (amount * sellTaxes[1]) / BPS_DENOMINATOR
            ];
        }
        send = amount - taxes[0] - taxes[1];
    }

    // modified from OpenZeppelin ERC20
    function _rawTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "transfer from the zero address");
        require(recipient != address(0), "transfer to the zero address");

        uint256 senderBalance = balanceOf(sender);
        require(senderBalance >= amount, "transfer amount exceeds balance");
        unchecked {
            _subtractBalance(sender, amount);
        }
        _addBalance(recipient, amount);

        emit Transfer(sender, recipient, amount);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function _goup(address account, uint256 amount) internal {
        require(_minted + amount <= MAX_MINT, "Max supply exceeded");
        _minted += amount;
        _totalSupply += amount;
        _addBalance(account, amount);
        emit Transfer(address(0), account, amount);
    }

    function goup(address account, uint256 amount) external {
        require(goupable[msg.sender], "NGS: goupableOnly");
        require(goupReceiveable[account], "NGS: goupReceiveableOnly");
        _goup(account, amount);
    }

    /// @notice Burn own tokens
    /// @param amount The amount of tokens to burn
    function burn(uint256 amount) external {
        _totalSupply -= amount;
        _subtractBalance(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    receive() external payable {}
}
