// SPDX-License-Identifier: MIT
// eyJuYW1lIjoiME4xIC0gTWV0YWRhdGEiLCJkZXNjcmlwdGlvbiI6IlRoaXMgc2hvdWxkIE5PVCBiZSByZXZlYWxlZCBiZWZvcmUgYWxsIGFyZSBzb2xkLiBJbWFnZXMgY29udGFpbmVkIGJlbG93IiwiaW1hZ2VzIjoiMHg1MTZENTU0ODYxMzQ0QTc3NEI1MDY3NjY0ODcxNDM1ODMxNTQ3ODMyNTc2OTRBNTg2NDYzNEM2MzY1NTM3NDZGNTEzNjY1Nzg1NTU4Mzg1NDRBNkE0NjYxNjE1MSJ9
pragma solidity ^0.8.0;

import "./ERC721Enumerable.sol";
import "./Ownable.sol";
import "./Strings.sol";

import "./IOniForce.sol";
import "./IOniForceMetadata.sol";

contract OniForce is ERC721Enumerable, Ownable, IOniForce, IOniForceMetadata {
  using Strings for uint256;

  uint256 public constant ONI_GIFT = 77;
  uint256 public constant ONI_PUBLIC = 7_700;
  uint256 public constant ONI_MAX = ONI_GIFT + ONI_PUBLIC;
  uint256 public constant PURCHASE_LIMIT = 7;
  uint256 public constant PRICE = 0.07777 ether;

  bool public isActive = false;
  bool public isAllowListActive = false;
  string public proof;

  uint256 public allowListMaxMint = 2;

  /// @dev We will use these to be able to calculate remaining correctly.
  uint256 public totalGiftSupply;
  uint256 public totalPublicSupply;

  mapping(address => bool) private _allowList;
  mapping(address => uint256) private _allowListClaimed;

  string private _contractURI = '';
  string private _tokenBaseURI = '';
  string private _tokenRevealedBaseURI = '';

  constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

  function addToAllowList(address[] calldata addresses) external override onlyOwner {
    for (uint256 i = 0; i < addresses.length; i++) {
      require(addresses[i] != address(0), "Can't add the null address");

      _allowList[addresses[i]] = true;
      /**
      * @dev We don't want to reset _allowListClaimed count
      * if we try to add someone more than once.
      */
      _allowListClaimed[addresses[i]] > 0 ? _allowListClaimed[addresses[i]] : 0;
    }
  }

  function onAllowList(address addr) external view override returns (bool) {
    return _allowList[addr];
  }

  function removeFromAllowList(address[] calldata addresses) external override onlyOwner {
    for (uint256 i = 0; i < addresses.length; i++) {
      require(addresses[i] != address(0), "Can't add the null address");

      /// @dev We don't want to reset possible _allowListClaimed numbers.
      _allowList[addresses[i]] = false;
    }
  }

  /**
  * @dev We want to be able to distinguish tokens bought during isAllowListActive
  * and tokens bought outside of isAllowListActive
  */
  function allowListClaimedBy(address owner) external view override returns (uint256){
    require(owner != address(0), 'Zero address not on Allow List');

    return _allowListClaimed[owner];
  }

  function purchase(uint256 numberOfTokens) external override payable {
    require(isActive, 'Contract is not active');
    require(!isAllowListActive, 'Only allowing from Allow List');
    require(totalSupply() < ONI_MAX, 'All tokens have been minted');
    require(numberOfTokens <= PURCHASE_LIMIT, 'Would exceed PURCHASE_LIMIT');
    /**
    * @dev The last person to purchase might pay too much.
    * This way however they can't get sniped.
    * If this happens, we'll refund the Eth for the unavailable tokens.
    */
    require(totalPublicSupply < ONI_PUBLIC, 'Purchase would exceed ONI_PUBLIC');
    require(PRICE * numberOfTokens <= msg.value, 'ETH amount is not sufficient');

    for (uint256 i = 0; i < numberOfTokens; i++) {
      /**
      * @dev Since they can get here while exceeding the ONI_MAX,
      * we have to make sure to not mint any additional tokens.
      */
      if (totalPublicSupply < ONI_PUBLIC) {
        /**
        * @dev Public token numbering starts after ONI_GIFT.
        * And we don't want our tokens to start at 0 but at 1.
        */
        uint256 tokenId = ONI_GIFT + totalPublicSupply + 1;

        totalPublicSupply += 1;
        _safeMint(msg.sender, tokenId);
      }
    }
  }

  function purchaseAllowList(uint256 numberOfTokens) external override payable {
    require(isActive, 'Contract is not active');
    require(isAllowListActive, 'Allow List is not active');
    require(_allowList[msg.sender], 'You are not on the Allow List');
    require(totalSupply() < ONI_MAX, 'All tokens have been minted');
    require(numberOfTokens <= allowListMaxMint, 'Cannot purchase this many tokens');
    require(totalPublicSupply + numberOfTokens <= ONI_PUBLIC, 'Purchase would exceed ONI_PUBLIC');
    require(_allowListClaimed[msg.sender] + numberOfTokens <= allowListMaxMint, 'Purchase exceeds max allowed');
    require(PRICE * numberOfTokens <= msg.value, 'ETH amount is not sufficient');

    for (uint256 i = 0; i < numberOfTokens; i++) {
      /**
      * @dev Public token numbering starts after ONI_GIFT.
      * We don't want our tokens to start at 0 but at 1.
      */
      uint256 tokenId = ONI_GIFT + totalPublicSupply + 1;

      totalPublicSupply += 1;
      _allowListClaimed[msg.sender] += 1;
      _safeMint(msg.sender, tokenId);
    }
  }

  function gift(address[] calldata to) external override onlyOwner {
    require(totalSupply() < ONI_MAX, 'All tokens have been minted');
    require(totalGiftSupply + to.length <= ONI_GIFT, 'Not enough tokens left to gift');

    for(uint256 i = 0; i < to.length; i++) {
      /// @dev We don't want our tokens to start at 0 but at 1.
      uint256 tokenId = totalGiftSupply + 1;

      totalGiftSupply += 1;
      _safeMint(to[i], tokenId);
    }
  }

  function setIsActive(bool _isActive) external override onlyOwner {
    isActive = _isActive;
  }

  function setIsAllowListActive(bool _isAllowListActive) external override onlyOwner {
    isAllowListActive = _isAllowListActive;
  }

  function setAllowListMaxMint(uint256 maxMint) external override onlyOwner {
    allowListMaxMint = maxMint;
  }

  function setProof(string calldata proofString) external override onlyOwner {
    proof = proofString;
  }

  function withdraw() external override onlyOwner {
    uint256 balance = address(this).balance;

    payable(msg.sender).transfer(balance);
  }

  function setContractURI(string calldata URI) external override onlyOwner {
    _contractURI = URI;
  }

  function setBaseURI(string calldata URI) external override onlyOwner {
    _tokenBaseURI = URI;
  }

  function setRevealedBaseURI(string calldata revealedBaseURI) external override onlyOwner {
    _tokenRevealedBaseURI = revealedBaseURI;
  }

  function contractURI() public view override returns (string memory) {
    return _contractURI;
  }

  function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
    require(_exists(tokenId), 'Token does not exist');

    /// @dev Convert string to bytes so we can check if it's empty or not.
    string memory revealedBaseURI = _tokenRevealedBaseURI;
    return bytes(revealedBaseURI).length > 0 ?
      string(abi.encodePacked(revealedBaseURI, tokenId.toString())) :
      _tokenBaseURI;
  }
}
