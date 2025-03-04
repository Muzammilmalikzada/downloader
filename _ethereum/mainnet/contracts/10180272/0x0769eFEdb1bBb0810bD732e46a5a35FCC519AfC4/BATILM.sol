pragma solidity ^0.4.24;

contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address _who) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
  function allowance(address _owner, address _spender)
    public view returns (uint256);

  function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool);

  function approve(address _spender, uint256 _value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) internal balances;

  uint256 internal totalSupply_;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value <= balances[msg.sender]);
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}

contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(_to != address(0));

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
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
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  modifier hasMintPermission() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address _to,
    uint256 _amount
  )
    public
    hasMintPermission
    canMint
    returns (bool)
  {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() public onlyOwner canMint returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
}

contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    emit Unpause();
  }
}

contract PausableToken is StandardToken, Pausable {

  function transfer(
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.transfer(_to, _value);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(
    address _spender,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.approve(_spender, _value);
  }

  function increaseApproval(
    address _spender,
    uint _addedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(
    address _spender,
    uint _subtractedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}

contract BurnableToken is BasicToken {

  event Burn(address indexed burner, uint256 value);

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */
  function burn(uint256 _value) public {
    _burn(msg.sender, _value);
  }

  function _burn(address _who, uint256 _value) internal {
    require(_value <= balances[_who]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    balances[_who] = balances[_who].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
    emit Burn(_who, _value);
    emit Transfer(_who, address(0), _value);
  }
}

contract Controller is MintableToken, PausableToken, BurnableToken {
    address public thisAddr; // matches delegation slot in proxy
    uint256 public cap;      // the max cap of this token

    string public constant name = "Crypto Price Index"; // solium-disable-line uppercase
    string public constant symbol = "CPI"; // solium-disable-line uppercase
    uint8 public constant decimals = 18; // solium-disable-line uppercase

    constructor() public {}

    /**
    * @dev Function to initialize storage, only callable from proxy.
    * @param _controller The address where code is loaded from through delegatecall
    * @param _cap The cap that should be set for the token
    */
    function initialize(address _controller, uint256 _cap) public onlyOwner {
        require(cap == 0, "Cap is already set");
        require(_cap > 0, "Trying to set an invalid cap");
        require(thisAddr == _controller, "Not calling from proxy");
        cap = _cap;
        totalSupply_ = 0;
    }

    /**
    * @dev Function to mint tokens
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
        require(cap > 0, "Cap not set, not initialized");
        require(totalSupply_.add(_amount) <= cap, "Trying to mint over the cap");
        return super.mint(_to, _amount);
    }

    /**
    * @dev Function to burn tokens
    * @param _amount The amount of tokens to burn.
    */
    function burn(uint256 _amount) public onlyOwner {
        require(cap > 0, "Cap not set, not initialized");
        super.burn(_amount);
    }
}

library Roles {
  struct Role {
    mapping (address => bool) bearer;
  }

  /**
   * @dev give an address access to this role
   */
  function add(Role storage _role, address _addr)
    internal
  {
    _role.bearer[_addr] = true;
  }

  /**
   * @dev remove an address' access to this role
   */
  function remove(Role storage _role, address _addr)
    internal
  {
    _role.bearer[_addr] = false;
  }

  /**
   * @dev check if an address has this role
   * // reverts
   */
  function check(Role storage _role, address _addr)
    internal
    view
  {
    require(has(_role, _addr));
  }

  /**
   * @dev check if an address has this role
   * @return bool
   */
  function has(Role storage _role, address _addr)
    internal
    view
    returns (bool)
  {
    return _role.bearer[_addr];
  }
}

contract RBAC {
  using Roles for Roles.Role;

  mapping (string => Roles.Role) private roles;

  event RoleAdded(address indexed operator, string role);
  event RoleRemoved(address indexed operator, string role);

  /**
   * @dev reverts if addr does not have role
   * @param _operator address
   * @param _role the name of the role
   * // reverts
   */
  function checkRole(address _operator, string _role)
    public
    view
  {
    roles[_role].check(_operator);
  }

  /**
   * @dev determine if addr has role
   * @param _operator address
   * @param _role the name of the role
   * @return bool
   */
  function hasRole(address _operator, string _role)
    public
    view
    returns (bool)
  {
    return roles[_role].has(_operator);
  }

  /**
   * @dev add a role to an address
   * @param _operator address
   * @param _role the name of the role
   */
  function addRole(address _operator, string _role)
    internal
  {
    roles[_role].add(_operator);
    emit RoleAdded(_operator, _role);
  }

  /**
   * @dev remove a role from an address
   * @param _operator address
   * @param _role the name of the role
   */
  function removeRole(address _operator, string _role)
    internal
  {
    roles[_role].remove(_operator);
    emit RoleRemoved(_operator, _role);
  }

  /**
   * @dev modifier to scope access to a single role (uses msg.sender as addr)
   * @param _role the name of the role
   * // reverts
   */
  modifier onlyRole(string _role)
  {
    checkRole(msg.sender, _role);
    _;
  }

  /**
   * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
   * @param _roles the names of the roles to scope access to
   * // reverts
   *
   * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
   *  see: https://github.com/ethereum/solidity/issues/2467
   */
  // modifier onlyRoles(string[] _roles) {
  //     bool hasAnyRole = false;
  //     for (uint8 i = 0; i < _roles.length; i++) {
  //         if (hasRole(msg.sender, _roles[i])) {
  //             hasAnyRole = true;
  //             break;
  //         }
  //     }

  //     require(hasAnyRole);

  //     _;
  // }
}

contract Blacklisted is RBAC {
    string constant BKLST_ROLE = "blacklist";
    bool public blacklistUnlocked;

    constructor() public {}

    modifier notBlacklisted() {
        require(blacklistUnlocked || !isBlacklisted(msg.sender), "Blacklist rights required.");
        _;
    }

    function setBlacklistUnlock(bool _newStatus) public {
        require(blacklistUnlocked!=_newStatus, "You are trying to set current status again");
        blacklistUnlocked = _newStatus;
    }

    /**
     * @dev Allows admins to add people to the blacklist.
     * @param _toAdd The address to be added to blacklist.
     */
    function addToBlacklist(address _toAdd) public {
        require(!isBlacklisted(_toAdd), "Address is blacklisted already");
        addRole(_toAdd,BKLST_ROLE);
    }

    function addListToBlacklist(address[] _toAdd) public {
        for(uint256 i = 0; i<_toAdd.length; i++){
            addToBlacklist(_toAdd[i]);
        }
    }

    function removeFromBlacklist(address _toRemove) public {
        require(isBlacklisted(_toRemove), "Address is not blacklisted");
        removeRole(_toRemove,BKLST_ROLE);
    }

    function removeListFromBlacklist(address[] _toRemove) public {
        for(uint256 i = 0; i<_toRemove.length; i++){
            removeFromBlacklist(_toRemove[i]);
        }
    }

    function isBlacklisted(address _address) public view returns(bool) {
        return hasRole(_address,BKLST_ROLE);
    }
}

contract NAutoblock is RBAC{
    string constant AUTOBLK_ROLE = "autoblocker";

    constructor() public {}

    modifier onlyAutoblockers() {
        require(isAutoblocker(msg.sender), "Autoblocker rights required.");
        _;
    }

    /**
     * @dev Allows autoblockers to add people to the autoblocker list.
     * @param _toAdd The address to be added to autoblocker list.
     */
    function addToAutoblockers(address _toAdd) public {
        require(!isAutoblocker(_toAdd), "Address is autoblocker already");
        addRole(_toAdd,AUTOBLK_ROLE);
    }

    function addListToAutoblockers(address[] _toAdd) public {
        for(uint256 i = 0; i<_toAdd.length; i++){
            addToAutoblockers(_toAdd[i]);
        }
    }

    function removeFromAutoblockers(address _toRemove) public {
        require(isAutoblocker(_toRemove), "Address is not autoblocker");
        removeRole(_toRemove,AUTOBLK_ROLE);
    }

    function removeListFromAutoblockers(address[] _toRemove) public {
        for(uint256 i = 0; i<_toRemove.length; i++){
            removeFromAutoblockers(_toRemove[i]);
        }
    }

    function isAutoblocker(address _address) public view returns(bool) {
        return hasRole(_address,AUTOBLK_ROLE);
    }
}

contract TILM is Controller {

    /**
    * Defining locked balance data structure
    **/
    struct tlBalance {
        uint256 timestamp;
        uint256 balance;
    }

    mapping(address => tlBalance[]) lockedBalances;

    event Locked(address indexed to, uint256 amount, uint256 timestamp);

    /**
    * @dev Returns the amount of locked balances of the specified address.
    * @param _owner The address to query the balance of.
    * @return An uint256 representing the length of the array of locked balances owned by the passed address.
    */
    function lockedBalanceLength(address _owner) public view returns (uint256) {
        return lockedBalances[_owner].length;
    }

    /**
    * @dev Returns the locked balance of the specified address.
    * @param _owner The address to query the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function lockedBalanceOf(address _owner) public view returns (uint256) {
        uint256 lockedBalance = 0;
        for(uint256 i = 0; i < lockedBalanceLength(_owner); i++){
            if(lockedBalances[_owner][i].timestamp>now) {
                lockedBalance += lockedBalances[_owner][i].balance;
            }
        }
        return lockedBalance;
    }

    /**
    * @dev Returns the unlocked balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function unlockedBalanceOf(address _owner) public view returns (uint256) {
        return super.balanceOf(_owner)-lockedBalanceOf(_owner);
    }

    /**
    * @dev Removes the already unlocked tokens from the lockedBalances array for the specified address.
    * @param _owner The address to consolidate the balance of.
    */
    function consolidateBalance(address _owner) public returns (bool) {
        tlBalance[] storage auxBalances = lockedBalances[_owner];
        delete lockedBalances[_owner];
        for(uint256 i = 0; i<auxBalances.length; i++){
            if(auxBalances[i].timestamp > now) {
                lockedBalances[_owner].push(auxBalances[i]);
            }
        }
        return true;
    }

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _amount The amount to be transferred.
    */
    function transfer(address _to, uint256 _amount) public returns (bool) {
        require(_to != address(0), "You can not transfer to address(0).");
        require(_amount <= unlockedBalanceOf(msg.sender), "There is not enough unlocked balance.");
        consolidateBalance(msg.sender);
        return super.transfer(_to, _amount);
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _amount uint256 the amount of tokens to be transferred
    */
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
        require(_to != address(0), "You can not transfer to address(0).");
        require(_amount <= unlockedBalanceOf(_from), "There is not enough unlocked balance.");
        require(_amount <= allowed[_from][msg.sender], "There is not enough allowance.");
        consolidateBalance(_from);
        return super.transferFrom(_from, _to, _amount);
    }

    /**
    * @dev Unlocks balance of the specified address, only callable by owner
    * @param _owner The address to query the the balance of.
    */
    function unlockAllFunds(address _owner) public onlyOwner returns (bool){
        delete lockedBalances[_owner];
        return true;
    }

    /**
    * @dev transfer token to a specified address
    * @param _to The address to transfer to.
    * @param _amount The amount to be transferred.
    * @param _timestamp Unlock timestamp.
    */
    function transferLockedFunds(address _to, uint256 _amount, uint256 _timestamp) public returns (bool){
        transfer(_to, _amount);
        lockedBalances[_to].push(tlBalance(_timestamp,_amount));
        emit Locked(_to, _amount, _timestamp);
        return true;
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _amount uint256 the amount of tokens to be transferred
    * @param _timestamp Unlock timestamp.
    */
    function transferLockedFundsFrom(address _from, address _to, uint256 _amount, uint256 _timestamp) public returns (bool) {
        transferFrom(_from, _to, _amount);
        lockedBalances[_to].push(tlBalance(_timestamp,_amount));
        emit Locked(_to, _amount, _timestamp);
        return true;
    }

    /**
    * @dev transfer token to a specified address
    * @param _to The address to transfer to.
    * @param _amounts The amounts to be transferred.
    * @param _timestamps Unlock timestamps.
    */
    function transferListOfLockedFunds(address _to, uint256[] _amounts, uint256[] _timestamps) public returns (bool) {
        require(_amounts.length==_timestamps.length, "There is not the same number of amounts and timestamps.");
        uint256 _amount = 0;
        for(uint256 i = 0; i<_amounts.length; i++){
            _amount += _amounts[i];
        }
        transfer(_to, _amount);
        for(i = 0; i<_amounts.length; i++){
            lockedBalances[_to].push(tlBalance(_timestamps[i],_amounts[i]));
            emit Locked(_to, _amounts[i], _timestamps[i]);
        }
        return true;
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _amounts uint256 the amount of tokens to be transferred
    * @param _timestamps Unlock timestamps.
    */
    function transferListOfLockedFundsFrom(address _from, address _to, uint256[] _amounts, uint256[] _timestamps) public returns (bool) {
        require(_amounts.length==_timestamps.length, "There is not the same number of amounts and timestamps.");
        uint256 _amount = 0;
        for(uint256 i = 0; i<_amounts.length; i++){
            _amount += _amounts[i];
        }
        transferFrom(_from, _to, _amount);
        for(i = 0; i<_amounts.length; i++){
            lockedBalances[_to].push(tlBalance(_timestamps[i],_amounts[i]));
            emit Locked(_to, _amounts[i], _timestamps[i]);
        }
        return true;
    }

    /**
    * @dev Function to mint locked tokens
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @param _timestamp When the tokens will be unlocked
    * @return A boolean that indicates if the operation was successful.
    */
    function mintLockedBalance(address _to, uint256 _amount, uint256 _timestamp) public onlyOwner canMint returns (bool) {
        require(_timestamp > now, "You can not add a token to unlock in the past.");
        super.mint(_to, _amount);
        lockedBalances[_to].push(tlBalance(_timestamp,_amount));
        emit Locked(_to, _amount, _timestamp);
        return true;
    }
}

contract BATILM is TILM, Blacklisted, NAutoblock {

  constructor() public {}

  modifier onlyAutoblockers() {
      require(msg.sender==owner || isAutoblocker(msg.sender), "Owner or Autoblocker rights required.");
      _;
  }

  function setBlacklistUnlock(bool _newStatus) public onlyAutoblockers {
      super.setBlacklistUnlock(_newStatus);
  }

  /**
   * @dev Allows autoblockers to add people to the blacklist.
   * @param _toAdd The address to be added to blacklist.
   */
  function addToBlacklist(address _toAdd) public onlyAutoblockers {
      super.addToBlacklist(_toAdd);
  }

  function addListToBlacklist(address[] _toAdd) public onlyAutoblockers {
      super.addListToBlacklist(_toAdd);
  }

  function removeFromBlacklist(address _toRemove) public onlyAutoblockers {
      super.removeFromBlacklist(_toRemove);
  }

  function removeListFromBlacklist(address[] _toRemove) public onlyAutoblockers {
      super.removeListFromBlacklist(_toRemove);
  }

  /**
   * @dev Allows autoblockers to add people to the autoblocker list.
   * @param _toAdd The address to be added to autoblocker list.
   */
  function addToAutoblockers(address _toAdd) public onlyAutoblockers {
      super.addToAutoblockers(_toAdd);
  }

  function addListToAutoblockers(address[] _toAdd) public onlyAutoblockers {
      super.addListToAutoblockers(_toAdd);
  }

  function removeFromAutoblockers(address _toRemove) public onlyAutoblockers {
      super.removeFromAutoblockers(_toRemove);
  }

  function removeListFromAutoblockers(address[] _toRemove) public onlyAutoblockers {
      super.removeListFromAutoblockers(_toRemove);
  }

  /**
   * @dev Blacklisted can't transfer tokens. If the sender is an autoblocker, the receiver becomes blacklisted
   * @param _to The address where tokens will be sent to
   * @param _value The amount of tokens to be sent
   */
  function transfer(address _to, uint256 _value) public notBlacklisted returns(bool) {
      //If the destination is not blacklisted, try to add it (only autoblockers modifier)
      if(isAutoblocker(msg.sender) && !isBlacklisted(_to) && !blacklistUnlocked) addToBlacklist(_to);
      return super.transfer(_to, _value);
  }

  /**
   * @dev Blacklisted can't transfer tokens. If the sender is an autoblocker, the receiver becomes blacklisted Also, the msg.sender will need to be approved to do it
   * @param _from The address where tokens will be sent from
   * @param _to The address where tokens will be sent to
   * @param _value The amount of tokens to be sent
   */
  function transferFrom(address _from, address _to, uint256 _value) public notBlacklisted returns (bool) {
      require(!isBlacklisted(_from), "Source is blacklisted");
      //If the destination is not blacklisted, try to add it (only autoblockers modifier)
      if(isAutoblocker(msg.sender) && !isBlacklisted(_to) && !blacklistUnlocked) addToBlacklist(_to);
      return super.transferFrom(_from, _to, _value);
  }

  /**
   * @dev Allow others to spend tokens from the msg.sender address. The spender can't be blacklisted
   * @param _spender The address to be approved
   * @param _value The amount of tokens to be approved
   */
  function approve(address _spender, uint256 _value) public notBlacklisted returns (bool) {
      //If the approve spender is not blacklisted, try to add it (only autoblockers modifier)
      require(!isBlacklisted(_spender) || blacklistUnlocked, "Cannot allow blacklisted addresses to spend tokens");
      return super.approve(_spender, _value);
  }

  /**
  * @dev transfer token to a specified address
  * @param _to The address to transfer to.
  * @param _amount The amount to be transferred.
  * @param _timestamp Unlock timestamp.
  */
  function transferLockedFunds(address _to, uint256 _amount, uint256 _timestamp) public notBlacklisted returns (bool){
      //If the approve spender is not blacklisted, try to add it (only autoblockers modifier)
      if(isAutoblocker(msg.sender) && !isBlacklisted(_to) && !blacklistUnlocked) addToBlacklist(_to);
      return super.transferLockedFunds(_to, _amount, _timestamp);
  }

  /**
  * @dev Transfer tokens from one address to another
  * @param _from address The address which you want to send tokens from
  * @param _to address The address which you want to transfer to
  * @param _amount uint256 the amount of tokens to be transferred
  * @param _timestamp Unlock timestamp.
  */
  function transferLockedFundsFrom(address _from, address _to, uint256 _amount, uint256 _timestamp) public notBlacklisted returns (bool) {
      require(!isBlacklisted(_from), "Source is blacklisted");
      //If the destination is not blacklisted, try to add it (only autoblockers modifier)
      if(isAutoblocker(msg.sender) && !isBlacklisted(_to) && !blacklistUnlocked) addToBlacklist(_to);
      return super.transferLockedFundsFrom(_from, _to, _amount, _timestamp);
  }

  /**
  * @dev transfer token to a specified address
  * @param _to The address to transfer to.
  * @param _amounts The amounts to be transferred.
  * @param _timestamps Unlock timestamps.
  */
  function transferListOfLockedFunds(address _to, uint256[] _amounts, uint256[] _timestamps) public notBlacklisted returns (bool) {
      //If the approve spender is not blacklisted, try to add it (only autoblockers modifier)
      if(isAutoblocker(msg.sender) && !isBlacklisted(_to) && !blacklistUnlocked) addToBlacklist(_to);
      return super.transferListOfLockedFunds(_to, _amounts, _timestamps);
  }

  /**
  * @dev Transfer tokens from one address to another
  * @param _from address The address which you want to send tokens from
  * @param _to address The address which you want to transfer to
  * @param _amounts uint256 the amount of tokens to be transferred
  * @param _timestamps Unlock timestamps.
  */
  function transferListOfLockedFundsFrom(address _from, address _to, uint256[] _amounts, uint256[] _timestamps) public notBlacklisted returns (bool) {
      require(!isBlacklisted(_from), "Source is blacklisted");
      //If the destination is not blacklisted, try to add it (only autoblockers modifier)
      if(isAutoblocker(msg.sender) && !isBlacklisted(_to) && !blacklistUnlocked) addToBlacklist(_to);
      return super.transferListOfLockedFundsFrom(_from, _to, _amounts, _timestamps);
  }
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // assert(_b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}