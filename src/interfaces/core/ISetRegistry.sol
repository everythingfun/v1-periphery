// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ElementType} from "./types/Elements.sol";
import {ObjectMeta} from "./types/ObjectMeta.sol";

/**
 * @title ISetRegistry
 * @notice Interface for set registration and management
 */
interface ISetRegistry {
    /**
     * @notice Emitted when a new set is registered
     * @param id The ID of the set
     * @param meta The initial metadata of the set
     * @param code The address of the set's contract
     * @param data The material hash of the set's data
     * @param owner The address of the set's owner
     */
    event SetRegistered(uint64 id, ObjectMeta meta, address code, bytes32 data, address owner);

    /**
     * @notice Emitted when a set is updated
     * @param id The ID of the set
     * @param meta Updated metadata of the set
     * @param data Updated material hash of the set's data
     */
    event SetUpdated(uint64 id, ObjectMeta meta, bytes32 data);

    /**
     * @notice Emitted when a set is upgraded
     * @param id The ID of the set
     * @param meta The metadata of the set after upgrade
     */
    event SetUpgraded(uint64 id, ObjectMeta meta);

    /**
     * @notice Emitted when a set is touched
     * @param id The ID of the set
     * @param meta The metadata of the set after touch
     */
    event SetTouched(uint64 id, ObjectMeta meta);

    /**
     * @notice Emitted when ownership of a set is transferred
     * @param id The ID of the set
     * @param from The previous owner's address
     * @param to The new owner's address
     */
    event SetTransferred(uint64 id, address from, address to);

    /**
     * @notice Registers a new set in the registry
     * @param law The address of the set contract
     * @param lineage The material hash of the set's data
     * @return The ID of the newly registered set
     */
    function register(address law, bytes32 lineage) external returns (uint64);

    /**
     * @notice Updates the metadata and description of a set
     * @param id The ID of the set to update
     * @param lineage The updated metadata or description hash
     * @return The updated metadata of the set
     */
    function update(uint64 id, bytes32 lineage) external returns (ObjectMeta memory);

    /**
     * @notice Upgrades object to newer kind/set revisions
     * @param id The ID of the object
     * @param kindRev New kind revision (0 = no upgrade)
     * @param setRev New set revision (0 = no upgrade)
     * @return Updated metadata after upgrade
     */
    function upgrade(uint64 id, uint32 kindRev, uint32 setRev) external returns (ObjectMeta memory);

    /**
     * @notice Bumps object revision without state changes
     * @param id The ID of the object
     * @return Updated metadata after touch
     */
    function touch(uint64 id) external returns (ObjectMeta memory);

    /**
     * @notice Transfers object ownership
     * @param id The ID of the object
     * @param to New owner's address
     */
    function transfer(uint64 id, address to) external;

    /**
     * @notice Gets current owner of an object
     * @param id The ID of the object
     * @return Owner's address
     */
    function ownerOf(uint64 id) external view returns (address);

    /**
     * @notice Gets object metadata at specific revision
     * @param id The ID of the object
     * @param rev Revision number (0 = latest)
     * @return Object metadata
     */
    function metaAt(uint64 id, uint32 rev) external view returns (ObjectMeta memory);

    /**
     * @notice Gets object elements at specific revision
     * @param id The ID of the object
     * @param rev Revision number (0 = latest)
     * @return Array of elements
     */
    function elemsAt(uint64 id, uint32 rev) external view returns (bytes32[] memory);

    /**
     * @notice Validates revision and returns revision number
     * @param id The ID of the object
     * @param rev Revision number to check (0 = latest)
     * @return Revision number (0 if invalid)
     */
    function revAt(uint64 id, uint32 rev) external view returns (uint32);

    /**
     * @notice Returns the implementation address of the set contract
     * @param id The ID of the set
     * @return The address of the set's implementation
     */
    function codeOf(uint64 id) external view returns (address);
}
