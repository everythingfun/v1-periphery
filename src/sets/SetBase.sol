// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ISet} from "../interfaces/ISet.sol";
import {ISetCallback} from "../interfaces/ISetCallback.sol";
import {ObjectMeta} from "../interfaces/core/types/ObjectMeta.sol";
import {IOOPS} from "../interfaces/core/IOOPS.sol";
import {IERC7572} from "../interfaces/external/IERC7572.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {IERC1155MetadataURI} from "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";

abstract contract SetBaseErrors {
    error NotOwner();
    error InvalidUpgrade();
    error ObjectNotExist();
    error LastestRevisionOnly();
    error RevisionNotExist();
    error InvalidObjectId();
    error SetObjectNotExist();
}

abstract contract SetBaseCallback is ISetCallback {
    address internal _oops;
    address internal _elemr;
    address internal _kindr;
    address internal _setr;
    uint64 internal _universe;
    uint64 internal _set;

    function onRegisterSet(
        address oops,
        address elemr,
        address kindr,
        address setr,
        uint64 universe,
        uint64 set,
        address /*owner*/
    ) external returns (bytes4) {
        _oops = oops;
        _elemr = elemr;
        _kindr = kindr;
        _setr = setr;
        _universe = universe;
        _set = set;
        return ISetCallback.onRegisterSet.selector;
    }

    function onTransferSet(address, address) external pure returns (bytes4) {
        return ISetCallback.onTransferSet.selector;
    }

    function onTouchObject(uint64) external pure returns (bytes4) {
        return ISetCallback.onTouchObject.selector;
    }

    function onTransferObject(uint64, address, address) external pure returns (bytes4) {
        return ISetCallback.onTransferObject.selector;
    }
}

abstract contract SetBase is ISet, ISetCallback, SetBaseErrors, SetBaseCallback, ERC1155 {
    uint32 private constant MEAT_ASSET_SEL = 21278778; // uint32(bytes4(keccak256("meta")))
    uint64 private constant ID_SET_OF_SET = 1;
    uint64 private constant ID_MAX = type(uint64).max - 1;

    mapping(uint64 => ObjectMeta) private _metas;
    mapping(uint64 => bytes32[]) private _elems;
    uint64 private _kind;

    constructor(uint64 kind) ERC1155("") {
        _kind = kind;
    }

    function _create(uint64 id, bytes32[] memory elems, address to) internal returns (ObjectMeta memory) {
        uint32 kindRev = IOOPS(_oops).kindRevAt(_kind, 0);
        uint32 setRev = IOOPS(_oops).setRevAt(_set, 0);
        ObjectMeta memory meta =
            ObjectMeta({flags: 0, rev: 1, kindRev: kindRev, setRev: setRev, kind: _kind, set: _set});
        _metas[id] = meta;
        _elems[id] = elems;
        emit Created(id, meta, elems, to);
        _mint(to, id, 1, "");
        return meta;
    }

    function _update(uint64 id, bytes32[] memory elems) internal returns (ObjectMeta memory) {
        ObjectMeta storage meta = _metas[id];
        if (meta.rev == 0) revert ObjectNotExist();
        if (balanceOf(msg.sender, id) == 0) revert NotOwner();
        meta.rev++;
        _metas[id] = meta;
        _elems[id] = elems;
        return meta;
    }

    // ISet
    function upgrade(uint64 id, uint32 kindRev, uint32 setRev) external returns (ObjectMeta memory) {
        if (kindRev == 0 && setRev == 0) revert InvalidUpgrade();
        ObjectMeta storage meta = _metas[id];
        if (meta.rev == 0) revert ObjectNotExist();
        if (balanceOf(msg.sender, id) == 0) revert NotOwner();
        if (kindRev > 0) {
            if (kindRev > meta.kindRev) {
                meta.kindRev = kindRev;
            } else {
                revert InvalidUpgrade();
            }
        }
        if (setRev > 0) {
            if (setRev > meta.setRev) {
                meta.setRev = setRev;
            } else {
                revert InvalidUpgrade();
            }
        }
        meta.rev++;
        emit Upgraded(id, meta);
        emit URI(uri(id), id);
        return meta;
    }

    function touch(uint64 id) external returns (ObjectMeta memory) {
        ObjectMeta storage meta = _metas[id];
        if (meta.rev == 0) revert ObjectNotExist();
        if (balanceOf(msg.sender, id) == 0) revert NotOwner();
        meta.rev++;
        emit Touched(id, meta);
        emit URI(uri(id), id);
        return meta;
    }

    function transfer(uint64 id, address to) external {
        if (balanceOf(msg.sender, id) == 0) revert NotOwner();
        safeTransferFrom(msg.sender, to, id, 1, "");
        emit Transferred(id, msg.sender, to);
    }

    function metaAt(uint64 id, uint32 rev) external view returns (ObjectMeta memory) {
        ObjectMeta memory meta = _metas[id];
        if (meta.rev == 0) revert ObjectNotExist();
        if (rev != 0 && meta.rev != rev) revert LastestRevisionOnly();
        return meta;
    }

    function elemsAt(uint64 id, uint32 rev) external view returns (bytes32[] memory) {
        ObjectMeta memory meta = _metas[id];
        if (meta.rev == 0) revert ObjectNotExist();
        if (rev != 0 && meta.rev != rev) revert LastestRevisionOnly();
        return _elems[id];
    }

    function revAt(uint64 id, uint32 rev) external view returns (uint32) {
        ObjectMeta memory meta = _metas[id];
        if (meta.rev == 0) revert ObjectNotExist();
        if (rev == 0) {
            return meta.rev;
        } else if (rev <= meta.rev) {
            return rev;
        } else {
            revert RevisionNotExist();
        }
    }

    // IERC165
    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return (
            interfaceId == type(IERC7572).interfaceId || interfaceId == type(ISet).interfaceId
                || interfaceId == type(ISetCallback).interfaceId
        ) ? true : ERC1155.supportsInterface(interfaceId);
    }

    // IERC1155MetadataURI
    function uri(uint256 id) public view override(ERC1155) returns (string memory) {
        if (id == 0 || id >= type(uint64).max) revert InvalidObjectId();
        uint64 id_ = uint64(id);
        ObjectMeta memory meta = _metas[id_];
        if (meta.rev == 0) revert ObjectNotExist();
        return IOOPS(_oops).objectAssetAt(_set, id_, MEAT_ASSET_SEL, meta.rev);
    }

    // IERC7572
    function contractURI() external view returns (string memory) {
        uint32 setRev = IOOPS(_oops).setRevAt(_set, 0);
        if (setRev == 0) revert SetObjectNotExist();
        return IOOPS(_oops).objectAssetAt(ID_SET_OF_SET, _set, MEAT_ASSET_SEL, setRev);
    }
}
