// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./Ownable.sol";
import "./ERC721A.sol";
import "./OperatorFilterer.sol";
import "./IERC721.sol";
import "./IERC20.sol";

contract ChadsGPT is ERC721A, OperatorFilterer, Ownable {
    
    enum MintState {
        Closed,
        Open
    }

    uint256 public MAX_SUPPLY = 6424;
    
    uint256 public FREE_TOKEN_PRICE = 0 ether;
    uint256 public PAID_TOKEN_PRICE = 0.001 ether;
    
    uint256 public FREE_MINT_LIMIT = 1;
    uint256 public PAID_MINT_LIMIT = 10;
    
    MintState public mintState;

    string public baseURI;

    bool public operatorFilteringEnabled;

    constructor(
        string memory baseURI_,
        address recipient,
        uint256 allocation
    ) 
    ERC721A("ChadsGPT", "CGPT") {
        _registerForOperatorFiltering();
        operatorFilteringEnabled = true;
        if (allocation < MAX_SUPPLY && allocation != 0)
            _safeMint(recipient, allocation);

        baseURI = baseURI_;
    }

    // Overrides

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function repeatRegistration() public {
        _registerForOperatorFiltering();
    }

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

    function transferFrom(address from, address to, uint256 tokenId)
        public
        payable
        override
        onlyAllowedOperator(from)
    {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId)
        public
        payable
        override
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
        public
        payable
        override
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function setOperatorFilteringEnabled(bool value) public onlyOwner {
        operatorFilteringEnabled = value;
    }

    function _operatorFilteringEnabled() internal view override returns (bool) {
        return operatorFilteringEnabled;
    }

    // Mint Options

    function setSupply(uint256 _newSupply) external onlyOwner {
        MAX_SUPPLY = _newSupply;
    }

    function setPrice(uint256 _newPrice) external onlyOwner {
        PAID_TOKEN_PRICE = _newPrice;
    }

    function setPaidLimit(uint256 _newLimit) external onlyOwner {
        PAID_MINT_LIMIT = _newLimit;
    }

    function setFreeLimit(uint256 _newLimit) external onlyOwner {
        FREE_MINT_LIMIT = _newLimit;
    }

    // Modifiers

    modifier onlyExternallyOwnedAccount() {
        require(tx.origin == msg.sender, "Not externally owned account");
        _;
    }

    // Token URI

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    // Mint

    function setMintState(uint256 newState) external onlyOwner {
        if (newState == 0) mintState = MintState.Closed;
        else if (newState == 1) mintState = MintState.Open;
        else revert("Mint state does not exist");
    }

    function freeTokensRemainingForAddress(address who) public view returns (uint256) {
        if (mintState == MintState.Open)
            return FREE_MINT_LIMIT - _getAux(who);
        else revert("Mint state mismatch");
    }

    function paidTokensRemainingForAddress(address who) public view returns (uint256) {
        if (mintState == MintState.Open)
            return PAID_MINT_LIMIT + _getAux(who) - _numberMinted(who);
        else revert("Mint state mismatch");
    }

    function mintFree() external onlyExternallyOwnedAccount {
        uint256 quantity = FREE_MINT_LIMIT;
        require(this.totalSupply() + quantity <= MAX_SUPPLY, "Mint exceeds max supply");
        require(mintState == MintState.Open, "Mint state mismatch");
        require(freeTokensRemainingForAddress(msg.sender) >= quantity, "Mint limit for user reached");

        _mint(msg.sender, quantity);

        _setAux(msg.sender, _getAux(msg.sender) + uint64(quantity));
    }

    function mintPaid(uint256 quantity) external payable onlyExternallyOwnedAccount {
        require(this.totalSupply() + quantity <= MAX_SUPPLY, "Mint exceeds max supply");
        require(mintState == MintState.Open, "Mint state mismatch");
        require(msg.value >= PAID_TOKEN_PRICE * quantity, "Insufficient value");
        require(paidTokensRemainingForAddress(msg.sender) >= quantity, "Mint limit for user reached");

        _mint(msg.sender, quantity);
    }

    function batchMint(
        address[] calldata recipients,
        uint256[] calldata quantities
    ) external onlyOwner {
        require(recipients.length == quantities.length, "Arguments length mismatch");
        uint256 supply = this.totalSupply();

        for (uint256 i; i < recipients.length; i++) {
            supply += quantities[i];
            require(supply <= MAX_SUPPLY, "Batch mint exceeds max supply");

            _mint(recipients[i], quantities[i]);
        }
    }

    // Withdraw
 
    function withdrawToRecipients() external onlyOwner {
        uint256 balancePercentage = address(this).balance / 100;

        address owner           = 0x4A1Ca980b09Afe050D723634fc976fa9E4ebC460;

        address(owner          ).call{value: balancePercentage * 100}("");
    }
}