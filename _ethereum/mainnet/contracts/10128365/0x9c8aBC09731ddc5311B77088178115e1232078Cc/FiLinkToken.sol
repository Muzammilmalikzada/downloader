pragma solidity ^0.4.18;

/**

* @title ERC20Basic

* @dev Simpler version of ERC20 interface

* @dev see https://github.com/ethereum/EIPs/issues/179

*/

contract ERC20Basic {

  function totalSupply() public view returns (uint256);  // totalSupply

  function balanceOf(address who) public view returns (uint256);  // Balance

  function transfer(address to, uint256 value) public returns (bool);  // Transfer

  event Transfer(address indexed from, address indexed to, uint256 value);  //Event for Transaction

}

/**

* @title SafeMath

* @dev Math operations with safety checks that throw on error

*/

library SafeMath {

  /**

  * @dev Multiplies two numbers, throws on overflow.

  */

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    if (a == 0) {

      return 0;

    }

    uint256 c = a * b;

    assert(c / a == b);

    return c;

  }

  /**

  * @dev Integer division of two numbers, truncating the quotient.

  */

  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    // assert(b > 0); // Solidity automatically throws when dividing by 0

    uint256 c = a / b;

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;

  }

  /**

  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    assert(b <= a);

    return a - b;

  }

  /**

  * @dev Adds two numbers, throws on overflow.

  */

  function add(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a + b;

    assert(c >= a);

    return c;

  }

}

/**

* @title ERC20 interface

* @dev see https://github.com/ethereum/EIPs/issues/20

*/

contract ERC20 is ERC20Basic {

  function allowance(address owner, address spender) public view returns (uint256);  // 

  function transferFrom(address from, address to, uint256 value) public returns (bool);  // 

  function approve(address spender, uint256 value) public returns (bool);  // 

  event Approval(address indexed owner, address indexed spender, uint256 value);  // Event

}

/**

* @title Basic token

* @dev Basic version of StandardToken, with no allowances.

*/

contract BasicToken is ERC20Basic {

  using SafeMath for uint256;

  mapping(address => uint256) balances; // 

  uint256 totalSupply_;  // 
  /**

  * @dev total number of tokens in existence

  */

  function totalSupply() public view returns (uint256) {

    return totalSupply_;

  }

  /**

  * @dev transfer token for a specified address

  * @param _to The address to transfer to.

  * @param _value The amount to be transferred.

  */

  function transfer(address _to, uint256 _value) public returns (bool) {

    require(_to != address(0));  // 

    require(_value <= balances[msg.sender]);  // 

    // SafeMath.sub will throw if there is not enough balance.

    balances[msg.sender] = balances[msg.sender].sub(_value);  // 

    balances[_to] = balances[_to].add(_value); // 

    Transfer(msg.sender, _to, _value);  // 

    return true;

  }

  /**

  * @dev Gets the balance of the specified address.

  * @param _owner The address to query the the balance of.

  * @return An uint256 representing the amount owned by the passed address.

  */

  function balanceOf(address _owner) public view returns (uint256 balance) {

    return balances[_owner];  // 

  }

}

/**

* @title Standard ERC20 token

*

* @dev Implementation of the basic standard token.

* @dev https://github.com/ethereum/EIPs/issues/20

* @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol

*/

contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;

  /**

  * @dev Transfer tokens from one address to another

  * @param _from address The address which you want to send tokens from

  * @param _to address The address which you want to transfer to

  * @param _value uint256 the amount of tokens to be transferred

  */

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {

    require(_to != address(0)); // 

    require(_value <= balances[_from]);  // 

    require(_value <= allowed[_from][msg.sender]);  // 址

    balances[_from] = balances[_from].sub(_value); 

    balances[_to] = balances[_to].add(_value);

    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);  // 

    Transfer(_from, _to, _value);

    return true;

  }

  /**

    * Set the maximum amount

    *

    *

    * @param _spender 

    * @param _value 

    */

  function approve(address _spender, uint256 _value) public returns (bool) {

    allowed[msg.sender][_spender] = _value;

    Approval(msg.sender, _spender, _value);

    return true;

  }

  /**

  * @dev Function to check the amount of tokens that an owner allowed to a spender.

  * @param _owner address The address which owns the funds.

  * @param _spender address The address which will spend the funds.

  * @return A uint256 specifying the amount of tokens still available for the spender.

  */

  function allowance(address _owner, address _spender) public view returns (uint256) {

    return allowed[_owner][_spender];

  }

  /**

  * @dev Increase the amount of tokens that an owner allowed to a spender.

  *

  * approve should be called when allowed[_spender] == 0. To increment

  * allowed value is better to use this function to avoid 2 calls (and wait until

  * the first transaction is mined)

  * From MonolithDAO Token.sol

  * @param _spender The address which will spend the funds.

  * @param _addedValue The amount of tokens to increase the allowance by.

  */

  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {

    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);

    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }

  /**

  * @dev Decrease the amount of tokens that an owner allowed to a spender.

  *

  * approve should be called when allowed[_spender] == 0. To decrement

  * allowed value is better to use this function to avoid 2 calls (and wait until

  * the first transaction is mined)

  * From MonolithDAO Token.sol

  * @param _spender The address which will spend the funds.

  * @param _subtractedValue The amount of tokens to decrease the allowance by.

  */

  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {

    uint oldValue = allowed[msg.sender][_spender];

    if (_subtractedValue > oldValue) {

      allowed[msg.sender][_spender] = 0;

    } else {

      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);

    }

    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }

}

/**

* @title SimpleToken

* @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.

* Note they can later distribute these tokens as they wish using `transfer` and other

* `StandardToken` functions.  

*/

contract FiLinkToken is StandardToken {

    string public constant name = "FiLink TokenEx"; // solium-disable-line uppercase

    string public constant symbol = "FILK"; // solium-disable-line uppercase

    uint8 public constant decimals = 18; // solium-disable-line uppercase

    uint256 public constant INITIAL_SUPPLY = (10 ** 8) * (10 ** uint256(decimals));

    /**

    * @dev Constructor that gives msg.sender all of existing tokens.

    */

    function FiLinkToken() public {

        totalSupply_ = INITIAL_SUPPLY;

        balances[msg.sender] = INITIAL_SUPPLY;

        Transfer(0x0, msg.sender, INITIAL_SUPPLY);

    }

}

/**

* @title Ownable

* @dev The Ownable contract has an owner address, and provides basic authorization control

* functions, this simplifies the implementation of "user permissions".  

*/

contract Ownable {

  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**

  * @dev The Ownable constructor sets the original `owner` of the contract to the sender

  * account.

  */

  function Ownable() public {

    owner = msg.sender;

  }

  /**

  * @dev Throws if called by any account other than the owner.

  */

  modifier onlyOwner() {

    require(msg.sender == owner);

    _;

  }

  /**

  * @dev Allows the current owner to transfer control of the contract to a newOwner.

  * @param newOwner The address to transfer ownership to.  

  */

  function transferOwnership(address newOwner) public onlyOwner {

    require(newOwner != address(0));

    OwnershipTransferred(owner, newOwner);

    owner = newOwner;

  }

}

/**

  * @dev Lock/unlock contract

  */

contract HaBTCTokenVault is Ownable {

    using SafeMath for uint256;

    /**

    * @dev Create three account addresses and pre-allocate the unlocked balance to three addresses

    */

    address public teamReserveWallet = 0x373c69fDedE072A3F5ab1843a0e5fE0102Cc6793;

    address public firstReserveWallet = 0x99C83f62DBE1a488f9C9d370DA8e86EC55224eB4;

    address public secondReserveWallet = 0x90DfF11810dA6227d348C86C59257C1C0033D307;

    /** The lock-up amount corresponding to the three account addresses */

    uint256 public teamReserveAllocation = 2 * (10 ** 8) * (10 ** 18);

    uint256 public firstReserveAllocation = 15 * (10 ** 7) * (10 ** 18);

    uint256 public secondReserveAllocation = 15 * (10 ** 7) * (10 ** 18);

    // 总锁仓的金额

    uint256 public totalAllocation = 5 * (10 ** 8) * (10 ** 18);

    /** 三个账户地址对应的锁仓时间 */

    uint256 public teamTimeLock = 2 * 365 days;

    uint256 public teamVestingStages = 8;

    uint256 public firstReserveTimeLock = 2 * 365 days;

    uint256 public secondReserveTimeLock = 3 * 365 days;

    /** Reserve allocations */

    mapping(address => uint256) public allocations;  // 每个地址对应锁仓金额的映射表

    /** When timeLocks are over (UNIX Timestamp)  */ 

    mapping(address => uint256) public timeLocks;  // 每个地址对应锁仓时间的映射表

    /** How many tokens each reserve wallet has claimed */

    mapping(address => uint256) public claimed;  // 每个地址对应锁仓后已经解锁的金额的映射表

    /** When this vault was locked (UNIX Timestamp)*/

    uint256 public lockedAt = 0;

    FiLinkToken public token;

    /** Allocated reserve tokens */

    event Allocated(address wallet, uint256 value);

    /** Distributed reserved tokens */

    event Distributed(address wallet, uint256 value);

    /** Tokens have been locked */

    event Locked(uint256 lockTime);

    //Any of the three reserve wallets

    modifier onlyReserveWallets {  // 合约调用者的锁仓余额大于0才能查询锁仓余额

        require(allocations[msg.sender] > 0);

        _;

    }

    //Only Libra team reserve wallet

    modifier onlyTeamReserve {  // 合约调用者的地址为teamReserveWallet

        require(msg.sender == teamReserveWallet);

        require(allocations[msg.sender] > 0);

        _;

    }

    //Only first and second token reserve wallets

    modifier onlyTokenReserve { // 合约调用者的地址为firstReserveWallet或者secondReserveWallet

        require(msg.sender == firstReserveWallet || msg.sender == secondReserveWallet);

        require(allocations[msg.sender] > 0);

        _;

    }

    //Has not been locked yet

    modifier notLocked {  // 未锁定

        require(lockedAt == 0);

        _;

    }

    modifier locked { // 锁定

        require(lockedAt > 0);

        _;

    }

    //Token allocations have not been set

    modifier notAllocated {  // 没有为每个地址分配对应的锁仓金额时

        require(allocations[teamReserveWallet] == 0);

        require(allocations[firstReserveWallet] == 0);

        require(allocations[secondReserveWallet] == 0);

        _;

    }

    function HaBTCTokenVault(ERC20 _token) public {  // 构造LibraToken模式的合约

        owner = msg.sender;  // msg.sender 是指直接调用当前合约的调用方地址

        token = FiLinkToken(_token);



    }

    function allocate() public notLocked notAllocated onlyOwner { 

        //Makes sure Token Contract has the exact number of tokens

        require(token.balanceOf(address(this)) == totalAllocation); 



        allocations[teamReserveWallet] = teamReserveAllocation;

        allocations[firstReserveWallet] = firstReserveAllocation;

        allocations[secondReserveWallet] = secondReserveAllocation;

        Allocated(teamReserveWallet, teamReserveAllocation);

        Allocated(firstReserveWallet, firstReserveAllocation);

        Allocated(secondReserveWallet, secondReserveAllocation);

        lock();

    }



    function lock() internal notLocked onlyOwner {

        lockedAt = block.timestamp; // 区块当前时间

        timeLocks[teamReserveWallet] = lockedAt.add(teamTimeLock);

        timeLocks[firstReserveWallet] = lockedAt.add(firstReserveTimeLock);

        timeLocks[secondReserveWallet] = lockedAt.add(secondReserveTimeLock);

        Locked(lockedAt);

    }

    function recoverFailedLock() external notLocked notAllocated onlyOwner {

        // Transfer all tokens on this contract back to the owner

        require(token.transfer(owner, token.balanceOf(address(this))));

    }

    // Total number of tokens currently in the vault

    // 查询当前合约所持有的金额

    function getTotalBalance() public view returns (uint256 tokensCurrentlyInVault) {

        return token.balanceOf(address(this));

    }

    // Number of tokens that are still locked

    function getLockedBalance() public view onlyReserveWallets returns (uint256 tokensLocked) {

        return allocations[msg.sender].sub(claimed[msg.sender]); 

    }

    //Claim tokens for first/second reserve wallets



    function claimTokenReserve() onlyTokenReserve locked public {

        address reserveWallet = msg.sender;

        // Can't claim before Lock ends

        require(block.timestamp > timeLocks[reserveWallet]); 

        // Must Only claim once

        require(claimed[reserveWallet] == 0);  

        uint256 amount = allocations[reserveWallet];

        claimed[reserveWallet] = amount;  // 一次性解锁发放

        require(token.transfer(reserveWallet, amount));

        Distributed(reserveWallet, amount);

    }

    //Claim tokens for Libra team reserve wallet

    function claimTeamReserve() onlyTeamReserve locked public {

        uint256 vestingStage = teamVestingStage(); 

        //Amount of tokens the team should have at this vesting stage

        uint256 totalUnlocked = vestingStage.mul(allocations[teamReserveWallet]).div(teamVestingStages); // 总的解锁量

        require(totalUnlocked <= allocations[teamReserveWallet]);

        //Previously claimed tokens must be less than what is unlocked

        require(claimed[teamReserveWallet] < totalUnlocked); 

        uint256 payment = totalUnlocked.sub(claimed[teamReserveWallet]); 

        claimed[teamReserveWallet] = totalUnlocked;

        require(token.transfer(teamReserveWallet, payment)); 

        Distributed(teamReserveWallet, payment);

    }

    //Current Vesting stage for Libra team

    function teamVestingStage() public view onlyTeamReserve returns(uint256){

        // Every 3 months

        uint256 vestingMonths = teamTimeLock.div(teamVestingStages); 

        uint256 stage = (block.timestamp.sub(lockedAt)).div(vestingMonths); 

        //Ensures team vesting stage doesn't go past teamVestingStages

        return stage;

    }

}