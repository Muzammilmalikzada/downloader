// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.9.0;

/* Library Imports */
import "./Lib_OVMCodec.sol";
import "./IChainStorageContainer.sol";

/**
 * @title IStateCommitmentChain
 */
interface IStateCommitmentChain {
    /**********
     * Events *
     **********/

    event StateBatchAppended(
        uint256 _chainId,
        uint256 indexed _batchIndex,
        bytes32 _batchRoot,
        uint256 _batchSize,
        uint256 _prevTotalElements,
        bytes _extraData
    );

    event StateBatchDeleted(
        uint256 _chainId,
        uint256 indexed _batchIndex,
        bytes32 _batchRoot
    );


    /********************
     * Public Functions *
     ********************/
    
    function batches() external view returns (IChainStorageContainer);
    
    /**
     * Retrieves the total number of elements submitted.
     * @return _totalElements Total submitted elements.
     */
    function getTotalElements() external view returns (uint256 _totalElements);

    /**
     * Retrieves the total number of batches submitted.
     * @return _totalBatches Total submitted batches.
     */
    function getTotalBatches() external view returns (uint256 _totalBatches);

    /**
     * Retrieves the timestamp of the last batch submitted by the sequencer.
     * @return _lastSequencerTimestamp Last sequencer batch timestamp.
     */
    function getLastSequencerTimestamp() external view returns (uint256 _lastSequencerTimestamp);

    /**
     * Appends a batch of state roots to the chain.
     * @param _batch Batch of state roots.
     * @param _shouldStartAtElement Index of the element at which this batch should start.
     */
    function appendStateBatch(bytes32[] calldata _batch, uint256 _shouldStartAtElement) external;

    /**
     * Deletes all state roots after (and including) a given batch.
     * @param _batchHeader Header of the batch to start deleting from.
     */
    function deleteStateBatch(Lib_OVMCodec.ChainBatchHeader memory _batchHeader) external;

    /**
     * Verifies a batch inclusion proof.
     * @param _element Hash of the element to verify a proof for.
     * @param _batchHeader Header of the batch in which the element was included.
     * @param _proof Merkle inclusion proof for the element.
     */
    function verifyStateCommitment(
        bytes32 _element,
        Lib_OVMCodec.ChainBatchHeader memory _batchHeader,
        Lib_OVMCodec.ChainInclusionProof memory _proof
    ) external view returns (bool _verified);

    /**
     * Checks whether a given batch is still inside its fraud proof window.
     * @param _batchHeader Header of the batch to check.
     * @return _inside Whether or not the batch is inside the fraud proof window.
     */
    function insideFraudProofWindow(Lib_OVMCodec.ChainBatchHeader memory _batchHeader)
        external
        view
        returns (
            bool _inside
        );
        
        
        
     /********************
     * chain id added func *
     ********************/

    /**
     * Retrieves the total number of elements submitted.
     * @param _chainId identity for the l2 chain.
     * @return _totalElements Total submitted elements.
     */
    function getTotalElementsByChainId(uint256 _chainId)
        external
        view
        returns (
            uint256 _totalElements
        );

    /**
     * Retrieves the total number of batches submitted.
     * @param _chainId identity for the l2 chain.
     * @return _totalBatches Total submitted batches.
     */
    function getTotalBatchesByChainId(uint256 _chainId)
        external
        view
        returns (
            uint256 _totalBatches
        );

    /**
     * Retrieves the timestamp of the last batch submitted by the sequencer.
     * @param _chainId identity for the l2 chain.
     * @return _lastSequencerTimestamp Last sequencer batch timestamp.
     */
    function getLastSequencerTimestampByChainId(uint256 _chainId)
        external
        view
        returns (
            uint256 _lastSequencerTimestamp
        );
        
    /**
     * Appends a batch of state roots to the chain.
     * @param _chainId identity for the l2 chain.
     * @param _batch Batch of state roots.
     * @param _shouldStartAtElement Index of the element at which this batch should start.
     */
    function appendStateBatchByChainId(
        uint256 _chainId,
        bytes32[] calldata _batch,
        uint256 _shouldStartAtElement,
        string calldata proposer
    )
        external;

    /**
     * Deletes all state roots after (and including) a given batch.
     * @param _chainId identity for the l2 chain.
     * @param _batchHeader Header of the batch to start deleting from.
     */
    function deleteStateBatchByChainId(
        uint256 _chainId,
        Lib_OVMCodec.ChainBatchHeader memory _batchHeader
    )
        external;

    /**
     * Verifies a batch inclusion proof.
     * @param _chainId identity for the l2 chain.
     * @param _element Hash of the element to verify a proof for.
     * @param _batchHeader Header of the batch in which the element was included.
     * @param _proof Merkle inclusion proof for the element.
     */
    function verifyStateCommitmentByChainId(
        uint256 _chainId,
        bytes32 _element,
        Lib_OVMCodec.ChainBatchHeader memory _batchHeader,
        Lib_OVMCodec.ChainInclusionProof memory _proof
    )
        external
        view
        returns (
            bool _verified
        );

    /**
     * Checks whether a given batch is still inside its fraud proof window.
     * @param _chainId identity for the l2 chain.
     * @param _batchHeader Header of the batch to check.
     * @return _inside Whether or not the batch is inside the fraud proof window.
     */
    function insideFraudProofWindowByChainId(
        uint256 _chainId,
        Lib_OVMCodec.ChainBatchHeader memory _batchHeader
    )
        external
        view
        returns (
            bool _inside
        );
}
