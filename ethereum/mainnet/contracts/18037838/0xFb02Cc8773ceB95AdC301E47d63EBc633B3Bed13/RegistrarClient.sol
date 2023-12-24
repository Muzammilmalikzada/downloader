// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "./Context.sol";
import "./Registrar.sol";

interface IRegistrarClient {
  function updateAddresses() external;
}

abstract contract RegistrarClient is Context, IRegistrarClient {

  Registrar internal _registrar;

  constructor(address registrarAddress) {
    require(registrarAddress != address(0), "Invalid address");
    _registrar = Registrar(registrarAddress);
  }

  modifier onlyRegistrar() {
    require(_msgSender() == address(_registrar), "Unauthorized, registrar only");
    _;
  }

  function getRegistrar() external view returns(address) {
    return address(_registrar);
  }

  // All subclasses must implement this function
  function updateAddresses() external override virtual;
}