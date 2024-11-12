// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../sets/SetBase.sol";

contract Dice is SetBase {
    error ObjectIdOverflow();
    error InvalidFaceValue();

    uint64 private _nextId;

    constructor(uint64 kind) SetBase(kind) {
        _nextId = 1;
    }

    function mint() external returns (uint64) {
        uint256 randomFace = _random();
        return _mint(randomFace);
    }

    function mint(uint256 faceValue) external returns (uint64) {
        return _mint(faceValue);
    }

    function roll(uint64 id) external returns (uint256) {
        uint256 newFaceValue = _random();
        bytes32[] memory elems = new bytes32[](1);
        elems[0] = bytes32(newFaceValue);
        ObjectMeta memory meta = _update(id, elems);
        emit Updated(id, meta, elems);
        emit URI(uri(id), id);
        return newFaceValue;
    }

    function _mint(uint256 faceValue) internal returns (uint64) {
        if (faceValue < 1 || faceValue > 6) revert InvalidFaceValue();
        uint64 id = _nextId++;
        if (id >= type(uint64).max) revert ObjectIdOverflow();

        bytes32[] memory elems = new bytes32[](1);
        elems[0] = bytes32(faceValue);
        _create(id, elems, msg.sender);
        return id;
    }

    function _random() private view returns (uint256) {
        return uint256(blockhash(block.number - 1)) % 6 + 1;
    }
}
