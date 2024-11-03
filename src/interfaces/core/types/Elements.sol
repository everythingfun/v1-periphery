// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
