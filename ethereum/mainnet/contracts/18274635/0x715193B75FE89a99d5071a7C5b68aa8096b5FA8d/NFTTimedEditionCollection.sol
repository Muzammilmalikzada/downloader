// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.18;

import "./Strings.sol";
import "./AccessControlUpgradeable.sol";
import "./Initializable.sol";
import "./ERC721Upgradeable.sol";
import "./ERC721BurnableUpgradeable.sol";
import "./ContextUpgradeable.sol";
import "./ERC165Upgradeable.sol";

import "./INFTTimedEditionCollectionInitializer.sol";

import "./TimeLibrary.sol";

import "./CollectionRoyalties.sol";
import "./LazyMintedCollection.sol";
import "./NFTCollectionType.sol";
import "./SequentialMintCollection.sol";
import "./SharedPaymentCollection.sol";
import "./SharedURICollection.sol";
import "./TimeLimitedCollection.sol";
import "./AdminRole.sol";
import "./MinterRole.sol";
import "./Constants.sol";
import "./ContractFactory.sol";

/**
 * @title A contract to batch mint a collection of NFTs where each token shares the same `tokenURI`.
 * @notice A 10% royalty to the creator is included which may be split with collaborators.
 * @author cori-grohman & HardlyDifficult
 */
contract NFTTimedEditionCollection is
  INFTTimedEditionCollectionInitializer,
  ContractFactory,
  Initializable,
  ContextUpgradeable,
  ERC165Upgradeable,
  AccessControlUpgradeable,
  AdminRole,
  MinterRole,
  ERC721Upgradeable,
  ERC721BurnableUpgradeable,
  NFTCollectionType,
  SequentialMintCollection,
  CollectionRoyalties,
  LazyMintedCollection,
  TimeLimitedCollection,
  SharedURICollection,
  SharedPaymentCollection
{
  using Strings for uint256;
  using TimeLibrary for uint32;

  /**
   * @notice Initialize the template's immutable variables.
   * @param _contractFactory The factory which will be used to create collection contracts.
   */
  constructor(
    address _contractFactory
  ) ContractFactory(_contractFactory) NFTCollectionType(NFT_TIMED_EDITION_COLLECTION_TYPE) {
    // The template will be initialized by the factory when it's registered for use.
  }

  /**
   * @notice Called by the contract factory on creation.
   * @param _creator The creator of this collection.
   * This account is the default admin for this collection.
   * @param _name The collection's `name`.
   * @param _symbol The collection's `symbol`.
   * @param tokenURI_ The token URI used for all NFTs in this collection.
   * @param _mintEndTime The time in seconds after which no more editions can be minted.
   * @param _approvedMinter An optional address to grant the MINTER_ROLE.
   * Set to address(0) if only admins should be granted permission to mint.
   * @param _paymentAddress The address that will receive royalties and mint payments.
   */
  function initialize(
    address payable _creator,
    string calldata _name,
    string calldata _symbol,
    string calldata tokenURI_,
    uint256 _mintEndTime,
    address _approvedMinter,
    address payable _paymentAddress
  ) external initializer onlyContractFactory {
    // Initialize the mixins
    __ERC721_init(_name, _symbol);
    _initializeSequentialMintCollection(_creator);
    _setBaseURI(tokenURI_);
    _initializeLazyMintedCollection(_creator, _approvedMinter);
    _initializeTimeLimitedCollection(_mintEndTime);
    _initializeSharedPaymentCollection(_paymentAddress);
  }

  /**
   * @inheritdoc LazyMintedCollection
   */
  function mintCountTo(
    uint16 count,
    address to
  ) public override(LazyMintedCollection, TimeLimitedCollection) returns (uint256 firstTokenId) {
    firstTokenId = super.mintCountTo(count, to);
  }

  /**
   * @inheritdoc ERC721Upgradeable
   */
  function _burn(
    uint256 tokenId
  ) internal virtual override(ERC721Upgradeable, LazyMintedCollection, SequentialMintCollection) {
    super._burn(tokenId);
  }

  /**
   * @inheritdoc IERC165Upgradeable
   */
  function supportsInterface(
    bytes4 interfaceId
  )
    public
    view
    override(
      ERC165Upgradeable,
      ERC721Upgradeable,
      AccessControlUpgradeable,
      NFTCollectionType,
      LazyMintedCollection,
      CollectionRoyalties,
      SharedPaymentCollection
    )
    returns (bool isSupported)
  {
    isSupported = super.supportsInterface(interfaceId);
  }

  /**
   * @inheritdoc IERC721MetadataUpgradeable
   * @dev This will return the same URI for all tokenIds, even if it has not been minted.
   */
  function tokenURI(uint256 /* tokenId */) public view override returns (string memory uri) {
    uri = _baseURI();
  }

  /**
   * @inheritdoc ERC721Upgradeable
   */
  function _baseURI() internal view override(ERC721Upgradeable, SharedURICollection) returns (string memory uri) {
    uri = super._baseURI();
  }
}
