// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface ISetMintable {
    function mint(address operator, address recipient, uint64 id, bytes calldata data) external;
}
