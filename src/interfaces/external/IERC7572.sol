// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC7572 {
    function contractURI() external view returns (string memory);

    event ContractURIUpdated();
}
