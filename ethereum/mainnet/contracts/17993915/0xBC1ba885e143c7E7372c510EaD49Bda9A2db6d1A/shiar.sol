/*

$SHIAR - SHIA Reflections
Reflecting on the epic success of Shiba Saga, SHIAR is the mirrored version of SHIA, rewarding holders with juicy reflections. 

4% TAX, 3% automatic $SHIA reflections to all $SHIAR holders, 1% marketing.

https://t.me/shiareflections

*/

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.13;

/**
 * Standard SafeMath, stripped down to just add/sub/mul/div
 */
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

/**
 * ERC20 standard interface.
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

 
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
 
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
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


interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
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

interface IShiaReflections {
    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
    function setShare(address shareholder, uint256 amount) external;
    function deposit() external payable;
    function process(uint256 gas) external;
    function gibTokens(address shareholder) external;
}


contract ShiaReflections is IShiaReflections {

    using SafeMath for uint256;
    address _token;

    address public SHIA;

    IDEXRouter router;

    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }

    address[] shareholders;
    mapping (address => uint256) shareholderIndexes;
    mapping (address => uint256) shareholderClaims;
    mapping (address => Share) public shares;

    uint256 public totalShares;
    uint256 public totalDividends;
    uint256 public totalDistributed;
    uint256 public dividendsPerShare;
    uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;

    uint256 public minPeriod = 30 minutes;
    uint256 public minDistribution = 0 * (10 ** 9);

    uint256 public currentIndex;
    bool initialized;

    modifier initialization() {
        require(!initialized);
        _;
        initialized = true;
    }

    modifier onlyToken() {
        require(msg.sender == _token); _;
    }

    constructor () {
        _token = msg.sender;
        router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        SHIA = 0x43D7E65B8fF49698D9550a7F315c87E67344FB59;
    }
    
    receive() external payable {
        deposit();
    }

    function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
        minPeriod = newMinPeriod;
        minDistribution = newMinDistribution;
    }

    function setShare(address shareholder, uint256 amount) external override onlyToken {

        if(shares[shareholder].amount > 0){
            distributeDividend(shareholder);
        }

        if(amount > 0 && shares[shareholder].amount == 0){
            addShareholder(shareholder);
        }else if(amount == 0 && shares[shareholder].amount > 0){
            removeShareholder(shareholder);
        }

        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
        shares[shareholder].amount = amount;
        shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
    }

    function deposit() public payable override {

        uint256 balanceBefore = IERC20(SHIA).balanceOf(address(this));

        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = address(SHIA);

        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amount = IERC20(SHIA).balanceOf(address(this)).sub(balanceBefore);
        totalDividends = totalDividends.add(amount);
        dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
    }
    
    function process(uint256 gas) external override {
        uint256 shareholderCount = shareholders.length;

        if(shareholderCount == 0) { return; }

        uint256 iterations = 0;
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        while(gasUsed < gas && iterations < shareholderCount) {

            if(currentIndex >= shareholderCount){ currentIndex = 0; }

            if(shouldDistribute(shareholders[currentIndex])){
                distributeDividend(shareholders[currentIndex]);
            }

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }
    
    function shouldDistribute(address shareholder) public view returns (bool) {
        return shareholderClaims[shareholder] + minPeriod < block.timestamp
                && getUnpaidEarnings(shareholder) > minDistribution;
    }

    function distributeDividend(address shareholder) internal {
        if(shares[shareholder].amount == 0){ return; }

        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount > 0){
            totalDistributed = totalDistributed.add(amount);
            IERC20(SHIA).transfer(shareholder, amount);
            shareholderClaims[shareholder] = block.timestamp;
            shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
            shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
        }
    }
    
    function gibTokens(address shareholder) external override onlyToken {
        distributeDividend(shareholder);
    }

    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        if(shares[shareholder].amount == 0){ return 0; }

        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;

        if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }

        return shareholderTotalDividends.sub(shareholderTotalExcluded);
    }

    function getCumulativeDividends(uint256 share) internal view returns (uint256) {
        return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }
}

contract shiar is Context, IERC20, Ownable {
    using SafeMath for uint256;

    address public SHIA = 0x43D7E65B8fF49698D9550a7F315c87E67344FB59; //SHIA CA

    string private constant _name = "Shia Reflections";
    string private constant _symbol = "SHIAR";
    uint8 private constant _decimals = 18;
    
    uint256 private _totalSupply = 1000000000 * (10 ** _decimals);

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping (address => uint256) private cooldown;

    address private WETH;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;

    bool public antiBot = true;

    mapping (address => bool) private bots; 
    mapping (address => bool) public isFeeExempt;
    mapping (address => bool) public isTxLimitExempt;
    mapping (address => bool) public isDividendExempt;

    uint256 public launchedAt;
    address public lpWallet = DEAD;

    uint256 public buyFee = 90;
    uint256 public sellFee = 90;

    uint256 public toReflections = 50;
    uint256 public toLiquidity = 0;
    uint256 public toMarketing = 50;

    uint256 public allocationSum = 100;

    IDEXRouter public router;
    address public pair;
    address public factory;
    address private tokenOwner;
    address public devWallet = payable(0xa5d4d9A5b4b3de255aDAb44D88C2D9139cAd2794);

    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    bool public tradingOpen = false;
    
    ShiaReflections public shiaReflections;
    uint256 public shiaReflectionsGas = 0;

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    uint256 public maxTx = _totalSupply.div(100);
    uint256 public maxWallet = _totalSupply.div(50);
    uint256 public swapThreshold = _totalSupply.div(400);

    constructor () {
        router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
            
        WETH = router.WETH();
        
        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
        
        _allowances[address(this)][address(router)] = type(uint256).max;

        shiaReflections = new ShiaReflections();
        
        isFeeExempt[owner()] = true;
        isFeeExempt[devWallet] = true;            

        isDividendExempt[pair] = true;
        isDividendExempt[address(this)] = true;
        isDividendExempt[DEAD] = true;    

        isTxLimitExempt[owner()] = true;
        isTxLimitExempt[pair] = true;
        isTxLimitExempt[DEAD] = true;
        isTxLimitExempt[devWallet] = true;  


        _balances[owner()] = _totalSupply;
    
        emit Transfer(address(0), owner(), _totalSupply);
    }

    receive() external payable { }


    function setBots(address[] memory bots_) external onlyOwner {
        for (uint i = 0; i < bots_.length; i++) {
            bots[bots_[i]] = true;
        }
    }
    
    //once enabled, cannot be reversed
    function openTrading() external onlyOwner {
        launchedAt = block.number;
        tradingOpen = true;
    }      

    function changeTotalFees(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {

        buyFee = newBuyFee;
        sellFee = newSellFee;
    } 
    
    function changeFeeAllocation(uint256 newRewardFee, uint256 newLpFee, uint256 newMarketingFee) external onlyOwner {
        toReflections = newRewardFee;
        toLiquidity = newLpFee;
        toMarketing = newMarketingFee;
    }

    function changeTxLimit(uint256 newLimit) external onlyOwner {
        maxTx = newLimit;
    }

    function changeWalletLimit(uint256 newLimit) external onlyOwner {
        maxWallet  = newLimit;
    }
    
    function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
        isFeeExempt[holder] = exempt;
    }

    function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
        isTxLimitExempt[holder] = exempt;
    }

    function setDevWallet(address payable newDevWallet) external onlyOwner {
        devWallet = payable(newDevWallet);
    }

    function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
        tokenOwner = newOwnerWallet;
    }     

    function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
        swapAndLiquifyEnabled  = enableSwapBack;
        swapThreshold = newSwapBackLimit;
    }

    function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
        shiaReflections.setDistributionCriteria(newMinPeriod, newMinDistribution);        
    }

    function delBot(address notbot) external onlyOwner {
        bots[notbot] = false;
    }

    function _setIsDividendExempt(address holder, bool exempt) internal {
        require(holder != address(this) && holder != pair);
        isDividendExempt[holder] = exempt;
        if(exempt){
            shiaReflections.setShare(holder, 0);
        }else{
            shiaReflections.setShare(holder, _balances[holder]);
        }
    }

    function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
        _setIsDividendExempt(holder, exempt);
    }

    function changeShiaReflectionsGas(uint256 newGas) external onlyOwner {
        shiaReflectionsGas = newGas;
    }           

    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return owner(); }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transfer(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][msg.sender] != type(uint256).max){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }

        return _transfer(sender, recipient, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        if (sender!= owner() && recipient!= owner()) require(tradingOpen, "hold ur horses big guy."); //transfers disabled before tradingActive
        require(!bots[sender] && !bots[recipient]);

        if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }

        require(amount <= maxTx || isTxLimitExempt[sender], "tx");

        if(!isTxLimitExempt[recipient] && antiBot)
        {
            require(_balances[recipient].add(amount) <= maxWallet, "wallet");
        }

        if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }

        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        
        uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
        _balances[recipient] = _balances[recipient].add(finalAmount);

        // Dividend tracker
        if(!isDividendExempt[sender]) {
            try shiaReflections.setShare(sender, _balances[sender]) {} catch {}
        }

        if(!isDividendExempt[recipient]) {
            try shiaReflections.setShare(recipient, _balances[recipient]) {} catch {} 
        }

        emit Transfer(sender, recipient, finalAmount);
        return true;
    }    

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }  
    
    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        
        uint256 feeApplicable = pair == recipient ? sellFee : buyFee;
        uint256 feeAmount = amount.mul(feeApplicable).div(100);

        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);

        return amount.sub(feeAmount);
    }
    
    function swapTokensForEth(uint256 tokenAmount) private {

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        approve(address(this), tokenAmount);

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            lpWallet,
            block.timestamp
        );
    }

    function swapBack() internal lockTheSwap {
    
        uint256 tokenBalance = _balances[address(this)]; 
        uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2);     
        uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity);

        swapTokensForEth(amountToSwap);

        uint256 totalEthBalance = address(this).balance;
        uint256 ethForSHIA = totalEthBalance.mul(toReflections).div(100);
        uint256 ethForDev = totalEthBalance.mul(toMarketing).div(100);
        uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2);
      
        if (totalEthBalance > 0){
            payable(devWallet).transfer(ethForDev);
        }
        
        try shiaReflections.deposit{value: ethForSHIA}() {} catch {}
        
        if (tokensForLiquidity > 0){
            addLiquidity(tokensForLiquidity, ethForLiquidity);
        }
    }

    function manualSwapBack() external onlyOwner {
        swapBack();
    }

    function clearStuckEth() external onlyOwner {
        uint256 contractETHBalance = address(this).balance;
        if(contractETHBalance > 0){          
            payable(devWallet).transfer(contractETHBalance);
        }
    }

    function manualProcessGas(uint256 manualGas) external onlyOwner {
        shiaReflections.process(manualGas);
    }

    function checkPendingReflections(address shareholder) external view returns (uint256) {
        return shiaReflections.getUnpaidEarnings(shareholder);
    }

    function getSHIA() external {
        shiaReflections.gibTokens(msg.sender);
    }
}