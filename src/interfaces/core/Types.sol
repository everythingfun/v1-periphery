// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

struct ObjectMeta {
    uint32 flags;
    uint32 rev;
    uint32 kindRev;
    uint32 setRev;
    uint64 kind;
    uint64 set;
}

enum ElementType {
    NONE,
    INFORMATION, // 0x01
    VALUE, // 0x02
    ARTIFACT, // 0x03
    MATERIAL // 0x04

}

enum TokenStandard {
    NONE,
    NATIVE,
    ERC20,
    ERC721,
    ERC1155
}

struct ValueRecord {
    address addr;
    uint64 id;
    TokenStandard std;
    uint8 decimals;
    bytes32 material;
}

struct ArtifactRecord {
    address addr;
    uint64 id;
    TokenStandard std;
    bytes32 material;
    uint64 begin;
    uint64 end;
}

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

struct DepAdjacency {
    uint32 degMinKind;
    uint32 degMaxKind;
    uint32 degMinOthers;
    uint32 degMaxOthers;
    uint32 degMinTotal;
    uint32 degMaxTotal;
    uint16 numKinds;
    bool totalSpecified;
    bool othersSpecified;
    bool relExists;
    bool kindHit;
    bool othersHit;
}
