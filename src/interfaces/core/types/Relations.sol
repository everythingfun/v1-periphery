// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Describes the rules of a relation between objects.
struct RelationRule {
    uint8 ownerOnForm;
    /// @dev Defines ownership status when a relation is formed
    uint8 posOnForm;
    /// @dev Defines the position when a relation is formed
    uint8 connOnForm;
    /// @dev Defines connection status when a relation is formed
    uint8 ownerOnTerm;
    /// @dev Defines ownership status when a relation is terminated
    uint8 posOnTerm;
    /// @dev Defines the position when a relation is terminated
    uint8 connOnTerm;
}
/// @dev Defines connection status when a relation is terminated

struct Adjacency {
    uint64 kind;
    uint32 degMin;
    uint32 degMax;
}
