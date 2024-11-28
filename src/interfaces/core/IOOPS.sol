// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {RelationRule, Adjacency} from "./Types.sol";
import {IRelationRegistry} from "./IRelationRegistry.sol";
import {ISpaceRegistry} from "./ISpaceRegistry.sol";

/// @title OOPS
/// @notice OOPS (Object Operating and Positioning System) is the contract responsible for handling the registration and management of relations, transforms, and spaces, while also overseeing object interactions and positioning within the protocol.
interface IOOPS is ISpaceRegistry, IRelationRegistry {
    /// @notice Emitted when an object is related to another object
    /// @param dep The ID of the dependent object
    /// @param dest The ID of the destination object
    /// @param rev The revision number of the relation
    event Related(uint256 dep, uint128 dest, uint32 rev);

    /// @notice Emitted when multiple objects are related to a destination object
    /// @param deps Array of dependent object IDs
    /// @param dest The ID of the destination object
    /// @param rev The revision number of the relation
    event Related(uint256[] deps, uint128 dest, uint32 rev);

    /// @notice Emitted when an object is unrelated (disconnected) from another object
    /// @param dep The ID of the dependent object
    /// @param dest The ID of the destination object
    /// @param rev The revision number of the relation
    event Unrelated(uint256 dep, uint128 dest, uint32 rev);

    /// @notice Emitted when multiple objects are unrelated from a destination object
    /// @param deps Array of dependent object IDs
    /// @param dest The ID of the destination object
    /// @param rev The revision number of the relation
    event Unrelated(uint256[] deps, uint128 dest, uint32 rev);

    /// @notice Emitted when the position of an object is changed
    /// @param obj The ID of the object being moved
    /// @param pos The new position of the object
    event Moved(uint256 obj, uint128 pos);

    /// @notice Emitted when multiple objects are moved to a new position
    /// @param objs Array of object IDs being moved
    /// @param pos The new position of the objects
    event Moved(uint256[] objs, uint128 pos);

    /// @notice Relates a dependent object to a destination object
    /// @param dep The ID of the dependent object
    /// @param dest The ID of the destination object
    function relate(uint256 dep, uint128 dest) external;

    /// @notice Relates multiple dependent objects to a destination object
    /// @param deps Array of dependent object IDs
    /// @param dest The ID of the destination object
    function relate(uint256[] memory deps, uint128 dest) external;

    /// @notice Unrelates a dependent object from a destination object
    /// @param dep The ID of the dependent object
    /// @param dest The ID of the destination object
    function unrelate(uint256 dep, uint128 dest) external;

    /// @notice Unrelates multiple dependent objects from a destination object
    /// @param deps Array of dependent object IDs
    /// @param dest The ID of the destination object
    function unrelate(uint256[] memory deps, uint256 dest) external;

    /// @notice Moves an object to a new position
    /// @param obj The ID of the object
    /// @param pos The new position of the object
    function move(uint256 obj, uint128 pos) external;

    /// @notice Moves multiple objects to a new position
    /// @param objs Array of object IDs
    /// @param pos The new position of the objects
    function move(uint256[] memory objs, uint128 pos) external;

    function kindRegistry() external view returns (address);

    function setRegistry() external view returns (address);

    function elementRegistry() external view returns (address);

    function universe() external view returns (uint64);

    function kindRevAt(uint64 kind, uint32 rev) external view returns (uint32);

    function setRevAt(uint64 set, uint32 rev) external view returns (uint32);

    function objectAssetAt(uint64 set, uint64 id, uint32 sel, uint32 rev) external view returns (string memory);
}
