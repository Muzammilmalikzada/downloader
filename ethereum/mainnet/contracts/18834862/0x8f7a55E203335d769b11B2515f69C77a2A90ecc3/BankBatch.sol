// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./AccessControl.sol";
import "./SafeERC20.sol";
import "./ECDSA.sol";
import "./Pausable.sol";

contract SidusBankMultiply is AccessControl, Pausable {
    using ECDSA for bytes32;
    using SafeERC20 for IERC20;

    IERC20 immutable token;
    bytes32 constant PAUSEMODE_ROLE = keccak256("PAUSEMODE_ROLE");
    address public wallet;
    uint immutable chainId = block.chainid;
    mapping(address => bool) public trustedSigner;
    mapping(address => uint) public nonce;
    mapping(uint => bool) public pids;
    event Withdraw(uint indexed pid, address indexed user, uint256 amount);

    /// @param _token address of default reward token
    constructor(address _token, address _signer, address _wallet) {
        token = IERC20(_token);
        trustedSigner[_signer] = true;
        wallet = _wallet;
        _setupRole(PAUSEMODE_ROLE, msg.sender);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @dev main function for getting tokens
    /// @param amount amount of tokens
    /// @param pid pid
    /// @param signature signed data
    function withdraw(
        uint256[] calldata amount,
        uint256[] calldata pid,
        bytes memory signature
    ) external whenNotPaused {
        bytes32 msgForSign = keccak256(
            abi.encode(
                amount,
                msg.sender,
                token,
                nonce[msg.sender],
                chainId,
                pid
            )
        ).toEthSignedMessageHash();

        address signer = msgForSign.recover(signature);
        require(trustedSigner[signer] == true, "Signature check failed");
        for(uint i; i<amount.length; i++) {
            require(!pids[pid[i]], "used pid");
            pids[pid[i]] = true;
            token.safeTransferFrom(wallet, msg.sender, amount[i]);
            emit Withdraw(pid[i], msg.sender, amount[i]);
        }
        nonce[msg.sender]++;
        
        
        

        
    }

    /// @param _wallet new address of wallet
    function setWallet(address _wallet) external onlyRole(DEFAULT_ADMIN_ROLE) {
        wallet = _wallet;
    }

    function pauseOn() external onlyRole(PAUSEMODE_ROLE) {
        _pause();
    }

    function pauseOff() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    /**
     * @dev set/unset signer address
     * @param signer address of signer
     * @param isValid true/false
     */
    function setTrustedSigner(
        address signer,
        bool isValid
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        trustedSigner[signer] = isValid;
    }
}
