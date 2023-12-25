// SPDX-License-Identifier: MIT
//A SOVRN Drop

/*
Noctilucent Mementi by MLO.art

__/\\\\\_____/\\\__________________________________________________/\\\\\\___________________________________________________________________________
 _\/\\\\\\___\/\\\_________________________________________________\////\\\___________________________________________________________________________
  _\/\\\/\\\__\/\\\_________________________________/\\\_______/\\\____\/\\\_________________________________________________________________/\\\______
   _\/\\\//\\\_\/\\\_____/\\\\\________/\\\\\\\\__/\\\\\\\\\\\_\///_____\/\\\_____/\\\____/\\\_____/\\\\\\\\_____/\\\\\\\\___/\\/\\\\\\____/\\\\\\\\\\\_
    _\/\\\\//\\\\/\\\___/\\\///\\\____/\\\//////__\////\\\////___/\\\____\/\\\____\/\\\___\/\\\___/\\\//////____/\\\/////\\\_\/\\\////\\\__\////\\\////__
     _\/\\\_\//\\\/\\\__/\\\__\//\\\__/\\\____________\/\\\______\/\\\____\/\\\____\/\\\___\/\\\__/\\\__________/\\\\\\\\\\\__\/\\\__\//\\\____\/\\\______
      _\/\\\__\//\\\\\\_\//\\\__/\\\__\//\\\___________\/\\\_/\\__\/\\\____\/\\\____\/\\\___\/\\\_\//\\\________\//\\///////___\/\\\___\/\\\____\/\\\_/\\__
       _\/\\\___\//\\\\\__\///\\\\\/____\///\\\\\\\\____\//\\\\\___\/\\\__/\\\\\\\\\_\//\\\\\\\\\___\///\\\\\\\\__\//\\\\\\\\\\_\/\\\___\/\\\____\//\\\\\___
        _\///_____\/////_____\/////________\////////______\/////____\///__\/////////___\/////////______\////////____\//////////__\///____\///______\/////____
__/\\\\____________/\\\\_______________________________________________________________________________________________
 _\/\\\\\\________/\\\\\\_______________________________________________________________________________________________
  _\/\\\//\\\____/\\\//\\\_____________________________________________________________________/\\\_______/\\\___________
   _\/\\\\///\\\/\\\/_\/\\\_____/\\\\\\\\_____/\\\\\__/\\\\\_______/\\\\\\\\___/\\/\\\\\\____/\\\\\\\\\\\_\///____________
    _\/\\\__\///\\\/___\/\\\___/\\\/////\\\__/\\\///\\\\\///\\\___/\\\/////\\\_\/\\\////\\\__\////\\\////___/\\\___________
     _\/\\\____\///_____\/\\\__/\\\\\\\\\\\__\/\\\_\//\\\__\/\\\__/\\\\\\\\\\\__\/\\\__\//\\\____\/\\\______\/\\\___________
      _\/\\\_____________\/\\\_\//\\///////___\/\\\__\/\\\__\/\\\_\//\\///////___\/\\\___\/\\\____\/\\\_/\\__\/\\\___________
       _\/\\\_____________\/\\\__\//\\\\\\\\\\_\/\\\__\/\\\__\/\\\__\//\\\\\\\\\\_\/\\\___\/\\\____\//\\\\\___\/\\\___________
        _\///______________\///____\//////////__\///___\///___\///____\//////////__\///____\///______\/////____\///____________
__/\\\_________________________________/\\\\____________/\\\\__/\\\___________________/\\\\\_______________________________________________________
 _\/\\\________________________________\/\\\\\\________/\\\\\\_\/\\\_________________/\\\///\\\_____________________________________________________
  _\/\\\___________/\\\__/\\\___________\/\\\//\\\____/\\\//\\\_\/\\\_______________/\\\/__\///\\\_________________________________________/\\\______
   _\/\\\__________\//\\\/\\\____________\/\\\\///\\\/\\\/_\/\\\_\/\\\______________/\\\______\//\\\________/\\\\\\\\\_____/\\/\\\\\\\___/\\\\\\\\\\\_
    _\/\\\\\\\\\_____\//\\\\\_____________\/\\\__\///\\\/___\/\\\_\/\\\_____________\/\\\_______\/\\\_______\////////\\\___\/\\\/////\\\_\////\\\////__
     _\/\\\////\\\_____\//\\\______________\/\\\____\///_____\/\\\_\/\\\_____________\//\\\______/\\\__________/\\\\\\\\\\__\/\\\___\///_____\/\\\______
      _\/\\\__\/\\\__/\\_/\\\_______________\/\\\_____________\/\\\_\/\\\______________\///\\\__/\\\___________/\\\/////\\\__\/\\\____________\/\\\_/\\__
       _\/\\\\\\\\\__\//\\\\/________________\/\\\_____________\/\\\_\/\\\\\\\\\\\\\\\____\///\\\\\/______/\\\_\//\\\\\\\\/\\_\/\\\____________\//\\\\\___
        _\/////////____\////__________________\///______________\///__\///////////////_______\/////_______\///___\////////\//__\///______________\/////____

Martin Lukas Ostachowski / @MLOdotArt / September 2023
*/
pragma solidity =0.8.9 <0.9.0;

import "./ERC721AQueryable.sol";
import "./Ownable.sol";
import "./MerkleProof.sol";
import "./ReentrancyGuard.sol";
import "./Strings.sol";
import "./OperatorFilterer.sol";

contract MLO is ERC721AQueryable, Ownable, ReentrancyGuard, OperatorFilterer {

  using Strings for uint256;

  bytes32 public merkleRoot;
  mapping(address => bool) public whitelistClaimed;

  string public uriPrefix = 'ipfs://QmPFCBwHcxsPVjDbRggeArbd2ymgvMoNHZDb9FMnFHYVwF/';
  string public uriSuffix = '.json';


  uint256 public cost;
  uint256 public maxSupply;
  uint256 public maxMintAmountPerTx;
  address public adminAddress = 0xAB292B4A0F319dB00938fb2B40f579693C6c7126;

  bool public paused = true;
  bool public whitelistMintEnabled = false;
  bool public shuffled = false;

  bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
  address public defaultRoyaltyReceiver;
  mapping(uint256 => address) royaltyReceivers;
  uint256 public defaultRoyaltyPercentage;
  mapping(uint256 => uint256) royaltyPercentages;

  uint256[] private numberArr ;

  string _tokenName = "Noctilucent Mementi by MLO.art";
  string _tokenSymbol = "MLONM";
  uint256 _maxSupply = 210;
  address _defaultRoyaltyReceiver = 0x172004734f85b1B6E3954c2F201dC4bEaEB80C65; //MLO ADDRESS
  uint256 _defaultRoyaltyAmount = 50; // Points out 1000

  bool public operatorFilteringEnabled;

  constructor() ERC721A(_tokenName, _tokenSymbol) {
    setCost(120000000000000000);
    maxSupply = _maxSupply;
    setMaxMintAmountPerTx(3);
    defaultRoyaltyReceiver = _defaultRoyaltyReceiver;
    defaultRoyaltyPercentage = _defaultRoyaltyAmount;
    _registerForOperatorFiltering();
    operatorFilteringEnabled = true;

  }

  modifier mintCompliance(uint256 _mintAmount) {
    require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
    require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
    _;
  }

  modifier mintPriceCompliance(uint256 _mintAmount) {
    require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
    _;
  }

  modifier requireAdminOrOwner() {
  require(adminAddress == msg.sender || owner() == msg.sender,"Requires admin or owner privileges");
  _;
  }

  function setAdminAddress(address _adminAddress) public requireAdminOrOwner(){
        adminAddress = _adminAddress;
  }

  function testPayMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) requireAdminOrOwner() mintPriceCompliance(_mintAmount) {

    _safeMint(_msgSender(), _mintAmount);
  }

  function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
    // Verify whitelist requirements
    require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
    require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
    bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
    require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');

    whitelistClaimed[_msgSender()] = true;
    _safeMint(_msgSender(), _mintAmount);
  }

  function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
    require(!paused, 'The contract is paused!');

    _safeMint(_msgSender(), _mintAmount);
  }

  function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) requireAdminOrOwner() {
    _safeMint(_receiver, _mintAmount);
  }

  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');


    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, numberArr[_tokenId].toString(), uriSuffix))
        : '';
  }

  function shuffleArr() requireAdminOrOwner() external {
    require(!shuffled, 'the array has already been shuffled');

    numberArr = new uint256[](_maxSupply);
    for (uint256 i = 0; i < _maxSupply; i++) {
        numberArr[i] = i;
    }

    for (uint256 i = 0; i < numberArr.length; i++) {
        uint256 n = i + uint256(keccak256(abi.encode(block.timestamp))) % (numberArr.length - i);
        uint256 temp = numberArr[n];
        numberArr[n] = numberArr[i];
        numberArr[i] = temp;
    }

    shuffled = true;
}

  function setCost(uint256 _cost) public requireAdminOrOwner() {
    cost = _cost;
  }

  function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public requireAdminOrOwner() {
    maxMintAmountPerTx = _maxMintAmountPerTx;
  }

  function setUriPrefix(string memory _uriPrefix) public requireAdminOrOwner() {
    uriPrefix = _uriPrefix;
  }

  function setUriSuffix(string memory _uriSuffix) public requireAdminOrOwner() {
    uriSuffix = _uriSuffix;
  }

  function setPaused(bool _state) public requireAdminOrOwner() {
    paused = _state;
  }

  function setMerkleRoot(bytes32 _merkleRoot) public requireAdminOrOwner() {
    merkleRoot = _merkleRoot;
  }

  function setWhitelistMintEnabled(bool _state) public requireAdminOrOwner() {
    whitelistMintEnabled = _state;
  }

  function withdraw() public requireAdminOrOwner() nonReentrant {


    (bool hs, ) = payable(0xC9367730EDE93Bb941e0a5F6509618001b001fa4).call{value: address(this).balance * 75 / 1000}('');
    require(hs);

    (bool es, ) = payable(0x2B0386bbDd314d8356C21f39BE2491F975BD6361).call{value: address(this).balance * 75 / 1000}('');
    require(es);
    // =============================================================================

    // This will transfer the remaining contract balance to the owner.
    // Do not remove this otherwise you will not be able to withdraw the funds.
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}('');
    require(os);
    // =============================================================================
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return uriPrefix;
  }

  /*//////////////////////////////////////////////////////////////////////////
                        ERC2981 Functions START
  //////////////////////////////////////////////////////////////////////////*/

  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override
    returns (bool)
{
    // Supports the following `interfaceId`s:
    // - IERC165: 0x01ffc9a7
    // - IERC721: 0x80ac58cd
    // - IERC721Metadata: 0x5b5e139f
    // - IERC2981: 0x2a55205a
    return
        interfaceId == 0x01ffc9a7 ||
        interfaceId == 0x80ac58cd ||
        interfaceId == 0x5b5e139f ||
        interfaceId == 0x2a55205a ||
        super.supportsInterface(interfaceId);
}

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        public
        view
        virtual
        returns (address receiver, uint256 royaltyAmount)
    {
        receiver = royaltyReceivers[_tokenId] != address(0)
            ? royaltyReceivers[_tokenId]
            : defaultRoyaltyReceiver;
        royaltyAmount = royaltyPercentages[_tokenId] != 0 ? (_salePrice * royaltyPercentages[_tokenId]) / 1000 : (_salePrice * defaultRoyaltyPercentage) / 1000;
    }

    function setDefaultRoyaltyReceiver(address _receiver) external requireAdminOrOwner() {
        defaultRoyaltyReceiver = _receiver;
    }

    function setRoyaltyReceiver(uint256 _tokenId, address _newReceiver)
        external requireAdminOrOwner()
    {
        royaltyReceivers[_tokenId] = _newReceiver;
    }

    function setRoyaltyPercentage(uint256 _tokenId, uint256 _percentage)
        external requireAdminOrOwner()
    {
        royaltyPercentages[_tokenId] = _percentage;
    }

  /*//////////////////////////////////////////////////////////////////////////
                        ERC2981 Functions END
  //////////////////////////////////////////////////////////////////////////*/

  /*//////////////////////////////////////////////////////////////////////////
                        OS OPERATOR FILTER START
  //////////////////////////////////////////////////////////////////////////*/
  function setApprovalForAll(address operator, bool approved)
        public
        override
        onlyAllowedOperatorApproval(operator)
    {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId)
        public
        payable
        override
        onlyAllowedOperatorApproval(operator)
    {
        super.approve(operator, tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable override onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public payable override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function setOperatorFilteringEnabled(bool value) public onlyOwner {
        operatorFilteringEnabled = value;
    }

    function _operatorFilteringEnabled() internal view override returns (bool) {
        return operatorFilteringEnabled;
    }

    function _isPriorityOperator(address operator)
        internal
        pure
        override
        returns (bool)
    {
        // OpenSea Seaport Conduit:
        // https://etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
        // https://goerli.etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
        return operator == address(0x1E0049783F008A0085193E00003D00cd54003c71);
    }

  /*//////////////////////////////////////////////////////////////////////////
                        OS OPERATOR FILTER END
  //////////////////////////////////////////////////////////////////////////*/
}