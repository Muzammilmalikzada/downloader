// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

//import "./ERC2981.sol";
import "./Royalty.sol";
import "./IERCCooldown.sol";

/// @title ERCCool
/// @author TresCoolLabs
/// @notice Implement this contract without changes to enable Carbon Removal on your NFT.
/** @dev Inherit from this contract to enable Carbon Removal on your NFT.
 *
 * You must call _transferCooldown() and _mintCooldown() upon receiving funds and minting respectively.
 * NOTE: Call _transferCooldown(msg.value) inside of the 'receive() payable' fallback function in the parent contract.
 */
abstract contract ERCCooldown is IERCCooldown, Royalty {

    /* Variables */

    address constant private TCL_ADDRESS = 0xD4Ee4464630f1AcCC979fc7d86F8a448c44d7Fa4;
    uint16 private _royalty = 0; //1000;
    uint16 private _transferCoolRate = 0; //500;
    uint16 private _mintCoolRate = 0; //500;
    uint16 constant private _rateDenominator = 10000;

    /* Interfaces */

    // @notice Interface Support for ERC2981
    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == type(IERCCooldown).interfaceId;
    }
    /* Cool Rate */

    /// @notice Returns the assigned Transfer Cooldown Rate
    function transferCooldownRate() external view returns(uint16) {
        return _transferCoolRate;
    }

    /// @notice Returns the assigned Mint Cooldown Rate
    function mintCooldownRate() external view returns(uint16) {
        return _mintCoolRate;
    }

    /// @notice Allows adjustment of revenue and Cool Down Rate.
    /// @dev Adjusts _royalty and _coolRate if implemented.
    function _adjustCoolRates(uint16 royalty, uint16 transferCoolRate, uint16 mintCoolRate) internal {
        _assignCoolRates(royalty, transferCoolRate, mintCoolRate);
        if (transferCoolRate > 0 || mintCoolRate > 0) {
            _setupDefaultRoyaltyInfo(address(this), _royalty);
        }
    }

    /// @notice Assigns the secondary sales royalty based on ERC2981 as well as Cool Rate.
    /// @dev Assigns _royalty and _coolRate for revenue calculations.
    function _assignCoolRates(uint16 royalty, uint16 transferCoolRate, uint16 mintCoolRate) private {
        require(royalty >= transferCoolRate, "Royalty cannot be set as less than the Cool Rate");
        require(mintCoolRate <= _rateDenominator, "Mint Cool Rate cannot be set as higher than 100%");
        _transferCoolRate = transferCoolRate;
        _mintCoolRate = mintCoolRate;
        _royalty = royalty;
    }


    /* Cooldown */

    /// @notice Calculates carbon removal share based on grade and royalty values
    /// @dev Share is based on percent of sale, using _transferCoolRate and _royalty
    function _transferCooldownShare(uint256 value) internal view returns(uint256) {
        return (value * _transferCoolRate) / _royalty;
    }

    /// @notice Calculates carbon removal share based on Mint Cool Rate
    /// @dev Share is based on percent of mint, using _mintCoolRate
    function _mintCooldownShare(uint256 value) internal view returns(uint256) {
        return (value * _mintCoolRate) / _rateDenominator;
    }

    /// @notice Call this on a receive() function to trigger a cooldown
    /// @dev Calculates a percent based on _transferCoolRate
    function _transferCooldown(uint256 value) internal {
        uint share = _transferCooldownShare(value);
        if(value > 0) {
            (bool sent,) = payable(TCL_ADDRESS).call{value: share}("");
            require(sent, "Failed to send ETH");
        }
    }

    /// @notice Call this on a mint() function to trigger a cooldown
    /// @dev Calculates a percent based on _mintCoolRate
    function _mintCooldown(uint256 value) internal {
        uint share = _mintCooldownShare(value);
        if(value > 0) {
            (bool sent,) = payable(TCL_ADDRESS).call{value: share}("");
            require(sent, "Failed to send ETH");
        }
    }

}
