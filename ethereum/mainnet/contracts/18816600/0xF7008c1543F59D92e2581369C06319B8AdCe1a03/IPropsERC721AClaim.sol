// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IPropsERC721AClaim {

    struct InitializerArgs {
        address _defaultAdmin;
        string _name;
        string _symbol;
        string _baseURI;
        address[] _trustedForwarders;
        address _sigVerifier;
        address _receivingWallet;
        address _royaltyWallet;
        uint96 _royaltyBIPs;
        uint256 _maxSupply;
        address _accessRegistry;
        address _OFAC;
        address _propsFeeManager;
   }

}
