// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @title ISet
 * @notice Complete interface combining methods and events for Set contracts
 */
interface ISet {
    struct ObjectMeta {
        uint32 flags;
        uint32 rev;
        uint32 kindRev;
        uint32 setRev;
        uint64 kind;
        uint64 set;
    }

    /**
     * @notice Emitted when a new object is created within a set
     * @param id The ID of the object
     * @param meta The metadata of the object
     * @param elems The elements of the object
     * @param owner The address of the object's owner
     */
    event Created(uint64 id, ObjectMeta meta, bytes32[] elems, address owner);

    /**
     * @notice Emitted when an object is updated
     * @param id The ID of the object
     * @param meta The updated metadata of the object
     * @param elems The updated elements of the object
     */
    event Updated(uint64 id, ObjectMeta meta, bytes32[] elems);

    /**
     * @notice Emitted when an object is upgraded
     * @param id The ID of the object
     * @param meta The updated metadata of the object after the upgrade
     */
    event Upgraded(uint64 id, ObjectMeta meta);

    /**
     * @notice Emitted when an object is touched
     * @param id The ID of the object
     * @param meta The metadata of the object
     */
    event Touched(uint64 id, ObjectMeta meta);

    /**
     * @notice Emitted when an object is destroyed
     * @param id The ID of the object
     * @param meta The metadata of the object before destruction
     */
    event Destroyed(uint64 id, ObjectMeta meta);

    /**
     * @notice Emitted when the ownership of an object is transferred
     * @param id The ID of the object
     * @param from The address of the current owner
     * @param to The address of the new owner
     */
    event Transferred(uint64 id, address from, address to);

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
}
