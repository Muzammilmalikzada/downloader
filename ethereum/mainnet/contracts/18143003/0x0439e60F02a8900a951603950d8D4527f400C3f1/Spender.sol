pragma solidity ^0.8.0;

import "./Address.sol";
import "./Exports.sol";

contract Spender is ISpender {
    using Address for address;

    IBridge public immutable metabridge;

    /**
     * @dev MetaBridge creates the Spender. Not intended to be called directly.
     */
    constructor() public {
        metabridge = IBridge(msg.sender);
    }

    /**
     * @notice Performs a bridge
     * @param adapter Address of the adapter to be used for the bridge
     * @param data Dynamic data which is passed in to the delegatecall made to the adapter
     */
    function bridge(
        address adapter,
        bytes calldata data
    ) external payable override {
        require(msg.sender == address(metabridge), "FORBIDDEN");
        adapter.functionDelegateCall(data, "ADAPTER_DELEGATECALL_FAILED");
    }
}
