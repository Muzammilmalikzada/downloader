// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./ReentrancyGuard.sol";
import "./SafeERC20.sol";

/**
 * @title TokenSplitter
 * @notice It splits X2Y2 to team/treasury/trading volume reward accounts based on shares.
 */
contract TokenSplitter is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct AccountInfo {
        uint256 shares;
        uint256 tokensDistributedToAccount;
    }

    uint256 public immutable TOTAL_SHARES;

    IERC20 public immutable x2y2Token;

    // Total tokens distributed across all accounts
    uint256 public totalTokensDistributed;

    mapping(address => AccountInfo) public accountInfo;

    event NewSharesOwner(address indexed oldRecipient, address indexed newRecipient);
    event TokensTransferred(address indexed account, uint256 amount);

    /**
     * @notice Constructor
     * @param _accounts array of accounts addresses
     * @param _shares array of shares per account
     * @param _x2y2Token address of the X2Y2 token
     */
    constructor(
        address[] memory _accounts,
        uint256[] memory _shares,
        address _x2y2Token
    ) {
        require(_accounts.length == _shares.length, 'Splitter: Length differ');
        require(_accounts.length > 0, 'Splitter: Length must be > 0');

        uint256 currentShares;

        for (uint256 i = 0; i < _accounts.length; i++) {
            require(_shares[i] > 0, 'Splitter: Shares are 0');

            currentShares += _shares[i];
            accountInfo[_accounts[i]].shares = _shares[i];
        }

        TOTAL_SHARES = currentShares;
        x2y2Token = IERC20(_x2y2Token);
    }

    /**
     * @notice Release X2Y2 tokens to the account
     * @param account address of the account
     */
    function releaseTokens(address account) external nonReentrant {
        require(accountInfo[account].shares > 0, 'Splitter: Account has no share');

        // Calculate amount to transfer to the account
        uint256 totalTokensReceived = x2y2Token.balanceOf(address(this)) + totalTokensDistributed;
        uint256 pendingRewards = ((totalTokensReceived * accountInfo[account].shares) /
            TOTAL_SHARES) - accountInfo[account].tokensDistributedToAccount;

        // Revert if equal to 0
        require(pendingRewards != 0, 'Splitter: Nothing to transfer');

        accountInfo[account].tokensDistributedToAccount += pendingRewards;
        totalTokensDistributed += pendingRewards;

        // Transfer funds to account
        x2y2Token.safeTransfer(account, pendingRewards);

        emit TokensTransferred(account, pendingRewards);
    }

    /**
     * @notice Update share recipient
     * @param _newRecipient address of the new recipient
     * @param _currentRecipient address of the current recipient
     */
    function updateSharesOwner(address _newRecipient, address _currentRecipient)
        external
        onlyOwner
    {
        require(
            accountInfo[_currentRecipient].shares > 0,
            'Owner: Current recipient has no shares'
        );
        require(accountInfo[_newRecipient].shares == 0, 'Owner: New recipient has existing shares');

        // Copy shares to new recipient
        accountInfo[_newRecipient].shares = accountInfo[_currentRecipient].shares;
        accountInfo[_newRecipient].tokensDistributedToAccount = accountInfo[_currentRecipient]
            .tokensDistributedToAccount;

        // Reset existing shares
        accountInfo[_currentRecipient].shares = 0;
        accountInfo[_currentRecipient].tokensDistributedToAccount = 0;

        emit NewSharesOwner(_currentRecipient, _newRecipient);
    }

    /**
     * @notice Retrieve amount of X2Y2 tokens that can be transferred
     * @param account address of the account
     */
    function calculatePendingRewards(address account) external view returns (uint256) {
        if (accountInfo[account].shares == 0) {
            return 0;
        }

        uint256 totalTokensReceived = x2y2Token.balanceOf(address(this)) + totalTokensDistributed;
        uint256 pendingRewards = ((totalTokensReceived * accountInfo[account].shares) /
            TOTAL_SHARES) - accountInfo[account].tokensDistributedToAccount;

        return pendingRewards;
    }
}
