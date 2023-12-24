// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import "./IXERC20.sol";
import "./ERC20.sol";
import "./SafeERC20.sol";
import "./SafeCast.sol";
import "./IXERC20Lockbox.sol";

contract XERC20Lockbox is IXERC20Lockbox {
  using SafeERC20 for IERC20;
  using SafeCast for uint256;

  /**
   * @notice The XERC20 token of this contract
   */
  IXERC20 public immutable XERC20;

  /**
   * @notice The ERC20 token of this contract
   */
  IERC20 public immutable ERC20;

  /**
   * @notice Whether the ERC20 token is the native gas token of this chain
   */

  bool public immutable IS_GAS_TOKEN;

  /**
   * @notice Constructor
   *
   * @param _xerc20 The address of the XERC20 contract
   * @param _erc20 The address of the ERC20 contract
   * @param _isGasToken Whether the ERC20 token is the native gas token of this chain or not
   */

  constructor(address _xerc20, address _erc20, bool _isGasToken) {
    XERC20 = IXERC20(_xerc20);
    ERC20 = IERC20(_erc20);
    IS_GAS_TOKEN = _isGasToken;
  }

  /**
   * @notice Deposit native tokens into the lockbox
   */

  function depositGasToken() public payable {
    if (!IS_GAS_TOKEN) revert IXERC20Lockbox_NotGasToken();

    _deposit(msg.sender, msg.value);
  }

  /**
   * @notice Deposit ERC20 tokens into the lockbox
   *
   * @param _amount The amount of tokens to deposit
   */

  function deposit(uint256 _amount) external {
    if (IS_GAS_TOKEN) revert IXERC20Lockbox_GasToken();

    _deposit(msg.sender, _amount);
  }

  /**
   * @notice Deposit ERC20 tokens into the lockbox, and send the XERC20 to a user
   *
   * @param _to The user to send the XERC20 to
   * @param _amount The amount of tokens to deposit
   */

  function depositTo(address _to, uint256 _amount) external {
    if (IS_GAS_TOKEN) revert IXERC20Lockbox_GasToken();

    _deposit(_to, _amount);
  }

  /**
   * @notice Deposit the native asset into the lockbox, and send the XERC20 to a user
   *
   * @param _to The user to send the XERC20 to
   */

  function depositGasTokenTo(address _to) public payable {
    if (!IS_GAS_TOKEN) revert IXERC20Lockbox_NotGasToken();

    _deposit(_to, msg.value);
  }

  /**
   * @notice Withdraw ERC20 tokens from the lockbox
   *
   * @param _amount The amount of tokens to withdraw
   */

  function withdraw(uint256 _amount) external {
    _withdraw(msg.sender, _amount);
  }

  /**
   * @notice Withdraw tokens from the lockbox
   *
   * @param _to The user to withdraw to
   * @param _amount The amount of tokens to withdraw
   */

  function withdrawTo(address _to, uint256 _amount) external {
    _withdraw(_to, _amount);
  }

  /**
   * @notice Withdraw tokens from the lockbox
   *
   * @param _to The user to withdraw to
   * @param _amount The amount of tokens to withdraw
   */

  function _withdraw(address _to, uint256 _amount) internal {
    emit Withdraw(_to, _amount);

    XERC20.burn(msg.sender, _amount);

    if (IS_GAS_TOKEN) {
      (bool _success,) = payable(_to).call{value: _amount}('');
      if (!_success) revert IXERC20Lockbox_WithdrawFailed();
    } else {
      ERC20.safeTransfer(_to, _amount);
    }
  }

  /**
   * @notice Deposit tokens into the lockbox
   *
   * @param _to The address to send the XERC20 to
   * @param _amount The amount of tokens to deposit
   */

  function _deposit(address _to, uint256 _amount) internal {
    if (!IS_GAS_TOKEN) {
      ERC20.safeTransferFrom(msg.sender, address(this), _amount);
    }

    XERC20.mint(_to, _amount);
    emit Deposit(_to, _amount);
  }

  receive() external payable {
    depositGasToken();
  }
}
