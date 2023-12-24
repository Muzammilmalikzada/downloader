// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.18;

import "./AddressUpgradeable.sol";

struct CallWithoutValue {
  address target;
  bytes callData;
}

error AddressLibrary_Proxy_Call_Did_Not_Return_A_Contract(address addressReturned);

/**
 * @title A library for address helpers not already covered by the OZ library.
 * @author batu-inal & HardlyDifficult
 */
library AddressLibrary {
  using AddressUpgradeable for address;
  using AddressUpgradeable for address payable;

  /**
   * @notice Calls an external contract with arbitrary data and parse the return value into an address.
   * @param externalContract The address of the contract to call.
   * @param callData The data to send to the contract.
   * @return contractAddress The address of the contract returned by the call.
   */
  function callAndReturnContractAddress(
    address externalContract,
    bytes calldata callData
  ) internal returns (address payable contractAddress) {
    bytes memory returnData = externalContract.functionCall(callData);
    contractAddress = abi.decode(returnData, (address));
    if (!contractAddress.isContract()) {
      revert AddressLibrary_Proxy_Call_Did_Not_Return_A_Contract(contractAddress);
    }
  }

  function callAndReturnContractAddress(
    CallWithoutValue calldata call
  ) internal returns (address payable contractAddress) {
    contractAddress = callAndReturnContractAddress(call.target, call.callData);
  }
}
