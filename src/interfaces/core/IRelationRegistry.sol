// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {RelationRule, Adjacency, DepAdjacency} from "./Types.sol";

/// @title IOOPS
/// @notice OOPS (Object Operating and Positioning System) is the contract responsible for handling the registration and management of relations, transforms, and spaces, while also overseeing object interactions and positioning within the protocol.
interface IRelationRegistry {
    /// @notice Emitted when a new relation is registered
    /// @param rel The ID of the registered relation
    /// @param rule The rule defining the relation's behavior
    /// @param adjs Specifies adjacencies or dependencies for the relation
    /// @param desc The description of the relation
    /// @param owner The owner of the relation
    event RelationRegistered(uint64 rel, RelationRule rule, Adjacency[] adjs, bytes32 desc, address owner);

    /// @notice Emitted when an existing relation is updated
    /// @param rel The ID of the updated relation
    /// @param desc The updated description of the relation
    event RelationUpdated(uint64 rel, bytes32 desc);

    /// @notice Emitted when a relation's ownership is transferred
    /// @param rel The ID of the transferred relation
    /// @param from The current owner of the relation
    /// @param to The new owner of the relation
    event RelationTransferred(uint64 rel, address from, address to);

    /// @notice Registers a new relation
    /// @param desc The description of the relation
    /// @param rule The rule defining the relation's behavior
    /// @param adjs The adjacency specification for the relation
    /// @return The ID of the newly registered relation
    function registerRelation(RelationRule memory rule, Adjacency[] memory adjs, bytes32 desc)
        external
        returns (uint64);

    /// @notice Updates an existing relation
    /// @param rel The ID of the relation to update
    /// @param desc The new description of the relation
    function updateRelation(uint64 rel, bytes32 desc) external;

    /// @notice Transfers ownership of a relation to another address
    /// @param rel The ID of the relation
    /// @param to The address to transfer ownership to
    function transferRelation(uint64 rel, address to) external;

    /**
     * @notice Checks whether a list of kind IDs exist
     * @param rels An array of Relation IDs to validate
     * @return A boolean indicating whether all provided IDs exist
     */
    function checkRelations(uint64[] memory rels) external view returns (bool);

    function checkRelationDest(uint64 rel, uint64 destKind, uint32 destKindRev)
        external
        view
        returns (bool, RelationRule memory);

    function checkRelationDep(uint64 rel, uint64 depKind) external view returns (DepAdjacency memory);

    // function getRelation(uint64 rel) external returns (RelationRecorrd memory);
}
