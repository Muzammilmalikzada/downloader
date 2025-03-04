/*
              ., _
             /    `
            ((|)))))
            ((/ a a
            )))   >)
           ((((._e((
          ,--/ (-.
         / \ <\/>/|
        / /)     )|
       / / )    / |
      |   /    ( /
      |  /     ;/
      ||(      |
     / )|/|    \
    |/'/\ \_____\
         \   |  \
          \  |\  \
          |  | )  )
          )  )/  /
         /  /   /
        /   |  /
       /    | /
      /     ||
     /      ||
      '-,_  |_\
        ( '"'-`
         \(\_\

          _           _                   _       _     _
         | |         ( )                 | |     (_)   | |
__      _| |__   ___ |/ ___    ___  _   _| |_ ___ _  __| | ___
\ \ /\ / / '_ \ / _ \  / __|  / _ \| | | | __/ __| |/ _` |/ _ \
 \ V  V /| | | | (_) | \__ \ | (_) | |_| | |_\__ \ | (_| |  __/
  \_/\_/ |_| |_|\___/  |___/  \___/ \__,_|\__|___/_|\__,_|\___|

*/
//
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "./ERC721A.sol";
import "./IERC20.sol";
import "./Ownable.sol";
import "./ReentrancyGuard.sol";
import "./MerkleProof.sol";
import "./OperatorFilterer.sol";
import "./ERC721AQueryable.sol";
import "./ERC721ABurnable.sol";
import "./ERC2981.sol";


contract WhosOutside is ERC721AQueryable, ERC721ABurnable, OperatorFilterer, ReentrancyGuard, Ownable, ERC2981 {

    // Variables
    // ---------------------------------------------------------------

    uint256 public immutable collectionSize;
    uint256 public immutable maxPerWallet;

    bool public operatorFilteringEnabled;

    uint256 public numFreeMint = 0;

    bytes32 public freeMintMerkleRoot;
    bytes32 public allowlistMerkleRoot;

    bool public isFreeMintActive = false;
    bool public isAllowlistMintActive = false;
    bool public isMintActive = false;

    uint256 private allowlistMintPrice = 0.05 ether;
    uint256 private mintPrice = 0.06 ether;
    uint256 private reservedFreeMint;
    address private devAddress = 0x111f394Bd7842d1F9B2D1Dcc9fbC6c53B581801d;
    string private _baseTokenURI;

    // Helper functions
    // ---------------------------------------------------------------

    /**
     * @dev This function packs two uint32 values into a single uint64 value.
     * @param a: first uint32
     * @param b: second uint32
     */
    function pack(uint32 a, uint32 b) internal pure returns (uint64) {
        return uint64(a) << 32 | uint64(b);
    }

    /**
     * @dev This function unpacks a uint64 value into two uint32 values.
     * @param a: uint64 value
     */
    function unpack(uint64 a) internal pure returns (uint32, uint32) {
        return (uint32(a >> 32), uint32(a));
    }

    // Modifiers
    // ---------------------------------------------------------------

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract.");
        _;
    }

    modifier freeMintActive() {
        require(isFreeMintActive, "Free mint is not open.");
        _;
    }

    modifier allowlistMintActive() {
        require(isAllowlistMintActive, "Allowlist mint is not open.");
        _;
    }

    modifier mintActive() {
        require(isMintActive, "Mint is not open.");
        _;
    }

    modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
        require(
            MerkleProof.verify(
                merkleProof,
                root,
                keccak256(abi.encodePacked(msg.sender))
            ),
            "Address does not exist in allowlist."
        );
        _;
    }

    modifier freeMintLeft(uint256 quantity) {
        require(
            totalSupply() + quantity <=
                collectionSize &&
            numFreeMint + quantity <= reservedFreeMint,
            "There are no tokens left."
        );
        _;

    }

    modifier mintLeft(uint256 quantity) {
        require(
            _mintLeft(quantity),
            "There are no tokens left."
        );
        _;
    }

    modifier supplyLeft(uint256 quantity) {
        require(
            totalSupply() + quantity <= collectionSize,
            "There are no tokens left."
        );
        _;
    }

    modifier mintNotZero(uint256 quantity){
        require(
            quantity != 0, "You cannont mint 0 tokens."
        );
        _;
    }

    modifier hasNotClaimedFreeMint() {
        (uint32 senderFreeMints, uint32 senderAllowlistMints)  = unpack(_getAux(msg.sender));
        require(
            senderFreeMints == 0,
            "This wallet cannot claim more than 1 free mint."
        );
        _;
    }

    modifier hasNotClaimedAllowlistMint() {
        (uint32 senderFreeMints, uint32 senderAllowlistMints)  = unpack(_getAux(msg.sender));
        require(
            senderAllowlistMints == 0,
            "Cannot claim more than 1 allowlist mint."
        );
        _;
    }

    modifier lessThanMaxPerWallet(uint256 quantity) {
        require(
            _numberMinted(msg.sender) + quantity <=
                maxPerWallet,
            "The maximum number of minted tokens per wallet is 3."
        );
        _;
    }

    modifier isCorrectPayment(uint256 price, uint256 quantity) {
        require(price * quantity == msg.value, "Incorrect amount of ETH sent.");
        _;
    }

    // Constructor
    // ---------------------------------------------------------------

    constructor(
        uint256 collectionSize_,
        uint256 maxPerWallet_,
        uint256 reservedFreeMint_
    ) ERC721A("WhosOutside", "OUTSIDE") {

        collectionSize = collectionSize_;
        maxPerWallet = maxPerWallet_;
        reservedFreeMint = reservedFreeMint_;

        _registerForOperatorFiltering();
        operatorFilteringEnabled = true;
        _setDefaultRoyalty(devAddress, 700); // this should be ledger address

    }

    // Public minting functions
    // ---------------------------------------------------------------

    // Free mint from allowlist
    function freeMint(bytes32[] calldata merkleProof)
        external
        nonReentrant
        callerIsUser
        freeMintActive
        isValidMerkleProof(merkleProof, freeMintMerkleRoot)
        hasNotClaimedFreeMint
        freeMintLeft(1)
    {
        (uint32 senderFreeMints, uint32 senderAllowlistMints)  = unpack(_getAux(msg.sender));
        senderFreeMints++;
        numFreeMint++;
        _setAux(msg.sender, pack(senderFreeMints, senderAllowlistMints));
        _safeMint(msg.sender, 1);
    }

    // Allowlist mint
    function allowlistMint(bytes32[] calldata merkleProof)
        external
        payable
        nonReentrant
        callerIsUser
        allowlistMintActive
        mintLeft(1)
        hasNotClaimedAllowlistMint
        isCorrectPayment(allowlistMintPrice, 1)
        isValidMerkleProof(merkleProof, allowlistMerkleRoot)
    {
        (uint32 senderFreeMints, uint32 senderAllowlistMints)  = unpack(_getAux(msg.sender));
        senderAllowlistMints++;
        _setAux(msg.sender, pack(senderFreeMints, senderAllowlistMints));
        _safeMint(msg.sender, 1);
    }

    // Public mint
    function mint(uint256 quantity)
        external
        payable
        nonReentrant
        callerIsUser
        mintActive
        lessThanMaxPerWallet(quantity)
        isCorrectPayment(mintPrice, quantity)
        mintLeft(quantity)
        mintNotZero(quantity)
    {
        _safeMint(msg.sender, quantity);
    }


    // Public read-only functions
    // ---------------------------------------------------------------

    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    function getAllowlistMintPrice() public view returns (uint256) {
        return allowlistMintPrice;
    }

    function getMintPrice() public view returns (uint256) {
        return mintPrice;
    }

    function getFreeMintCount(address owner) public view returns (uint32) {
        (uint32 senderFreeMints, uint32 senderAllowlistMints)  = unpack(_getAux(owner));
        return senderFreeMints;
    }

    function getAllowlistMintCount(address owner) public view returns (uint32) {
        (uint32 senderFreeMints, uint32 senderAllowlistMints)  = unpack(_getAux(owner));
        return senderAllowlistMints;
    }

    function getFreeMintUserVerifed(bytes32[] calldata merkleProof, address user) public view returns(bool) {
         bool verified = MerkleProof.verify(
                merkleProof,
                freeMintMerkleRoot,
                keccak256(abi.encodePacked(user))
            );
        return verified;
    }

    function getAllowlistUserVerifed(bytes32[] calldata merkleProof, address user) public view returns(bool) {
         bool verified = MerkleProof.verify(
                merkleProof,
                allowlistMerkleRoot,
                keccak256(abi.encodePacked(user))
            );
        return verified;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override (IERC721A, ERC721A)
        returns (string memory)
    {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length != 0
                ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json"))
                : "";
    }

    // Internal read-only functions
    // ---------------------------------------------------------------

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function _mintLeft(uint256 quantity) internal view virtual returns (bool) {
        if (isMintActive) return totalSupply() + quantity <= collectionSize;
        return totalSupply() + quantity <= collectionSize - (reservedFreeMint - numFreeMint);
    }

    // Owner only administration functions
    // ---------------------------------------------------------------

    function setFreeMintActive(bool _isFreeMintActive) external onlyOwner {
        isFreeMintActive = _isFreeMintActive;
    }

    function setAllowlistMintActive(bool _isAllowlistMintActive) external onlyOwner {
        isAllowlistMintActive = _isAllowlistMintActive;
    }

    function setMintActive(bool _isMintActive) external onlyOwner {
        isMintActive = _isMintActive;
    }

    function setMintPrice(uint256 _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }

    function setAllowlistMintPrice(uint256 _allowlistMintPrice) external onlyOwner {
        allowlistMintPrice = _allowlistMintPrice;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function setFreeMintMerkleRoot(bytes32 merkleRoot) external onlyOwner {
        freeMintMerkleRoot = merkleRoot;
    }

    function setAllowlistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
        allowlistMerkleRoot = merkleRoot;
    }

    function setDefaultRoyalty(address _devAddress, uint96 feeNumerator) external onlyOwner {
        _setDefaultRoyalty(_devAddress, feeNumerator);
    }

    function setOperatorFilteringEnabled(bool value) public onlyOwner {
        operatorFilteringEnabled = value;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function withdrawTokens(IERC20 token) external onlyOwner nonReentrant {
        token.transfer(msg.sender, (token.balanceOf(address(this))));
    }

    function ownerMint(uint256 quantity) external onlyOwner
        supplyLeft(quantity){
        _safeMint(msg.sender, quantity);
    }

    // ClosedSea functions
    // ---------------------------------------------------------------

    function setApprovalForAll(address operator, bool approved)
        public
        override (IERC721A, ERC721A)
        onlyAllowedOperatorApproval(operator)
    {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId)
        public
        payable
        override (IERC721A, ERC721A)
        onlyAllowedOperatorApproval(operator)
    {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId)
        public
        payable
        override (IERC721A, ERC721A)
        onlyAllowedOperator(from)
    {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId)
        public
        payable
        override (IERC721A, ERC721A)
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
        public
        payable
        override (IERC721A, ERC721A)
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override (IERC721A, ERC721A, ERC2981)
        returns (bool)
    {
        // Supports the following `interfaceId`s:
        // - IERC165: 0x01ffc9a7
        // - IERC721: 0x80ac58cd
        // - IERC721Metadata: 0x5b5e139f
        // - IERC2981: 0x2a55205a
        return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
    }


    function _operatorFilteringEnabled() internal view override returns (bool) {
        return operatorFilteringEnabled;
    }

    function _isPriorityOperator(address operator) internal pure override returns (bool) {
        // OpenSea Seaport Conduit:
        // https://etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
        // https://goerli.etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
        return operator == address(0x1E0049783F008A0085193E00003D00cd54003c71);
    }

}
