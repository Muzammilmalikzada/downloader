// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "./ERC721AQueryable.sol";
import "./ERC721ABurnable.sol";
import "./ERC721A.sol";
import "./Ownable.sol";
import "./draft-EIP712.sol";

contract DininhoAdventures is ERC721AQueryable, ERC721ABurnable, EIP712, Ownable {
    uint public maxSupply = 6000;
    uint public maxWhitelistSupply = 3000;
    uint public normalMintPrice = 0.069 ether;
    uint public whitelistMintPrice = 0.059 ether;
    uint public maxNormalMintPerAccount = 3;
    uint public maxWhitelistMintPerAccount = 2;
    uint public publicSalesTimestamp = 1660496400;
    uint public whitelistSalesTimestamp = 1660489200;

    mapping(address => uint) private _totalNormalMintPerAccount;
    mapping(address => uint) private _totalWhitelistMintPerAccount;
    address private _signerPublicKey = 0x47ED00833d3e4735a0f9A83AD8Eb795F3ECDa0E6;
    string private _contractUri;
    string private _baseUri;

    constructor() ERC721A("Dininho Adventures", "DA") EIP712("Dininho Adventures", "1.0.0") {
    }

    function mint(uint amount) external payable {
        require(totalSupply() < maxSupply, "sold out");
        require(isPublicSalesActive(), "sales is not active");
        require(amount > 0, "invalid amount");
        require(msg.value >= amount * normalMintPrice, "invalid mint price");
        require(amount + totalSupply() <= maxSupply, "amount exceeds max supply");
        require(amount + _totalNormalMintPerAccount[msg.sender] <= maxNormalMintPerAccount, "max tokens per account reached");

        _totalNormalMintPerAccount[msg.sender] += amount;
        _safeMint(msg.sender, amount);
    }

    function whitelistMint(uint amount, bytes calldata signature) external payable {
        require(totalSupply() < maxWhitelistSupply, "whitelist mint reached max supply");
        require(_recoverAddress(msg.sender, signature) == _signerPublicKey, "account is not whitelisted");
        require(isWhitelistSalesActive(), "sales is not active");
        require(amount > 0, "invalid amount");
        require(msg.value >= amount * whitelistMintPrice, "invalid mint price");
        require(amount + totalSupply() <= maxWhitelistSupply, "amount exceeds max supply");
        require(amount + _totalWhitelistMintPerAccount[msg.sender] <= maxWhitelistMintPerAccount, "max tokens per account reached");

        _totalWhitelistMintPerAccount[msg.sender] += amount;
        _safeMint(msg.sender, amount);
    }

    function isPublicSalesActive() public view returns (bool) {
        return publicSalesTimestamp <= block.timestamp;
    }

    function isWhitelistSalesActive() public view returns (bool) {
        return whitelistSalesTimestamp <= block.timestamp;
    }

    function hasMintedUsingWhitelist(address account) public view returns (bool) {
        return _totalWhitelistMintPerAccount[account] >= maxWhitelistMintPerAccount;
    }

    function totalNormalMintPerAccount(address account) public view returns (uint) {
        return _totalNormalMintPerAccount[account];
    }

    function totalWhitelistMintPerAccount(address account) public view returns (uint) {
        return _totalWhitelistMintPerAccount[account];
    }

    function contractURI() external view returns (string memory) {
        return _contractUri;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseUri;
    }

    function setContractURI(string memory contractURI_) external onlyOwner {
        _contractUri = contractURI_;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseUri = baseURI_;
    }

    function setSignerPublicKey(address signerPublicKey_) external onlyOwner {
        _signerPublicKey = signerPublicKey_;
    }

    function setMaxSupply(uint maxSupply_) external onlyOwner {
        maxSupply = maxSupply_;
    }

    function setMaxWhitelistSupply(uint maxWhitelistSupply_) external onlyOwner {
        maxWhitelistSupply = maxWhitelistSupply_;
    }

    function setNormalMintPrice(uint normalMintPrice_) external onlyOwner {
        normalMintPrice = normalMintPrice_;
    }

    function setWhitelistMintPrice(uint whitelistMintPrice_) external onlyOwner {
        whitelistMintPrice = whitelistMintPrice_;
    }

    function setMaxNormalMintPerAccount(uint maxNormalMintPerAccount_) external onlyOwner {
        maxNormalMintPerAccount = maxNormalMintPerAccount_;
    }

    function setMaxWhitelistMintPerAccount(uint maxWhitelistMintPerAccount_) external onlyOwner {
        maxWhitelistMintPerAccount = maxWhitelistMintPerAccount_;
    }

    function setPublicSalesTimestamp(uint timestamp) external onlyOwner {
        publicSalesTimestamp = timestamp;
    }

    function setWhitelistSalesTimestamp(uint timestamp) external onlyOwner {
        whitelistSalesTimestamp = timestamp;
    }

    function withdrawAll() external onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }

    function _hash(address account) private view returns (bytes32) {
        return _hashTypedDataV4(
            keccak256(
                abi.encode(
                    keccak256("DininhoAdventures(address account)"),
                    account
                )
            )
        );
    }

    function _recoverAddress(address account, bytes calldata signature) private view returns (address) {
        return ECDSA.recover(_hash(account), signature);
    }
}
