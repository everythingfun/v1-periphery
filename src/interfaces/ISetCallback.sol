// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISetCallback {
    function onRegisterSet(
        address oops,
        address elemr,
        address kindr,
        address setr,
        uint64 universe,
        uint64 set,
        address owner
    ) external returns (bytes4);

    function onTransferSet(address from, address to) external returns (bytes4);

    function onTouchObject(uint64 id) external returns (bytes4);

    function onTransferObject(uint64 id, address from, address to) external returns (bytes4);
}
