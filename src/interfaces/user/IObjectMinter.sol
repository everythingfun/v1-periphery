// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

struct MintPolicy {
    uint64 idStart; // object id begin
    uint64 idEnd; // object id end(not inclusive)
    uint64 saleStart;
    uint64 saleEnd;
    bytes32 permData; // all, allowlist, allowspec
    uint16 permType; // anyone, allowlist, allowspec
    uint64 maxPerAddress;
    uint16 status; // 0: not exist, 1: enabled, 2: disabled
    address currency; // payment token: native, erc20
    uint96 price;
    address fundsRecipient; // Where to send the funds
}

enum PolicyStatus {
    NotExist,
    Enabled,
    Disabled
}

enum PermissionType {
    AllowAll,
    AllowList,
    AllowSpec
}

interface IObjectMinter {
    event PolicyAdded(address indexed set, uint32 index, MintPolicy policy);
    event PolicyUpdated(address indexed set, uint32 index, MintPolicy policy);
    event FundsCollected(address indexed from, address indexed currency, uint256 amount);
    event FundsDisbursed(address indexed to, address indexed currency, uint256 amount);
    event ObjectMinted(address indexed set, uint64 id, address indexed operator, address indexed recipient);

    function mintPolicyLength(address set) external returns (uint256);
    function mintPolicyAt(address set, uint32 index) external returns (MintPolicy memory);
    function priceOf(address set, uint64 id) external returns (address currency, uint96 price);
    function priceOf(address set, uint64 id, uint32 offset) external returns (address currency, uint96 price);
    function mint(address recipient, address set, uint64 id, bytes calldata mintArgs) external payable;
    function mint(address recipient, address set, uint64 id, bytes calldata mintArgs, bytes calldata objectArgs)
        external
        payable;

    function _mintPolicyAdd(MintPolicy memory policy) external returns (uint32 index);
    function _mintPolicyUpdate(uint32 index, MintPolicy memory policy) external;
    function _mintPolicyDisable(uint32 index) external;
    function _mintPolicyEnable(uint32 index) external;
}

interface IMinterArguments {
    function allowlist(bytes32[] memory proof) external;
    function allowspec(uint32 maxPerAddress, uint96 price, bytes32[] memory proof) external;
    function offset(uint32 offset) external;
    function offsetAllowlist(uint32 offset, bytes32[] memory proof) external;
    function offsetAllowspec(uint32 offset, uint32 maxPerAddress, uint96 price, bytes32[] memory proof) external;
}
