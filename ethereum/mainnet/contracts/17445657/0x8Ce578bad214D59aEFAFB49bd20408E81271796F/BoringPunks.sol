// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./Ownable.sol";
import "./ReentrancyGuard.sol";
import "./ERC2981.sol";
import "./Counters.sol";
import "./Strings.sol";
import "./ERC165.sol";
import "./UpdatableOperatorFilterer.sol";
import "./RevokableDefaultOperatorFilterer.sol";
import "./ERC721R.sol";

contract BoringPunks is ERC721r, ERC2981, Ownable, ReentrancyGuard, RevokableDefaultOperatorFilterer {
    using Counters for Counters.Counter;
    using Strings for uint256; //allows for uint256var.tostring()

    uint256 public MAX_MINT_PER_WALLET_SALE = 25;
    uint256 public MAX_MINT_PER_TX = 5;
    uint256 public price = 0.0069 ether;

    string private baseURI;
    bool public mintEnabled = false;

    mapping(address => uint256) public users;

    constructor() ERC721r("BoringPunks", "BPUNK", 10_000) {
        _setDefaultRoyalty(0x260aaD1cDbADf492D0EF6a15d534d704B45e4e5b, 690);
    }

    function mintSale(uint256 _amount) public payable {
        require(mintEnabled, "Sale is not enabled");
        require(price * _amount <= msg.value, "Not enough ETH");
        require(_amount <= MAX_MINT_PER_TX, "Too many per TX");
        require(
            users[msg.sender] + _amount <= MAX_MINT_PER_WALLET_SALE,
            "Exceeds max mint limit per wallet");
        users[msg.sender] += _amount;
        _mintRandomly(msg.sender, _amount);
    }

    /// ============ INTERNAL ============
    function _mintRandomly(address to, uint256 amount) internal {
        _mintRandom(to, amount);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /// ============ ONLY OWNER ============
    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function toggleSale() external onlyOwner {
        mintEnabled = !mintEnabled;
    }

    function setMaxMintPerWalletSale(uint256 _limit) external onlyOwner {
        require(MAX_MINT_PER_WALLET_SALE != _limit, "New limit is the same as the existing one");
        MAX_MINT_PER_WALLET_SALE = _limit;
    }

    function setMaxMintPerTx(uint256 _limit) external onlyOwner {
        require(MAX_MINT_PER_TX != _limit, "New limit is the same as the existing one");
        MAX_MINT_PER_TX = _limit;
    }

    function setPrice(uint256 price_) external onlyOwner {
        price = price_;
    }

    function setRoyalty(address wallet, uint96 perc) external onlyOwner {
        _setDefaultRoyalty(wallet, perc);
    }

    function reserve(address to, uint256 tokenId) external onlyOwner {
        require(_ownerOf(tokenId) == address(0), "Token has been minted.");
        _mintAtIndex(to, tokenId);
    }

    function withdraw() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    /// ============ ERC2981 ============
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721r, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {ERC721-_burn}. This override additionally clears the royalty information for the token.
     */
    function _burn(uint256 tokenId) internal virtual override {
        ERC721r._burn(tokenId);
        _resetTokenRoyalty(tokenId);
    }

    /// ============ OPERATOR FILTER REGISTRY ============
    function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
    public
    override
    onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function owner() public view override(UpdatableOperatorFilterer, Ownable) returns (address) {
        return Ownable.owner();
    }
}