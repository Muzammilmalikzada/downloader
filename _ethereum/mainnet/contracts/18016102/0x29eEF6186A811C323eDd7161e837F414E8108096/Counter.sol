// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

// import "./IFunctionGateway.sol";
// import "./OutputReader.sol";

interface IFunctionGateway {
    function request(
        bytes32 functionId,
        bytes memory inputs,
        bytes4 select,
        bytes memory context
    ) external payable;
}

contract SimpleCircuit {
    uint256 public nextRequestId = 1;
    address public constant FUNCTION_GATEWAY =
        0x852a94F8309D445D27222eDb1E92A4E83DdDd2a8;
    bytes32 public constant FUNCTION_ID =
        0x681c649b3d50c16020955254da52a7f5b356df9dc434f1020af22e8e38e960a9;

    event CallbackReceived(uint256 requestId, uint32 a_plus_b);

    // TODO: replace this with the Succinct library
    function readUint32(bytes memory _output) internal pure returns (uint32) {
        uint32 value;
        assembly {
            value := mload(add(_output, 0x04))
        }
        return value;
    }

    function requestAddition(uint32 a, uint32 b) external payable {
        require(msg.value >= 30 gwei * 1_000_000); // 1_000_000 is the default gas limit
        IFunctionGateway(FUNCTION_GATEWAY).request{value: msg.value}(
            FUNCTION_ID,
            abi.encodePacked(a, b),
            this.handleCallback.selector,
            abi.encode(nextRequestId)
        );
        nextRequestId++;
    }

    function handleCallback(
        bytes memory output,
        bytes memory context
    ) external {
        require(msg.sender == FUNCTION_GATEWAY);
        uint256 requestId = abi.decode(context, (uint256));
        uint32 a_plus_b = readUint32(output);
        emit CallbackReceived(requestId, a_plus_b);
    }
}
