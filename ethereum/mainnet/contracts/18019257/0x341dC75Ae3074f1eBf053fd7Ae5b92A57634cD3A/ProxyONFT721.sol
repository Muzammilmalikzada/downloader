// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./ERC165Checker.sol";
import "./ONFT721Core.sol";

contract ProxyONFT721 is ONFT721Core, IERC721Receiver {
    using ERC165Checker for address;

    IERC721 public immutable token;

    constructor(uint256 _minGasToTransfer, address _lzEndpoint, address _proxyToken) ONFT721Core(_minGasToTransfer, _lzEndpoint) {
        require(_proxyToken.supportsInterface(type(IERC721).interfaceId), "ProxyONFT721: invalid ERC721 token");
        token = IERC721(_proxyToken);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC721Receiver).interfaceId || super.supportsInterface(interfaceId);
    }

    function _debitFrom(address _from, uint16, bytes memory, uint _tokenId) internal virtual override {
        require(_from == _msgSender(), "ProxyONFT721: owner is not send caller");
        token.safeTransferFrom(_from, address(this), _tokenId);
    }

    // TODO apply same changes from regular ONFT721
    function _creditTo(uint16, address _toAddress, uint _tokenId) internal virtual override {
        token.safeTransferFrom(address(this), _toAddress, _tokenId);
    }

    function onERC721Received(address _operator, address, uint, bytes memory) public virtual override returns (bytes4) {
        // only allow `this` to transfer token from others
        if (_operator != address(this)) return bytes4(0);
        return IERC721Receiver.onERC721Received.selector;
    }
}
