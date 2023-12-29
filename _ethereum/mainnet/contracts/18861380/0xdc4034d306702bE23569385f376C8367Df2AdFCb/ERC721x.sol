// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.20;

import "./ERC721.sol";
import "./LockRegistry.sol";

// Initially sourced from https://github.com/OwlOfMoistness/ERC721x/blob/master/contracts/erc721/ERC721x.sol
abstract contract ERC721x is ERC721, LockRegistry {
    /*
    *     bytes4(keccak256('freeId(uint256,address)')) == 0x94d216d6
    *     bytes4(keccak256('isUnlocked(uint256)')) == 0x72abc8b7
    *     bytes4(keccak256('lockCount(uint256)')) == 0x650b00f6
    *     bytes4(keccak256('lockId(uint256)')) == 0x2799cde0
    *     bytes4(keccak256('lockMap(uint256,uint256)')) == 0x2cba8123
    *     bytes4(keccak256('lockMapIndex(uint256,address)')) == 0x09308e5d
    *     bytes4(keccak256('unlockId(uint256)')) == 0x40a9c8df
    *     bytes4(keccak256('approvedContract(address)')) == 0xb1a6505f
    *
    *     => 0x94d216d6 ^ 0x72abc8b7 ^ 0x650b00f6 ^ 0x2799cde0 ^
    *        0x2cba8123 ^ 0x09308e5d ^ 0x40a9c8df ^ 0xb1a6505f == 0x706e8489
    */

    bytes4 private constant _INTERFACE_ID_ERC721x = 0x706e8489;

    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC721) returns (bool) {
        return _interfaceId == _INTERFACE_ID_ERC721x || super.supportsInterface(_interfaceId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public payable virtual override {
        if (!isUnlocked(_tokenId)) revert TokenLock();
        super.transferFrom(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data)
        public
        payable
        virtual
        override
    {
        if (!isUnlocked(_tokenId)) revert TokenLock();
        super.safeTransferFrom(_from, _to, _tokenId, _data);
    }

    // Approved lockers can lock staked NFT to prevent transfers until released from their platform
    function lockId(uint256 _id) external virtual override {
        if (!_exists(_id)) revert TokenDoesNotExist();
        _lockId(_id);
    }

    // Approved lockers must unlock token after unstake to release token hold
    function unlockId(uint256 _id) external virtual override {
        if (!_exists(_id)) revert TokenDoesNotExist();
        _unlockId(_id);
    }

    // If a contract is no longer an approved locker, token holder can eliminate their lock
    function freeId(uint256 _id, address _contract) external virtual override {
        if (!_exists(_id)) revert TokenDoesNotExist();
        _freeId(_id, _contract);
    }
}