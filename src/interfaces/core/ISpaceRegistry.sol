// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {RelationRule, Adjacency} from "./types/Relations.sol";

/// @title IOOPS
/// @notice OOPS (Object Operating and Positioning System) is the contract responsible for handling the registration and management of relations, transforms, and spaces, while also overseeing object interactions and positioning within the protocol.
interface ISpaceRegistry {
    /// @notice Emitted when a new space is registered
    /// @param block The block number where the space is registered
    /// @param desc The description of the space
    /// @param owner The owner of the space
    event SpaceRegistered(uint64 block, bytes32 desc, address owner);

    /// @notice Emitted when a space's details are updated
    /// @param block The block number of the space
    /// @param desc The updated description of the space
    /// @param rels The updated relations in the space
    event SpaceUpdated(uint64 block, bytes32 desc, uint64[] rels);

    /// @notice Emitted when ownership of a space is transferred
    /// @param block The block number of the space
    /// @param from The current owner of the space
    /// @param to The new owner of the space
    event SpaceTransferred(uint64 block, address from, address to);

    /// @notice Registers a new space at a specific block
    /// @param block The block number of the space
    /// @param desc The description of the space
    function registerSpace(uint64 block, bytes32 desc) external;

    /// @notice Updates an existing space
    /// @param block The block number of the space
    /// @param desc The new description of the space
    /// @param rels Updated relations in the space
    function updateSpace(uint64 block, bytes32 desc, uint64[] memory rels) external;

    /// @notice Transfers ownership of a space to another address
    /// @param block The block number of the space
    /// @param to The address to transfer ownership to
    function transferSpace(uint64 block, address to) external;
}
