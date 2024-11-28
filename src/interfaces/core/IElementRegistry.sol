// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ValueRecord, ArtifactRecord, TokenStandard} from "./Types.sol";

/**
 * @title IElementRegistry
 * @notice Core interface for element registration and management
 */
interface IElementRegistry {
    /**
     * @notice Emitted when a new value element is registered
     * @param id The ID of the registered value element
     * @param std The token standard
     * @param decimals The number of decimals for the token
     * @param addr The token contract address
     * @param material The token material hash
     * @param admin The address of the admin who registered the value
     */
    event ValueRegistered(uint64 id, TokenStandard std, uint8 decimals, address addr, bytes32 material, address admin);

    /**
     * @notice Emitted when a value element is updated
     * @param id The ID of the updated value element
     * @param material The new material hash
     */
    event ValueUpdated(uint64 id, bytes32 material);

    /**
     * @notice Emitted when a value element is transferred
     * @param id The ID of the transferred value element
     * @param from The address transferring the value
     * @param to The address receiving the value
     */
    event ValueTransferred(uint64 id, address from, address to);

    /**
     * @notice Emitted when a new artifact element is registered
     * @param id The ID of the registered artifact element
     * @param std The token standard
     * @param addr The token contract address
     * @param material The token material hash
     * @param begin The starting token ID
     * @param end The ending token ID
     * @param admin The address of the admin who registered the artifact
     */
    event ArtifactRegistered(
        uint64 id, TokenStandard std, address addr, bytes32 material, uint64 begin, uint64 end, address admin
    );

    /**
     * @notice Emitted when an artifact element is updated
     * @param id The ID of the updated artifact element
     * @param material The new material hash
     */
    event ArtifactUpdated(uint64 id, bytes32 material);

    /**
     * @notice Emitted when an artifact element is transferred
     * @param id The ID of the transferred artifact element
     * @param from The address transferring the artifact
     * @param to The address receiving the artifact
     */
    event ArtifactTransferred(uint64 id, address from, address to);

    /**
     * @notice Registers a new value element
     * @param std Token standard (e.g., ERC20)
     * @param addr Token contract address
     * @param material Token material hash
     * @return id The ID of the newly registered value element
     */
    function registerValue(TokenStandard std, address addr, bytes32 material) external returns (uint64 id);

    /**
     * @notice Updates an existing value element
     * @param id Token ID to update
     * @param material New material hash
     */
    function updateValue(uint64 id, bytes32 material) external;

    /**
     * @notice Gets value element by token ID
     * @param id Token ID to query
     * @return Value struct containing token metadata
     */
    function getValue(uint64 id) external view returns (ValueRecord memory);

    /**
     * @notice Gets value element by contract address
     * @param addr Contract address to query
     * @return Value struct containing token metadata
     */
    function getValue(address addr) external view returns (ValueRecord memory);

    /**
     * @notice Registers a new artifact element
     * @param std Token standard (e.g., ERC721, ERC1155)
     * @param addr Token contract address
     * @param material Token material hash
     * @param begin Starting token ID
     * @param end Ending token ID
     * @return id The ID of the newly registered artifact element
     */
    function registerArtifact(TokenStandard std, address addr, bytes32 material, uint64 begin, uint64 end)
        external
        returns (uint64 id);

    /**
     * @notice Updates an existing artifact element
     * @param id Token ID to update
     * @param material New material hash
     */
    function updateArtifact(uint64 id, bytes32 material) external;

    /**
     * @notice Gets artifact element by token ID
     * @param id Token ID to query
     * @return Artifact struct containing token metadata
     */
    function getArtifact(uint64 id) external view returns (ArtifactRecord memory);

    /**
     * @notice Gets artifact element by contract address
     * @param addr Contract address to query
     * @return Artifact struct containing token metadata
     */
    function getArtifact(address addr) external view returns (ArtifactRecord memory);
}
