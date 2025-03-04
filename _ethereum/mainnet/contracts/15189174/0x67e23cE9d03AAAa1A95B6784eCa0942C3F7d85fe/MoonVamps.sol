// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./Blood.sol";
import "./ERC721A.sol";
import "./Owned.sol";
import "./ERC721AQueryable.sol";

contract MoonVamps is ERC721A, ERC721AQueryable, Owned {
  uint256 constant BLOOD_PRICE = 60;
  uint256 constant BASE_PRICE = 0.01 ether;
  uint256 constant MAX_SUPPLY_PLUS_ONE = 2501;

  string tokenBaseUri =
    "ipfs://QmR4ebWUp9sWBATRxS5KCeAfhKjX2gG5GvoyK1ZYeznwbu/?";

  bool public paused = true;

  Blood private immutable bloodContract;

  constructor(address _bloodAddress)
    ERC721A("Moon Vamps", "MV")
    Owned(msg.sender)
  {
    bloodContract = Blood(_bloodAddress);
  }

  // Rename mint function to optimize gas
  function mint_540(uint256 _quantity) external payable {
    unchecked {
      require(!paused, "MINTING PAUSED");

      uint256 _bloodBalance = bloodContract.balanceOf(msg.sender);

      require(_bloodBalance > 0, "NOT ENOUGH $BLOOD");

      uint256 _totalSupply = totalSupply();

      require(
        _totalSupply + _quantity < MAX_SUPPLY_PLUS_ONE,
        "MAX SUPPLY REACHED"
      );

      uint256 _payableAmount = getPayableAmount(msg.sender, _quantity);

      require(msg.value == _payableAmount, "INCORRECT ETH AMOUNT");

      uint256 _bloodAmount = _bloodBalance;

      if (BLOOD_PRICE * _quantity < _bloodBalance) {
        _bloodAmount = BLOOD_PRICE * _quantity;
      }

      bloodContract.transferFrom(msg.sender, address(0), _bloodAmount);

      _mint(msg.sender, _quantity);
    }
  }

  function getPayableAmount(address _wallet, uint256 _quantity)
    public
    view
    returns (uint256)
  {
    uint256 _bloodBalance = bloodContract.balanceOf(_wallet);
    uint256 _remainder = 0;
    uint256 _paidMintCount = _quantity;

    if (_quantity * BLOOD_PRICE <= _bloodBalance) {
      return 0;
    }

    if (_bloodBalance >= BLOOD_PRICE) {
      _remainder = _bloodBalance % BLOOD_PRICE;
      _paidMintCount = _quantity - (_bloodBalance / BLOOD_PRICE);
    } else {
      _remainder = _bloodBalance;
    }

    uint256 _discount = (_remainder * 100) / BLOOD_PRICE;
    uint256 _extraFree = 1;

    if (_remainder == 0) {
      _extraFree = 0;
    }

    require(_paidMintCount - _extraFree < 1, "NOT ENOUGH $BLOOD FOR QUANTITY");

    return (BASE_PRICE - (_discount * BASE_PRICE) / 100);
  }

  function _startTokenId() internal pure override returns (uint256) {
    return 1;
  }

  function _baseURI() internal view override returns (string memory) {
    return tokenBaseUri;
  }

  function setBaseURI(string calldata _newBaseUri) external onlyOwner {
    tokenBaseUri = _newBaseUri;
  }

  function flipSale() external onlyOwner {
    paused = !paused;
  }

  function collectReserves() external onlyOwner {
    require(totalSupply() == 0, "RESERVES TAKEN");

    _mint(msg.sender, 1);
  }

  function withdraw() external onlyOwner {
    require(payable(owner).send(address(this).balance), "UNSUCCESSFUL");
  }
}
