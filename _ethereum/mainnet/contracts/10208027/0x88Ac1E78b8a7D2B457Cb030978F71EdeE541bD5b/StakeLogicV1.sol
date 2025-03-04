/**
 *Submitted for verification at Etherscan.io on 2020-06-05
*/

// File: contracts/common/Validating.sol

pragma solidity 0.5.12;


interface Validating {
  modifier notZero(uint number) { require(number > 0, "invalid 0 value"); _; }
  modifier notEmpty(string memory text) { require(bytes(text).length > 0, "invalid empty string"); _; }
  modifier validAddress(address value) { require(value != address(0x0), "invalid address"); _; }
}

// File: contracts/external/BytesLib.sol

/*
 * @title Solidity Bytes Arrays Utils
 * @author Gonçalo Sá <goncalo.sa@consensys.net>
 *
 * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
 *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
 */

pragma solidity 0.5.12;


library BytesLib {
    function concat(
        bytes memory _preBytes,
        bytes memory _postBytes
    )
        internal
        pure
        returns (bytes memory)
    {
        bytes memory tempBytes;

        assembly {
            // Get a location of some free memory and store it in tempBytes as
            // Solidity does for memory variables.
            tempBytes := mload(0x40)

            // Store the length of the first bytes array at the beginning of
            // the memory for tempBytes.
            let length := mload(_preBytes)
            mstore(tempBytes, length)

            // Maintain a memory counter for the current write location in the
            // temp bytes array by adding the 32 bytes for the array length to
            // the starting location.
            let mc := add(tempBytes, 0x20)
            // Stop copying when the memory counter reaches the length of the
            // first bytes array.
            let end := add(mc, length)

            for {
                // Initialize a copy counter to the start of the _preBytes data,
                // 32 bytes into its memory.
                let cc := add(_preBytes, 0x20)
            } lt(mc, end) {
                // Increase both counters by 32 bytes each iteration.
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                // Write the _preBytes data into the tempBytes memory 32 bytes
                // at a time.
                mstore(mc, mload(cc))
            }

            // Add the length of _postBytes to the current length of tempBytes
            // and store it as the new length in the first 32 bytes of the
            // tempBytes memory.
            length := mload(_postBytes)
            mstore(tempBytes, add(length, mload(tempBytes)))

            // Move the memory counter back from a multiple of 0x20 to the
            // actual end of the _preBytes data.
            mc := end
            // Stop copying when the memory counter reaches the new combined
            // length of the arrays.
            end := add(mc, length)

            for {
                let cc := add(_postBytes, 0x20)
            } lt(mc, end) {
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                mstore(mc, mload(cc))
            }

            // Update the free-memory pointer by padding our last write location
            // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
            // next 32 byte block, then round down to the nearest multiple of
            // 32. If the sum of the length of the two arrays is zero then add
            // one before rounding down to leave a blank 32 bytes (the length block with 0).
            mstore(0x40, and(
              add(add(end, iszero(add(length, mload(_preBytes)))), 31),
              not(31) // Round down to the nearest 32 bytes.
            ))
        }

        return tempBytes;
    }

    function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
        assembly {
            // Read the first 32 bytes of _preBytes storage, which is the length
            // of the array. (We don't need to use the offset into the slot
            // because arrays use the entire slot.)
            let fslot := sload(_preBytes_slot)
            // Arrays of 31 bytes or less have an even value in their slot,
            // while longer arrays have an odd value. The actual length is
            // the slot divided by two for odd values, and the lowest order
            // byte divided by two for even values.
            // If the slot is even, bitwise and the slot with 255 and divide by
            // two to get the length. If the slot is odd, bitwise and the slot
            // with -1 and divide by two.
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)
            let newlength := add(slength, mlength)
            // slength can contain both the length and contents of the array
            // if length < 32 bytes so let's prepare for that
            // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
            switch add(lt(slength, 32), lt(newlength, 32))
            case 2 {
                // Since the new array still fits in the slot, we just need to
                // update the contents of the slot.
                // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
                sstore(
                    _preBytes_slot,
                    // all the modifications to the slot are inside this
                    // next block
                    add(
                        // we can just add to the slot contents because the
                        // bytes we want to change are the LSBs
                        fslot,
                        add(
                            mul(
                                div(
                                    // load the bytes from memory
                                    mload(add(_postBytes, 0x20)),
                                    // zero all bytes to the right
                                    exp(0x100, sub(32, mlength))
                                ),
                                // and now shift left the number of bytes to
                                // leave space for the length in the slot
                                exp(0x100, sub(32, newlength))
                            ),
                            // increase length by the double of the memory
                            // bytes length
                            mul(mlength, 2)
                        )
                    )
                )
            }
            case 1 {
                // The stored value fits in the slot, but the combined value
                // will exceed it.
                // get the keccak hash to get the contents of the array
                mstore(0x0, _preBytes_slot)
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                // save new length
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                // The contents of the _postBytes array start 32 bytes into
                // the structure. Our first read should obtain the `submod`
                // bytes that can fit into the unused space in the last word
                // of the stored array. To get this, we read 32 bytes starting
                // from `submod`, so the data we read overlaps with the array
                // contents by `submod` bytes. Masking the lowest-order
                // `submod` bytes allows us to add that value directly to the
                // stored value.

                let submod := sub(32, slength)
                let mc := add(_postBytes, submod)
                let end := add(_postBytes, mlength)
                let mask := sub(exp(0x100, submod), 1)

                sstore(
                    sc,
                    add(
                        and(
                            fslot,
                            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
                        ),
                        and(mload(mc), mask)
                    )
                )

                for {
                    mc := add(mc, 0x20)
                    sc := add(sc, 1)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } {
                    sstore(sc, mload(mc))
                }

                mask := exp(0x100, sub(mc, end))

                sstore(sc, mul(div(mload(mc), mask), mask))
            }
            default {
                // get the keccak hash to get the contents of the array
                mstore(0x0, _preBytes_slot)
                // Start copying to the last used word of the stored array.
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                // save new length
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                // Copy over the first `submod` bytes of the new data as in
                // case 1 above.
                let slengthmod := mod(slength, 32)
                let mlengthmod := mod(mlength, 32)
                let submod := sub(32, slengthmod)
                let mc := add(_postBytes, submod)
                let end := add(_postBytes, mlength)
                let mask := sub(exp(0x100, submod), 1)

                sstore(sc, add(sload(sc), and(mload(mc), mask)))

                for {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } {
                    sstore(sc, mload(mc))
                }

                mask := exp(0x100, sub(mc, end))

                sstore(sc, mul(div(mload(mc), mask), mask))
            }
        }
    }

    function slice(
        bytes memory _bytes,
        uint _start,
        uint _length
    ) internal pure returns (bytes memory)
    {
        require(_bytes.length >= (_start + _length));

        bytes memory tempBytes;

        assembly {
            switch iszero(_length)
            case 0 {
            // Get a location of some free memory and store it in tempBytes as
            // Solidity does for memory variables.
                tempBytes := mload(0x40)

            // The first word of the slice result is potentially a partial
            // word read from the original array. To read it, we calculate
            // the length of that partial word and start copying that many
            // bytes into the array. The first word we copy will start with
            // data we don't care about, but the last `lengthmod` bytes will
            // land at the beginning of the contents of the new array. When
            // we're done copying, we overwrite the full first word with
            // the actual length of the slice.
                let lengthmod := and(_length, 31)

            // The multiplication in the next line is necessary
            // because when slicing multiples of 32 bytes (lengthmod == 0)
            // the following copy loop was copying the origin's length
            // and then ending prematurely not copying everything it should.
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)

                for {
                // The multiplication in the next line has the same exact purpose
                // as the one above.
                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
                } lt(mc, end) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    mstore(mc, mload(cc))
                }

                mstore(tempBytes, _length)

            // update free-memory pointer
            // allocating the array padded to 32 bytes like the compiler does now
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            // if we want a zero-length slice let's just return a zero-length array
            default {
                tempBytes := mload(0x40)

                mstore(0x40, add(tempBytes, 0x20))
            }
        }

        return tempBytes;
    }

    function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
        require(_bytes.length >= (_start + 20));
        address tempAddress;
        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
        }
        return tempAddress;
    }

    function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
        require(_bytes.length >= (_start + 1));
        uint8 tempUint;
        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }
        return tempUint;
    }

    function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
        require(_bytes.length >= (_start + 2));
        uint16 tempUint;
        assembly {
            tempUint := mload(add(add(_bytes, 0x2), _start))
        }
        return tempUint;
    }

    function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
        require(_bytes.length >= (_start + 4));
        uint32 tempUint;
        assembly {
            tempUint := mload(add(add(_bytes, 0x4), _start))
        }
        return tempUint;
    }

    function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
        require(_bytes.length >= (_start + 8));
        uint64 tempUint;
        assembly {
            tempUint := mload(add(add(_bytes, 0x8), _start))
        }
        return tempUint;
    }

    function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
        require(_bytes.length >= (_start + 12));
        uint96 tempUint;
        assembly {
            tempUint := mload(add(add(_bytes, 0xc), _start))
        }
        return tempUint;
    }

    function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
        require(_bytes.length >= (_start + 16));
        uint128 tempUint;
        assembly {
            tempUint := mload(add(add(_bytes, 0x10), _start))
        }
        return tempUint;
    }

    function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
        require(_bytes.length >= (_start + 32));
        uint256 tempUint;
        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }
        return tempUint;
    }

    function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
        require(_bytes.length >= (_start + 32));
        bytes32 tempBytes32;
        assembly {
            tempBytes32 := mload(add(add(_bytes, 0x20), _start))
        }
        return tempBytes32;
    }

    function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
        bool success = true;

        assembly {
            let length := mload(_preBytes)

            // if lengths don't match the arrays are not equal
            switch eq(length, mload(_postBytes))
            case 1 {
                // cb is a circuit breaker in the for loop since there's
                //  no said feature for inline assembly loops
                // cb = 1 - don't breaker
                // cb = 0 - break
                let cb := 1

                let mc := add(_preBytes, 0x20)
                let end := add(mc, length)

                for {
                    let cc := add(_postBytes, 0x20)
                // the next line is the loop condition:
                // while(uint(mc < end) + cb == 2)
                } eq(add(lt(mc, end), cb), 2) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    // if any of these checks fails then arrays are not equal
                    if iszero(eq(mload(mc), mload(cc))) {
                        // unsuccess:
                        success := 0
                        cb := 0
                    }
                }
            }
            default {
                // unsuccess:
                success := 0
            }
        }

        return success;
    }

    function equalStorage(
        bytes storage _preBytes,
        bytes memory _postBytes
    )
        internal
        view
        returns (bool)
    {
        bool success = true;

        assembly {
            // we know _preBytes_offset is 0
            let fslot := sload(_preBytes_slot)
            // Decode the length of the stored array like in concatStorage().
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)

            // if lengths don't match the arrays are not equal
            switch eq(slength, mlength)
            case 1 {
                // slength can contain both the length and contents of the array
                // if length < 32 bytes so let's prepare for that
                // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
                if iszero(iszero(slength)) {
                    switch lt(slength, 32)
                    case 1 {
                        // blank the last byte which is the length
                        fslot := mul(div(fslot, 0x100), 0x100)

                        if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
                            // unsuccess:
                            success := 0
                        }
                    }
                    default {
                        // cb is a circuit breaker in the for loop since there's
                        //  no said feature for inline assembly loops
                        // cb = 1 - don't breaker
                        // cb = 0 - break
                        let cb := 1

                        // get the keccak hash to get the contents of the array
                        mstore(0x0, _preBytes_slot)
                        let sc := keccak256(0x0, 0x20)

                        let mc := add(_postBytes, 0x20)
                        let end := add(mc, mlength)

                        // the next line is the loop condition:
                        // while(uint(mc < end) + cb == 2)
                        for {} eq(add(lt(mc, end), cb), 2) {
                            sc := add(sc, 1)
                            mc := add(mc, 0x20)
                        } {
                            if iszero(eq(sload(sc), mload(mc))) {
                                // unsuccess:
                                success := 0
                                cb := 0
                            }
                        }
                    }
                }
            }
            default {
                // unsuccess:
                success := 0
            }
        }

        return success;
    }
}

// File: contracts/external/SafeMath.sol

pragma solidity 0.5.12;


/**
 * @title Math provides arithmetic functions for uint type pairs.
 * You can safely `plus`, `minus`, `times`, and `divide` uint numbers without fear of integer overflow.
 * You can also find the `min` and `max` of two numbers.
 */
library SafeMath {

  function min(uint x, uint y) internal pure returns (uint) { return x <= y ? x : y; }
  function max(uint x, uint y) internal pure returns (uint) { return x >= y ? x : y; }


  /** @dev adds two numbers, reverts on overflow */
  function plus(uint x, uint y) internal pure returns (uint z) { require((z = x + y) >= x, "bad addition"); }

  /** @dev subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend) */
  function minus(uint x, uint y) internal pure returns (uint z) { require((z = x - y) <= x, "bad subtraction"); }


  /** @dev multiplies two numbers, reverts on overflow */
  function times(uint x, uint y) internal pure returns (uint z) { require(y == 0 || (z = x * y) / y == x, "bad multiplication"); }

  /** @dev divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero */
  function mod(uint x, uint y) internal pure returns (uint z) {
    require(y != 0, "bad modulo; using 0 as divisor");
    z = x % y;
  }

  /** @dev Integer division of two numbers truncating the quotient, reverts on division by zero */
  function div(uint a, uint b) internal pure returns (uint c) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
  }

}

// File: contracts/external/Token.sol

pragma solidity 0.5.12;


/*
 * Abstract contract for the full ERC 20 Token standard
 * https://github.com/ethereum/EIPs/issues/20
 */
contract Token {
  /** This is a slight change to the ERC20 base standard.
  function totalSupply() view returns (uint supply);
  is replaced map:
  uint public totalSupply;
  This automatically creates a getter function for the totalSupply.
  This is moved to the base contract since public getter functions are not
  currently recognised as an implementation of the matching abstract
  function by the compiler.
  */
  /// total amount of tokens
  uint public totalSupply;

  /// @param _owner The address from which the balance will be retrieved
  /// @return The balance
  function balanceOf(address _owner) public view returns (uint balance);

  /// @notice send `_value` token to `_to` from `msg.sender`
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transfer(address _to, uint _value) public returns (bool success);

  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
  /// @param _from The address of the sender
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transferFrom(address _from, address _to, uint _value) public returns (bool success);

  /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @param _value The amount of tokens to be approved for transfer
  /// @return Whether the approval was successful or not
  function approve(address _spender, uint _value) public returns (bool success);

  /// @param _owner The address of the account owning tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @return Amount of remaining tokens allowed to spent
  function allowance(address _owner, address _spender) public view returns (uint remaining);

  event Transfer(address indexed _from, address indexed _to, uint _value);
  event Approval(address indexed _owner, address indexed _spender, uint _value);
}

// File: contracts/gluon/AppGovernance.sol

pragma solidity 0.5.12;


interface AppGovernance {
  function approve(uint32 id) external;
  function disapprove(uint32 id) external;
  function activate(uint32 id) external;
}

// File: contracts/gluon/AppLogic.sol

pragma solidity 0.5.12;


/**
  * @notice representing an app's in-and-out transfers of assets
  * @dev an account/asset based app should implement its own bookkeeping
  */
interface AppLogic {

  /// @notice when an app proposal has been activated, Gluon will call this method on the previously active app version
  /// @dev each app must implement, providing a future upgrade path, and call retire_() at the very end.
  /// this is the chance for the previously active app version to migrate to the new version
  /// i.e.: migrating data, deprecate prior behavior, releasing resources, etc.
  function upgrade() external;

  /// @dev once an asset has been deposited into the app's safe within Gluon, the app is given the chance to do
  /// it's own per account/asset bookkeeping
  ///
  /// @param account any Ethereum address
  /// @param asset any ERC20 token or ETH (represented by address 0x0)
  /// @param quantity quantity of asset
  function credit(address account, address asset, uint quantity) external;

  /// @dev before an asset can be withdrawn from the app's safe within Gluon, the quantity and asset to withdraw must be
  /// derived from `parameters`. if the app is account/asset based, it should take this opportunity to:
  /// - also derive the owning account from `parameters`
  /// - prove that the owning account indeed has the derived quantity of the derived asset
  /// - do it's own per account/asset bookkeeping
  /// notice that the derived account is not necessarily the same as the provided account; a classic usage example is
  /// an account transfers assets across app (in which case the provided account would be the target app)
  ///
  /// @param account any Ethereum address to which `quantity` of `asset` would be transferred to
  /// @param parameters a bytes-marshalled record containing all data needed for the app-specific logic
  /// @return asset any ERC20 token or ETH (represented by address 0x0)
  /// @return quantity quantity of asset
  function debit(address account, bytes calldata parameters) external returns (address asset, uint quantity);
}

// File: contracts/gluon/AppState.sol

pragma solidity 0.5.12;

/**
  * @title representing an app's life-cycle
  * @notice an app's life-cycle starts in the ON state, then it is either move to the final OFF state,
  * or to the RETIRED state when it upgrades itself to its successor version.
  */
contract AppState {

  enum State { OFF, ON, RETIRED }
  State public state = State.ON;
  event Off();
  event Retired();

  /// @notice app must be active (when current)
  modifier whenOn() { require(state == State.ON, "must be on"); _; }

  /// @notice app must be halted
  modifier whenOff() { require(state == State.OFF, "must be off"); _; }

  /// @notice app must be retired (when no longer current, after being upgraded)
  modifier whenRetired() { require(state == State.RETIRED, "must be retired"); _; }

  /// @dev retire the app. this action is irreversible.
  /// called during a normal upgrade operation. by the end of this call the approved proposal would be active.
  function retire_() internal whenOn {
    state = State.RETIRED;
    emit Retired();
  }

  /// @notice halt the app. this action is irreversible.
  /// (the only option at this point is have a proposal that will get to approval, then activated.)
  /// should be called by an app-owner when the app has been compromised.
  function switchOff_() internal whenOn {
    state = State.OFF;
    emit Off();
  }

  /// @notice app state is active, i.e: current & active
  function isOn() external view returns (bool) { return state == State.ON; }

}

// File: contracts/gluon/GluonView.sol

pragma solidity 0.5.12;


interface GluonView {
  function app(uint32 id) external view returns (address current, address proposal, uint activationBlock);
  function current(uint32 id) external view returns (address);
  function history(uint32 id) external view returns (address[] memory);
  function getBalance(uint32 id, address asset) external view returns (uint);
  function isAnyLogic(uint32 id, address logic) external view returns (bool);
  function isAppOwner(uint32 id, address appOwner) external view returns (bool);
  function proposals(address logic) external view returns (bool);
  function totalAppsCount() external view returns(uint32);
}

// File: contracts/gluon/GluonCentric.sol

pragma solidity 0.5.12;



/**
  * @title the essentials of a side-chain app participating in Gluon-Plasma
  * @dev both Logic & Data (if exists) contracts should inherit this contract
  */
contract GluonCentric {

  uint32 internal constant REGISTRY_INDEX = 0;
  uint32 internal constant STAKE_INDEX = 1;

  uint32 public id;
  address public gluon;

  /// @param id_ index of the app within gluon
  /// @param gluon_ address of the Gluon contract
  constructor(uint32 id_, address gluon_) public {
    id = id_;
    gluon = gluon_;
  }

  /// @notice requires the sender to be the currently active (latest) version of me (the app contract)
  modifier onlyCurrentLogic { require(currentLogic() == msg.sender, "invalid sender; must be current logic contract"); _; }

  /// @notice requires the sender must be gluon contract
  modifier onlyGluon { require(gluon == msg.sender, "invalid sender; must be gluon contract"); _; }

  /// @notice requires the sender must be my app owner
  modifier onlyOwner { require(GluonView(gluon).isAppOwner(id, msg.sender), "invalid sender; must be app owner"); _; }

  /// @return address the address of currently active (latest) version of me (the app contract)
  function currentLogic() public view returns (address) { return GluonView(gluon).current(id); }

}

// File: contracts/gluon/GluonWallet.sol

pragma solidity 0.5.12;


interface GluonWallet {
  function depositEther(uint32 id) external payable;
  function depositToken(uint32 id, address token, uint quantity) external;
  function withdraw(uint32 id, bytes calldata parameters) external;
  function transfer(uint32 from, uint32 to, bytes calldata parameters) external;
}

// File: contracts/gluon/Upgrading.sol

pragma solidity 0.5.12;




contract Upgrading {
  address public upgradeOperator;

  modifier onlyOwner { require(false, "modifier onlyOwner must be implemented"); _; }
  modifier onlyUpgradeOperator { require(upgradeOperator == msg.sender, "invalid sender; must be upgrade operator"); _; }
  function setUpgradeOperator(address upgradeOperator_) external onlyOwner { upgradeOperator = upgradeOperator_; }
  function upgrade_(AppGovernance appGovernance, uint32 id) internal {
    appGovernance.activate(id);
    delete upgradeOperator;
  }
}

// File: contracts/apps_history/registry/OldRegistry.sol

pragma solidity 0.5.12;


interface OldRegistry {
  function contains(address apiKey) external view returns (bool);
  function register(address apiKey) external;
  function registerWithUserAgreement(address apiKey, bytes32 userAgreement) external;
  function translate(address apiKey) external view returns (address);
}

// File: contracts/apps/registry/RegistryData.sol

pragma solidity 0.5.12;



contract RegistryData is GluonCentric {

  mapping(address => address) public accounts;

  constructor(address gluon) GluonCentric(REGISTRY_INDEX, gluon) public { }

  function addKey(address apiKey, address account) external onlyCurrentLogic {
    accounts[apiKey] = account;
  }

}

// File: contracts/apps/registry/RegistryLogic.sol

pragma solidity 0.5.12;










/**
  * @title enabling Zero Knowledge API Keys as described in: https://blog.leverj.io/zero-knowledge-api-keys-43280cc93647
  * @notice the Registry app consists of the RegistryLogic & RegistryData contracts.
  * api-key registrations are held within RegistryData for an easier upgrade path.
  * @dev although Registry enable account-based apps needing log-less logins, no app is required to use it.
  */
contract RegistryLogic is Upgrading, Validating, AppLogic, AppState, GluonCentric {

  RegistryData public data;
  OldRegistry public old;

  event Registered(address apiKey, address indexed account);

  constructor(address gluon, address old_, address data_) GluonCentric(REGISTRY_INDEX, gluon) public {
    data = RegistryData(data_);
    old = OldRegistry(old_);
  }

  modifier isAbsent(address apiKey) { require(translate(apiKey) == address (0x0), "api key already in use"); _; }

  /// @notice register an api-key on behalf of the sender
  /// @dev irreversible operation; the apiKey->sender association cannot be broken or overwritten
  /// (but further apiKey->sender associations can be provided)
  ///
  /// @param apiKey the account to be used to stand-in for the registering sender
  function register(address apiKey) external whenOn validAddress(apiKey) isAbsent(apiKey) {
    data.addKey(apiKey, msg.sender);
    emit Registered(apiKey, msg.sender);
  }

  /// @notice retrieve the stand-in-for account
  ///
  /// @param apiKey the account to be used to stand-in for the registering sender
  function translate(address apiKey) public view returns (address) {
    address account = data.accounts(apiKey);
    if (account == address(0x0)) account = old.translate(apiKey);
    return account;
  }

  /**************************************************** AppLogic ****************************************************/

  /// @notice upgrade the app to a new version; the approved proposal.
  /// by the end of this call the approved proposal would be the current and active version of the app.
  function upgrade() external onlyUpgradeOperator {
    retire_();
    upgrade_(AppGovernance(gluon), id);
  }

  function credit(address, address, uint) external { revert("not supported"); }

  function debit(address, bytes calldata) external returns (address, uint) { revert("not supported"); }

  /***************************************************** AppState *****************************************************/

  /// @notice halt the app. this action is irreversible.
  /// (the only option at this point is have a proposal that will get to approval, then activated.)
  /// should be called by an app-owner when the app has been compromised.
  ///
  /// Note the constraint that all apps but Registry & Stake must be halted first!
  function switchOff() external onlyOwner {
    uint32 totalAppsCount = GluonView(gluon).totalAppsCount();
    for (uint32 i = 2; i < totalAppsCount; i++) {
      AppState appState = AppState(GluonView(gluon).current(i));
      require(!appState.isOn(), "One of the apps is still ON");
    }
    switchOff_();
  }

  /********************************************************************************************************************/
}

// File: contracts/apps/stake/Governing.sol

pragma solidity 0.5.12;


interface Governing {
  function deleteVoteTally(address proposal) external;
  function activationInterval() external view returns (uint);
}

// File: contracts/apps/stake/Redeeming.sol

pragma solidity 0.5.12;


interface Redeeming {
  function redeem(address account, uint quantity) external returns (uint toRestake, uint toStake, uint toWithdraw);
}

// File: contracts/apps/stake/StakeData.sol

pragma solidity 0.5.12;




contract StakeData is GluonCentric {
  using SafeMath for uint;

  mapping(address => address[]) public accountToProposals;
  mapping(address => bool[]) public accountToSides;
  mapping(address => mapping(bool => uint)) public voteTally; /// proposal => side(true/false) => totalVotes
  mapping(address => address) public accountLocation;         /// account => logic
  mapping(address => uint) public balance;

  constructor(address gluon) GluonCentric(STAKE_INDEX, gluon) public { }

  function updateAccountLocation(address account, address logic) external onlyCurrentLogic { accountLocation[account] = logic; }

  function updateBalance(address account, uint quantity) external onlyCurrentLogic { balance[account] = quantity; }

  function voteAppUpgrade(address proposal, address account, bool side, uint quantity) external onlyCurrentLogic returns (uint, uint) {
    uint index = getVoteIndex(account, proposal);
    bool firstVote = index == accountToProposals[account].length;
    require(firstVote || accountToSides[account][index] != side, "cannot vote same side again");
    if (firstVote) {
      accountToProposals[account].push(proposal);
      accountToSides[account].push(side);
    } else {
      voteTally[proposal][!side] = voteTally[proposal][!side].minus(quantity);
      accountToSides[account][index] = side;
    }
    voteTally[proposal][side] = voteTally[proposal][side].plus(quantity);
    return getVoteTally(proposal);
  }

  function deleteVoteTally(address proposal) external onlyCurrentLogic {
    voteTally[proposal][true] = voteTally[proposal][false] = 0;
  }

  function getVoteIndex(address account, address proposal) public view returns (uint) {
    address[] memory proposals = accountToProposals[account];
    for (uint i = 0; i < proposals.length; i++) {
      if (proposals[i] == proposal) return i;
    }
    return proposals.length;
  }

  function getAllProposals(address account) external view returns (address[] memory proposals, bool[] memory sides) {
    proposals = accountToProposals[account];
    sides = accountToSides[account];
  }

  function removeResolvedProposals(address account) external onlyCurrentLogic {
    if (accountToProposals[account].length == 0) return;
    address[] storage allProposed = accountToProposals[account];
    bool[] storage sides = accountToSides[account];
    for (uint i = allProposed.length; i > 0; i--) {
      if (!GluonView(gluon).proposals(allProposed[i - 1])) {
        allProposed[i - 1] = allProposed[allProposed.length - 1];
        allProposed.pop();
        sides[i - 1] = sides[sides.length - 1];
        sides.pop();
      }
    }
  }

  function updateVotes(address proposal, bool side, uint quantity, bool increased) external onlyCurrentLogic returns (uint approvals, uint disapprovals) {
    uint tally = voteTally[proposal][side];
    voteTally[proposal][side] = increased ? tally.plus(quantity) : tally.minus(quantity);
    return getVoteTally(proposal);
  }

  function getVoteTally(address proposal) public view returns (uint approvals, uint disapprovals) {
    approvals = voteTally[proposal][true];
    disapprovals = voteTally[proposal][false];
  }

}

// File: contracts/apps/stake/StakeLogicV1.sol

pragma solidity 0.5.12;
















/**
  * @notice the Stake app consists of the StakeLogic & StakeData contracts.
  * voting data and staked balances are held within StakeData for an easier upgrade path.
  *
  * staking LEV tokens allows for:
  *  a. distribution of awards to stakers
  *  b. governance of apps; as stakers can vote for or against proposals (proposed app upgrades)
  */
contract StakeLogicV1 is Upgrading, Validating, AppLogic, AppState, GluonCentric, Governing, Redeeming {
  using BytesLib for bytes;
  using SafeMath for uint;
  address constant private ETH = address(0x0);
  bool initiated;
  /// per stake interval data
  struct Interval {
    uint worth;
    uint[] rewards;
    uint start;
    uint end;
  }

  /// account
  struct UserStake {
    uint intervalIndex;
    uint quantity;
    uint worth;
  }

  StakeData public data;
  Token public LEV;
  address[] public tokens;
  uint[] public toBeDistributed;

  uint public intervalSize;
  uint public currentIntervalIndex;
  uint public quorumPercentage;
  uint public activationInterval;
  mapping(uint => Interval) public intervals;
  mapping(address => UserStake) public stakes;

  event Staked(address indexed user, uint levs, uint start, uint end, uint intervalIndex);
  event Restaked(address indexed user, uint levs, uint start, uint end, uint intervalIndex);
  event Redeemed(address indexed user, uint levs, uint start, uint end, uint intervalIndex);
  event Reward(address indexed user, address asset, uint reward, uint start, uint end, uint intervalIndex);
  event NewInterval(uint start, uint end, uint intervalIndex);
  event Voted(uint32 indexed appId, address indexed proposal, uint approvals, uint disapprovals, address account);
  event VotingConcluded(uint32 indexed appId, address indexed proposal, uint approvals, uint disapprovals, bool result);

  constructor(address gluon, address data_, address lev, address[] memory tokens_, address apiKey, uint intervalSize_, uint quorumPercentage_, uint activationInterval_)
  GluonCentric(STAKE_INDEX, gluon)
  public
  validAddress(gluon)
  validAddress(lev)
  validAddress(apiKey)
  notZero(intervalSize_)
  notZero(activationInterval_)
  {
    data = StakeData(data_);
    LEV = Token(lev);
    tokens = tokens_;
    for (uint i = 0; i < tokens.length; i++) {
      toBeDistributed.push(0);
    }
    quorumPercentage = quorumPercentage_;
    intervalSize = intervalSize_;
    registerApiKey_(apiKey);
    activationInterval = activationInterval_;
  }

  function() external payable {}

  function governanceToken() external view returns (address) {return address(LEV);}

  function init(uint intervalId) external onlyOwner {
    require(initiated == false, "already initiated");
    currentIntervalIndex = intervalId;
    intervals[currentIntervalIndex].start = block.number;
    intervals[currentIntervalIndex].end = block.number + intervalSize;
    for (uint i = 0; i < tokens.length; i++) intervals[currentIntervalIndex].rewards.push(0);
    initiated = true;
  }

  function setIntervalSize(uint intervalSize_) external notZero(intervalSize_) onlyOwner {
    ensureInterval();
    intervalSize = intervalSize_;
  }

  function addToken(address token) external validAddress(token) onlyOwner whenOn {
    require(tokens.length < 50, "Can not add more than 50 tokens");
    tokens.push(token);
    toBeDistributed.push(0);
    intervals[currentIntervalIndex].rewards.push(0);
  }

  /// @notice establish an interval if none exists
  function ensureInterval() public whenOn {
    if (intervals[currentIntervalIndex].end > block.number) return;

    Interval storage interval = intervals[currentIntervalIndex];
    for (uint i = 0; i < interval.rewards.length; i++) {
      uint reward = interval.worth == 0 ? 0 : calculateIntervalReward(interval.start, interval.end, i);
      toBeDistributed[i] = toBeDistributed[i].plus(reward);
      interval.rewards[i] = reward;
    }

    uint diff = (block.number - interval.end) % intervalSize;
    currentIntervalIndex += 1;
    uint start = interval.end;
    uint end = block.number - diff + intervalSize;
    intervals[currentIntervalIndex].start = start;
    intervals[currentIntervalIndex].end = end;
    for (uint i = 0; i < tokens.length; i++) intervals[currentIntervalIndex].rewards.push(0);
    emit NewInterval(start, end, currentIntervalIndex);
  }

  function restake(address account, uint quantity) private returns (uint, uint) {
    Redeeming stakeLocation = Redeeming(data.accountLocation(account) == address(0x0) ? address(this) : data.accountLocation(account));
    (uint toRestake, uint toStake, uint toWithdraw) = stakeLocation.redeem(account, quantity);
    if (toRestake == 0) return (toStake, toWithdraw);

    UserStake storage stake = stakes[account];
    stake.quantity = toRestake;
    Interval storage interval = intervals[currentIntervalIndex];
    stake.intervalIndex = currentIntervalIndex;
    stake.worth = stake.quantity.times(interval.end.minus(interval.start));
    interval.worth = interval.worth.plus(stake.worth);
    emit Restaked(account, stake.quantity, interval.start, interval.end, currentIntervalIndex);
    return (toStake, toWithdraw);
  }

  function stake(address account, uint quantity) private whenOn returns (uint toStake, uint toWithdraw) {
    ensureInterval();
    (toStake, toWithdraw) = restake(account, quantity);
    data.updateAccountLocation(account, address(this));
    data.removeResolvedProposals(account);
    if (toWithdraw > 0) {
      updateVotes(account, toWithdraw, false);
    }
    if (toStake > 0) {
      updateVotes(account, toStake, true);
      stakeInCurrentPeriod(account, toStake);
    }
    data.updateBalance(account, quantity);
  }

  function stakeInCurrentPeriod(address account, uint quantity) private {
    Interval storage interval = intervals[currentIntervalIndex];
    stakes[account].intervalIndex = currentIntervalIndex;
    uint worth = quantity.times(interval.end.minus(block.number));
    stakes[account].worth = stakes[account].worth.plus(worth);
    stakes[account].quantity = stakes[account].quantity.plus(quantity);
    interval.worth = interval.worth.plus(worth);
    emit Staked(account, quantity, interval.start, interval.end, currentIntervalIndex);
  }

  /// @notice calculate the reward for token for the interval: [`start`, `end`)
  /// provided for on-going operational queries
  function calculateIntervalReward(uint start, uint end, uint index) public view returns (uint) {
    uint balance = tokens[index] == ETH ? address(this).balance : Token(tokens[index]).balanceOf(address(this));
    return balance.minus(toBeDistributed[index]).times(end.minus(start)).div(block.number.minus(start));
  }

  function registerApiKey(address apiKey) public onlyOwner {registerApiKey_(apiKey);}

  function registerApiKey_(address apiKey) private {
    RegistryLogic registry = RegistryLogic(GluonView(gluon).current(REGISTRY_INDEX));
    registry.register(apiKey);
  }

  function withdrawFromApp(uint32 appId, bytes memory withdrawData) public {
    uint action = withdrawData.toUint(0);
    require(action == 1 || action == 5, "only assisted withdraw or exit on halt is allowed");
    GluonWallet(gluon).withdraw(appId, withdrawData);
  }

  function transferToLatestStakeAfterRetire() public whenRetired {
    for (uint i = 0; i < tokens.length; i++) {
      uint balance = tokens[i] == ETH ? address(this).balance : Token(tokens[i]).balanceOf(address(this));
      uint quantity = balance.minus(toBeDistributed[i]);
      transfer(tokens[i], currentLogic(), quantity);
    }
  }

  /**************************************************** Redeeming *****************************************************/

  /// @notice redeeming enables both withdrawing and restaking.
  /// first, the quantities {toRestake, toStake, toWithdraw} are calculated from the last staked amount and the given quantity
  /// to redeem, then `toWithdraw` will be transfer to the account, and `toRestake` will be staked in the current interval.
  /// the calculated values are returned to calling functions for further processing.
  ///
  /// @param account the staking account
  /// @param quantity how much to redeem
  /// @return toRestake how much of the staked amount from previously staked interval will be carried over to current stake interval
  /// @return toStake how much (beyond toRestake) will be staked for the remainder of the current interval
  /// @return toWithdraw how much would no longer be staked and instead transferred back to the staker account
  function redeem(address account, uint quantity) public onlyCurrentLogic returns (uint, uint, uint) {// (toRestake, toStake, toWithdraw)
    UserStake memory userStake = stakes[account];
    if (userStake.intervalIndex == 0) return (0, quantity, 0);
    // non staked thus far, so stake quantity in-full

    uint staked = userStake.quantity;
    if (userStake.intervalIndex == currentIntervalIndex) {
      require(quantity > staked, "Can not reduce stake in the latest interval");
      return (0, quantity.minus(staked), 0);
      // some is already staked, so stake the difference
    }

    // some is staked in previous interval
    uint toWithdraw = staked > quantity ? staked.minus(quantity) : 0;
    uint toRestake = staked.minus(toWithdraw);
    // staker get previous staked amount carried over to current interval (minus the withdrawn amount)
    uint toStake = quantity > staked ? quantity.minus(staked) : 0;
    // staker get the extra amount (beyond what is already carried over) staked in the remainder of current interval

    uint intervalIndex = userStake.intervalIndex;
    Interval memory interval = intervals[intervalIndex];
    uint worth = userStake.worth;
    delete stakes[account];
    distributeRewards(account, worth, interval, intervalIndex);
    emit Redeemed(account, toWithdraw, interval.start, interval.end, intervalIndex);
    return (toRestake, toStake, toWithdraw);
  }

  function distributeRewards(address account, uint worth, Interval memory interval, uint intervalIndex) private {
    if (worth == 0) return;
    for (uint i = 0; i < tokens.length; i++) {
      uint reward = interval.rewards[i].times(worth).div(interval.worth);
      if (reward == 0) continue;
      toBeDistributed[i] = toBeDistributed[i].minus(reward);
      transfer(tokens[i], account, reward);
      emit Reward(account, tokens[i], reward, interval.start, interval.end, intervalIndex);
    }
  }

  function transfer(address token, address to, uint quantity) private {
    if (quantity == 0) return;
    token == ETH ?
    require(address(uint160(to)).send(quantity), "failed to transfer ether") : // explicit casting to `address payable`
    transferTokensToAccountSecurely(Token(token), quantity, to);
  }

  function transferTokensToAccountSecurely(Token token, uint quantity, address to) private {
    uint balanceBefore = token.balanceOf(to);
    require(token.transfer(to, quantity), "failure to transfer quantity from token");
    uint balanceAfter = token.balanceOf(to);
    require(balanceAfter.minus(balanceBefore) == quantity, "bad Token; transferFrom erroneously reported of successful transfer");
  }

  function getTokens() public view returns (address[] memory){return tokens;}

  function getToBeDistributed() public view returns (uint[] memory) {return toBeDistributed;}

  function getInterval(uint intervalIndex) public view returns (uint worth, uint[] memory rewards, uint start, uint end){
    Interval memory interval = intervals[intervalIndex];
    worth = interval.worth;
    rewards = interval.rewards;
    start = interval.start;
    end = interval.end;
  }
  /**************************************************** Governing ****************************************************/

  /// @dev cleanup when deleting a proposal
  function deleteVoteTally(address proposal) external onlyGluon {data.deleteVoteTally(proposal);}

  /**************************************************** AppLogic ****************************************************/

  /// @notice upgrade the app to a new version; the approved proposal.
  /// by the end of this call the approved proposal would be the current and active version of the app.
  function upgrade() external whenOn onlyUpgradeOperator {
    intervals[currentIntervalIndex].end = block.number;
    ensureInterval();
    retire_();
    upgrade_(AppGovernance(gluon), id);
  }

  function credit(address account, address asset, uint quantity) external whenOn onlyGluon {
    require(asset == address(LEV), "can only deposit lev tokens");
    stake(account, data.balance(account).plus(quantity));
  }

  function debit(address account, bytes calldata parameters) external whenOn onlyGluon returns (address asset, uint quantity) {
    (asset, quantity) = abi.decode(parameters, (address, uint));
    require(asset == address(LEV), "can only withdraw lev tokens");
    stake(account, data.balance(account).minus(quantity));
  }

  /***************************************************** vote to upgrade ****************************************************/

  /// @notice vote for the current app proposal
  ///
  /// @param appId the app the sender is voting for
  /// @param side yay or nay: true => approve, false => disapprove
  function voteAppUpgrade(uint32 appId, bool side) external whenOn {
    (, address proposal, uint activationBlock) = GluonView(gluon).app(appId);
    require(activationBlock > block.number, "can not be voted");
    uint quantity = data.balance(msg.sender);
    (uint approvals, uint disapprovals) = data.voteAppUpgrade(proposal, msg.sender, side, quantity);
    emit Voted(appId, proposal, approvals, disapprovals, msg.sender);
    concludeVoting(appId, proposal, approvals, disapprovals);
  }

  function updateVotes(address account, uint quantity, bool increased) private {
    (address[] memory allProposed, bool[] memory sides) = data.getAllProposals(account);
    for (uint i; i < allProposed.length; i++) {
      uint32 appId = GluonCentric(allProposed[i]).id();
      (,,uint activationBlock) = GluonView(gluon).app(appId);
      if (block.number > activationBlock) continue;
      (uint approvals, uint disapprovals) = data.updateVotes(allProposed[i], sides[i], quantity, increased);
      emit Voted(appId, allProposed[i], approvals, disapprovals, msg.sender);
      concludeVoting(appId, allProposed[i], approvals, disapprovals);
    }
  }

  function concludeVoting(uint32 appId, address proposal, uint approvals, uint disapprovals) private {
    if (approvals.plus(disapprovals) >= LEV.totalSupply().times(quorumPercentage).div(100)) {
      if (approvals > disapprovals) {
        AppGovernance(gluon).approve(appId);
        emit VotingConcluded(appId, proposal, approvals, disapprovals, true);
      } else {
        AppGovernance(gluon).disapprove(appId);
        emit VotingConcluded(appId, proposal, approvals, disapprovals, false);
      }
    }
  }

  /***************************************************** halting *****************************************************/

  /// @notice halt the app. this action is irreversible.
  /// (the only option at this point is have a proposal that will get to approval, then activated.)
  /// should be called by an app-owner when the app has been compromised.
  ///
  /// Note the constraint that all apps but Registry & Stake must be halted first!
  function switchOff() external onlyOwner {
    uint32 totalAppsCount = GluonView(gluon).totalAppsCount();
    for (uint32 appId = 2; appId < totalAppsCount; appId++) {
      AppState appState = AppState(GluonView(gluon).current(appId));
      require(!appState.isOn(), "One of the apps is still ON");
    }
    switchOff_();
  }

  /********************************************************************************************************************/
}