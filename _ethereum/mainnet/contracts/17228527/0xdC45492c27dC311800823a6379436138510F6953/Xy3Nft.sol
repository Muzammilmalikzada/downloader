// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.13;

import "./ERC721.sol";
import "./AccessControl.sol";
import "./Strings.sol";

/**
 * @title Xy3Nft
 * @author XY3
 * @dev ERC721 token for promissory note.
 */
contract Xy3Nft is ERC721, AccessControl {
    using Strings for uint256;

    /**
     * @dev base URI for token
     */
    string public baseURI;

    /**
     * @dev Role for token URI and mint
     */
    bytes32 public constant MINTER_ROLE = keccak256("MINTER");
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER");

    /**
     * @dev Init the contract and set the default admin role.
     *
     * @param _admin Admin role account
     * @param _name Xy3NFT name
     * @param _symbol Xy3NFT symbol
     * @param _customBaseURI Xy3NFT Base URI
     */
    constructor(
        address _admin,
        string memory _name,
        string memory _symbol,
        string memory _customBaseURI
    ) ERC721(_name, _symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        _setBaseURI(_customBaseURI);
    }

    /**
     * @dev Burn token by minter.
     * @param _tokenId The ERC721 token Id
     */
    function burn(uint256 _tokenId) external onlyRole(MINTER_ROLE) {
        _burn(_tokenId);
    }

    /**
     * @dev Mint a new token and assigned to receiver
     *
     * @param _to The receiver address
     * @param _tokenId The token ID of the Xy3 
     */
    function mint(
        address _to,
        uint256 _tokenId
    ) external onlyRole(MINTER_ROLE) {

        _safeMint(_to, _tokenId);
    }

    /**
     * @dev Set baseURI by URI manager
     * @param _customBaseURI - Base URI for the Xy3NFT
     */
    function setBaseURI(string memory _customBaseURI)
        external
        onlyRole(MANAGER_ROLE)
    {
        _setBaseURI(_customBaseURI);
    }

    /**
     * @dev Defined by IERC165
     * @param _interfaceId The queried selector Id
     */
    function supportsInterface(bytes4 _interfaceId)
        public
        view
        virtual
        override(ERC721, AccessControl)
        returns (bool) 
    {
        return super.supportsInterface(_interfaceId);
    }

    /**
     * @dev Check the token exist or not.
     * @param _tokenId The ERC721 token id
     */
    function exists(uint256 _tokenId)
        external
        view
        returns (bool)
    {
        return _exists(_tokenId);
    }

    /**
     * @dev Get the current chain ID.
     */
    function _getChainID() internal view returns (uint256 id) {
        assembly {
            id := chainid()
        }
    }

    /** 
     * @dev Base URI for concat {tokenURI} by `baseURI` and `tokenId`.
     */
    function _baseURI()
        internal
        view
        virtual
        override
        returns (string memory)
    {
        return baseURI;
    }

    /**
     * @dev Set baseURI, internal used.
     * @param _customBaseURI The new URI.
     */
    function _setBaseURI(string memory _customBaseURI) internal virtual {
        baseURI = bytes(_customBaseURI).length > 0
            ? string(abi.encodePacked(_customBaseURI, _getChainID().toString(), "/"))
            : "";
    }
}
