/*
╭━━━╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╱╱╱╭╮
┃╭━╮┃╱╱╱╱╱╱╱╱╱╱╱╱╱╱┃╭━╮┃╱╱╱╱╱╱╱╭╯╰╮
┃┃╱┃┣━┳━━┳━╮╭━━┳━━╮┃┃╱╰╋━━┳╮╭┳━┻╮╭╯
┃┃╱┃┃╭┫╭╮┃╭╮┫╭╮┃┃━┫┃┃╱╭┫╭╮┃╰╯┃┃━┫┃
┃╰━╯┃┃┃╭╮┃┃┃┃╰╯┃┃━┫┃╰━╯┃╰╯┃┃┃┃┃━┫╰╮
╰━━━┻╯╰╯╰┻╯╰┻━╮┣━━╯╰━━━┻━━┻┻┻┻━━┻━╯
╱╱╱╱╱╱╱╱╱╱╱╱╭━╯┃
╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC721A.sol";
import "./Ownable.sol";
import "./IERC2981.sol";

contract TWDLandToolDrop is ERC721A, IERC2981, Ownable {
  string public PROVENANCE_HASH;
  string public SEED_PHRASE_HASH;

  uint256 constant ROYALTY_PCT = 10;

  string public baseURI;
  string public termsURI;
  string private _contractURI;
  uint256 private maxSupply;

  address public beneficiary;
  address public royalties;

  struct MsgConfig {
    string MAX_SUPPLY;
  }

  struct MintEntity {
    address to;
    uint256 quantity;
  }

  MsgConfig private msgConfig;

  constructor(
    string memory name,
    string memory symbol,
    uint256 _maxSupply,
    address _royalties,
    string memory _initialBaseURI,
    string memory _initialContractURI
  ) ERC721A(name, symbol) {
    maxSupply = _maxSupply;
    royalties = _royalties;
    beneficiary = royalties;
    baseURI = _initialBaseURI;
    _contractURI = _initialContractURI;
    termsURI = "ipfs://Qmbv7aLanDrHKgpZHjcuEaVQB5Em6qPGUJK3ydQdtzzuro";

    msgConfig = MsgConfig("Max supply will be exceeded");
  }

  function setProvenanceHash(string calldata hash) public onlyOwner {
    PROVENANCE_HASH = hash;
  }

  function setSeedPhraseHash(string calldata hash) public onlyOwner {
    SEED_PHRASE_HASH = hash;
  }

  function setBeneficiary(address _beneficiary) public onlyOwner {
    beneficiary = _beneficiary;
  }

  function setRoyalties(address _royalties) public onlyOwner {
    royalties = _royalties;
  }

  /**
   * Get current block timestamp
   */
  function getCurrentBlockTimestamp() public view returns (uint256) {
    return block.timestamp;
  }

  /**
   * Sets the Base URI for the token API
   */
  function setBaseURI(string memory uri) public onlyOwner {
    baseURI = uri;
  }

  /**
   * Gets the Base URI of the token API
   */
  function _baseURI() internal view override returns (string memory) {
    return baseURI;
  }

  /**
   * OpenSea contract level metdata standard for displaying on storefront.
   * https://docs.opensea.io/docs/contract-level-metadata
   */
  function contractURI() public view returns (string memory) {
    return _contractURI;
  }

  function setContractURI(string memory uri) public onlyOwner {
    _contractURI = uri;
  }

  function setTermsURI(string memory uri) public onlyOwner {
    termsURI = uri;
  }

  /**
   * Override start token ID
   */
  function _startTokenId() internal pure override returns (uint256) {
    return 1;
  }

  /**
   * Mint next available token(s) to addres using ERC721A _safeMint
   */
  function _internalMint(address to, uint256 quantity) private {
    require(totalSupply() + quantity <= maxSupply, msgConfig.MAX_SUPPLY);

    _safeMint(to, quantity);
  }

  /**
   * Owner can mint to specified address
   */
  function ownerMint(address to, uint256 amount) public onlyOwner {
    _internalMint(to, amount);
  }

  /**
   * Return total amount from an array of mint entities
   */
  function _totalAmount(MintEntity[] memory entities)
    private
    pure
    returns (uint256)
  {
    uint256 totalAmount = 0;

    for (uint256 i = 0; i < entities.length; i++) {
      totalAmount += entities[i].quantity;
    }

    return totalAmount;
  }

  /**
   * Bulk mint to address list with quantity
   */
  function _bulkMintQuantity(MintEntity[] memory entities) private {
    uint256 amount = _totalAmount(entities);
    require(totalSupply() + amount <= maxSupply, msgConfig.MAX_SUPPLY);

    for (uint256 i = 0; i < entities.length; i++) {
      _internalMint(entities[i].to, entities[i].quantity);
    }
  }

  /**
   * Awesome Drop multiple addresses with number to mint for each
   */
  function airDrop(MintEntity[] memory entities) public onlyOwner {
    _bulkMintQuantity(entities);
  }

  function withdraw() public onlyOwner {
    require(
      beneficiary != address(0),
      "beneficiary needs to be set to perform this function"
    );
    payable(beneficiary).transfer(address(this).balance);
  }

  /**
   * Supporting ERC721, IER165
   * https://eips.ethereum.org/EIPS/eip-165
   */
  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721A, IERC165)
    returns (bool)
  {
    return
      interfaceId == type(IERC2981).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  /**
   * Setting up royalty standard: IERC2981
   * https://eips.ethereum.org/EIPS/eip-2981
   */
  function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
    external
    view
    returns (address, uint256 royaltyAmount)
  {
    _tokenId; // silence solc unused parameter warning
    royaltyAmount = (_salePrice / 100) * ROYALTY_PCT;
    return (royalties, royaltyAmount);
  }
}
