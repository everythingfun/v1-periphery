// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ElementType, ObjectMeta} from "./Types.sol";

/**
 * @title IKindRegistry
 * @notice Primary interface for kind registration and management
 */
interface IKindRegistry {
    /**
     * @notice Emitted when a new kind is registered
     * @param id The ID of the newly registered kind
     * @param meta Metadata of the registered kind
     * @param shape The element specification of objects belonging to this kind
     * @param code The material hash of the kind's code
     * @param data The material hash of the kind's data
     * @param rels List of relations supported by this kind
     * @param owner The address that owns the registered kind
     */
    event KindRegistered(
        uint64 id, ObjectMeta meta, ElementType[] shape, bytes32 code, bytes32 data, uint64[] rels, address owner
    );

    /**
     * @notice Emitted when a kind is updated
     * @param id The ID of the updated kind
     * @param meta Updated metadata of the kind
     * @param rels Updated list of relations associated with the kind
     * @param code Updated material hash of the kind's code
     * @param data Updated material hash of the kind's data
     */
    event KindUpdated(uint64 id, ObjectMeta meta, uint64[] rels, bytes32 code, bytes32 data);

    /**
     * @notice Emitted when a kind is upgraded to a new revision
     * @param id The ID of the upgraded kind
     * @param meta Updated metadata of the upgraded kind
     */
    event KindUpgraded(uint64 id, ObjectMeta meta);

    /**
     * @notice Emitted when a kind's revision is bumped without state change
     * @param id The ID of the kind
     * @param meta Metadata of the touched kind
     */
    event KindTouched(uint64 id, ObjectMeta meta);

    /**
     * @notice Emitted when ownership of a kind is transferred
     * @param id The ID of the kind being transferred
     * @param from The current owner of the kind
     * @param to The new owner of the kind
     */
    event KindTransferred(uint64 id, address from, address to);

    /**
     * @notice Registers a new kind with the specified parameters
     * @param shape Specification of the elements that define the object's state
     * @param code The material hash of the kind's code
     * @param data The material hash of the kind's data
     * @param rels List of relations supported by this kind
     * @return The ID of the newly registered kind
     */
    function register(ElementType[] memory shape, bytes32 code, bytes32 data, uint64[] memory rels)
        external
        returns (uint64);

    /**
     * @notice Updates the code and data of an existing kind
     * @param id The ID of the kind to be updated
     * @param code The new material hash representing the kind's code (zero = no change)
     * @param data The new material hash representing the kind's data (zero = no change)
     * @return The updated metadata for the kind
     */
    function update(uint64 id, bytes32 code, bytes32 data) external returns (ObjectMeta memory);

    /**
     * @notice Updates the code, data, and relations of an existing kind
     * @param id The ID of the kind to update
     * @param code The new material hash representing the kind's code (zero = no change)
     * @param gene The new material hash representing the kind's data (zero = no change)
     * @param rels The updated list of relations for the kind
     * @return The updated metadata of the kind
     */
    function update(uint64 id, bytes32 code, bytes32 gene, uint64[] memory rels) external returns (ObjectMeta memory);

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
     * @notice Retrieves the shape of a kind
     * @param id The ID of the kind
     * @return The state specification of the kind
     */
    function shapeOf(uint64 id) external view returns (ElementType[] memory);

    /**
     * @notice Retrieves the code hash of a kind at a given revision
     * @param id The ID of the kind
     * @param rev The specific revision number (zero = latest revision)
     * @return The code hash of the kind
     */
    function codeAt(uint64 id, uint32 rev) external view returns (bytes32);

    /**
     * @notice Retrieves the relations supported by a kind at a given revision
     * @param id The ID of the kind
     * @param rev The specific revision number (zero = latest revision)
     * @return The supported relations
     */
    function relsAt(uint64 id, uint32 rev) external view returns (uint64[] memory);

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
     * @notice Checks whether a list of kind IDs exist
     * @param ids An array of kind IDs to validate
     * @return A boolean indicating whether all provided IDs exist
     */
    function check(uint64[] memory ids) external view returns (bool);
}
