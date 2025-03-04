// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.4;

import "./IERC20.sol";
import "./IERC3156FlashLender.sol";
import "./IERC3156FlashBorrower.sol";
import "./Vault.sol";
import "./VaultFactory.sol";

contract FlashBorrowerMock is IERC3156FlashBorrower {
    enum Action {NORMAL, OTHER}
    IERC3156FlashLender public lender;
    VaultFactory vaultFactory;

    constructor(IERC3156FlashLender _lender, VaultFactory _vaultFactory) public {
        lender = _lender;
        vaultFactory = _vaultFactory;
    }

    /// @dev ERC-3156 Flash loan callback
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external override returns (bytes32) {
        require(msg.sender == address(lender), 'FLASH_BORROWER_UNTRUSTED_LENDER');
        require(initiator == address(this), 'FLASH_BORROWER_LOAN_INITIATOR');
        Action action = abi.decode(data, (Action));
        if (action == Action.NORMAL) {
            // do one thing
        } else if (action == Action.OTHER) {
            // do another
        }
        return keccak256('ERC3156FlashBorrower.onFlashLoan');
    }

    /// @dev Initiate a flash loan
    function flashBorrow(address token, uint256 amount) public {
        bytes memory data = abi.encode(Action.NORMAL);
        IERC20 stakedToken = IERC20(token);
        uint256 _allowance = stakedToken.allowance(address(this), address(lender));
        uint256 _fee = lender.flashFee(token, amount);
        uint256 _repayment = amount + _fee;
        stakedToken.approve(address(lender), _allowance + _repayment);
        lender.flashLoan(this, token, amount, data);
    }
}
