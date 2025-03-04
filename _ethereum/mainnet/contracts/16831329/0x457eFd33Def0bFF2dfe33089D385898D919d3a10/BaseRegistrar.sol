pragma solidity ^0.8.4;

import "./BNS.sol";
import "./IERC721.sol";
import "./Ownable.sol";

abstract contract BaseRegistrar is Ownable, IERC721 {
    uint256 public constant GRACE_PERIOD = 0; // no protection period
    uint256 public constant RENEW_PERIOD = 180 days;

    event ControllerAdded(address indexed controller);
    event ControllerRemoved(address indexed controller);
    event NameMigrated(
        uint256 indexed id,
        address indexed owner,
        uint256 expires
    );
    event NameRegistered(
        uint256 indexed id,
        address indexed owner,
        uint256 expires
    );
    event NameRenewed(uint256 indexed id, uint256 expires);

    // The BNS registry
    BNS public bns;

    // The namehash of the TLD this registrar owns (eg, .eth)
    bytes32 public baseNode;

    // A map of addresses that are authorised to register and renew names.
    mapping(address => bool) public controllers;

    // Authorises a controller, who can register and renew domains.
    function addController(address controller) external virtual;

    // Revoke controller permission for an address.
    function removeController(address controller) external virtual;

    // Set the resolver for the TLD this registrar manages.
    function setResolver(address resolver) external virtual;

    // Returns the expiration timestamp of the specified label hash.
    function nameExpires(uint256 id) external view virtual returns (uint256);

    // Returns true iff the specified name is available for registration.
    function available(uint256 id) public view virtual returns (bool);

    /**
     * @dev Register a name.
     */
    function register(
        uint256 id,
        address owner,
        uint256 duration
    ) external virtual returns (uint256);

    function renew(uint256 id, uint256 duration)
        external
        virtual
        returns (uint256);

    /**
     * @dev Reclaim ownership of a name in BNS, if you own it in the registrar.
     */
    function reclaim(uint256 id, address owner) external virtual;
}
