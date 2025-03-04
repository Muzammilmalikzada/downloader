// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

// _______/\\\\\_______/\\\\\\\\\\\\\____/\\\\\\\\\\\\\\\__/\\\\\_____/\\\_____/\\\\\\\\\\__
//  _____/\\\///\\\____\/\\\/////////\\\_\/\\\///////////__\/\\\\\\___\/\\\___/\\\///////\\\_
//   ___/\\\/__\///\\\__\/\\\_______\/\\\_\/\\\_____________\/\\\/\\\__\/\\\__\///______/\\\__
//    __/\\\______\//\\\_\/\\\\\\\\\\\\\/__\/\\\\\\\\\\\_____\/\\\//\\\_\/\\\_________/\\\//___
//     _\/\\\_______\/\\\_\/\\\/////////____\/\\\///////______\/\\\\//\\\\/\\\________\////\\\__
//      _\//\\\______/\\\__\/\\\_____________\/\\\_____________\/\\\_\//\\\/\\\___________\//\\\_
//       __\///\\\__/\\\____\/\\\_____________\/\\\_____________\/\\\__\//\\\\\\__/\\\______/\\\__
//        ____\///\\\\\/_____\/\\\_____________\/\\\\\\\\\\\\\\\_\/\\\___\//\\\\\_\///\\\\\\\\\/___
//         ______\/////_______\///______________\///////////////__\///_____\/////____\/////////_____

import "./ERC721A.sol";

import "./Ownable.sol";
import "./ReentrancyGuard.sol";

import "./Address.sol";
import "./ECDSA.sol";

/**
 * @title DownBadDegen ERC721A Smart Contract
 */

contract DownBadDegen is Ownable, ReentrancyGuard, ERC721A {
    constructor(address authorizerAddress_, address distributorAddress_)
        ERC721A("Down Bad Degen", "DBD")
    {
        authorizerAddress = authorizerAddress_;
        distributorAddress = distributorAddress_;
    }

    /** MINTING LIMITS **/

    uint256 public constant MINT_LIMIT_PER_ADDRESS = 20;

    uint256 public constant MAX_MULTIMINT = 5;

    mapping(uint256 => bool) public qualifiedNonceList;
    mapping(address => uint256) public qualifiedWalletList;

    /** MINTING **/

    uint256 public constant MAX_SUPPLY = 10_000;

    uint256 public constant PRICE = 0 ether;

    function qualifiedMint(
        uint256 amount_,
        bytes memory signature_,
        uint256 nonce_
    ) external payable nonReentrant {
        require(saleIsActive, "Sale is not active");
        require(
            !qualifiedNonceList[nonce_],
            "You have already minted with this nonce"
        );
        require(
            amount_ <= MAX_MULTIMINT,
            "You went over max tokens per transaction"
        );
        require(
            qualifiedWalletList[msg.sender] + amount_ <= MINT_LIMIT_PER_ADDRESS,
            "You cannot mint anymore"
        );
        require(
            totalSupply() + amount_ <= MAX_SUPPLY,
            "Not enough tokens left to mint that amount"
        );
        require(
            PRICE * amount_ <= msg.value,
            "You sent incorrect amount of ETH"
        );

        bytes32 hash = keccak256(abi.encodePacked(msg.sender, nonce_));
        bytes32 message = ECDSA.toEthSignedMessageHash(hash);

        require(
            ECDSA.recover(message, signature_) == authorizerAddress,
            "Bad signature"
        );

        qualifiedNonceList[nonce_] = true;
        qualifiedWalletList[msg.sender] += amount_;

        _safeMint(msg.sender, amount_);
    }

    function ownerMint(address address_, uint256 amount_) external onlyOwner {
        require(
            totalSupply() + amount_ <= MAX_SUPPLY,
            "Not enough tokens left to mint that amount"
        );

        _safeMint(address_, amount_);
    }

    /** ACTIVATION **/

    bool public saleIsActive = false;

    address private authorizerAddress;

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function setSaleIsActive(bool saleIsActive_) external onlyOwner {
        saleIsActive = saleIsActive_;
    }

    function authorizer() public view returns (address) {
        return authorizerAddress;
    }

    function setAuthorizerAddress(address address_) external onlyOwner {
        authorizerAddress = address_;
    }

    /** URI HANDLING **/

    string private customContractURI = "";

    function setContractURI(string memory customContractURI_)
        external
        onlyOwner
    {
        customContractURI = customContractURI_;
    }

    function contractURI() public view returns (string memory) {
        return customContractURI;
    }

    string private customBaseURI;

    function setBaseURI(string memory customBaseURI_) external onlyOwner {
        customBaseURI = customBaseURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return customBaseURI;
    }

    /** PAYOUT **/

    address private distributorAddress;

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        Address.sendValue(payable(distributorAddress), balance);
    }

    function distributor() public view returns (address) {
        return distributorAddress;
    }

    function setDistributorAddress(address address_) external onlyOwner {
        distributorAddress = address_;
    }
}
