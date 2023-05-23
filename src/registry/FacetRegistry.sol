// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { IFacetRegistry } from "./IFacetRegistry.sol";
import { FacetRegistryStorage } from "./FacetRegistryStorage.sol";

error FacetRegistry_validateFacetInfo_FacetAlreadyRegistered();
error FacetRegistry_validateFacetInfo_FacetAddressZero();
error FacetRegistry_validateFacetInfo_FacetMustHaveSelectors();
error FacetRegistry_validateFacetInfo_FacetNotContract();

contract FacetRegistry is IFacetRegistry {
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using FacetRegistryStorage for FacetRegistryStorage.Layout;

    // solhint-disable-next-line no-empty-blocks
    constructor() { }

    /// @inheritdoc IFacetRegistry
    function registerFacet(FacetInfo calldata facetInfo) external {
        _validateFacetInfo(facetInfo);

        bytes32 facetId = computeFacetId(facetInfo.addr);

        FacetRegistryStorage.layout().addFacet(facetInfo, facetId);

        emit FacetImplementationSet(facetId, facetInfo.addr);
    }

    /// @inheritdoc IFacetRegistry
    function computeFacetId(address facet) public view returns (bytes32) {
        return facet.codehash;
    }

    /// @inheritdoc IFacetRegistry
    function facetAddress(bytes32 facetId) public view returns (address) {
        return FacetRegistryStorage.layout().facets[facetId].addr;
    }

    /// @inheritdoc IFacetRegistry
    function initializer(bytes32 facetId) public view override returns (bytes4) {
        return FacetRegistryStorage.layout().facets[facetId].initializer;
    }

    /// @inheritdoc IFacetRegistry
    function facetInterface(bytes32 facetId) public view override returns (bytes4) {
        return FacetRegistryStorage.layout().facets[facetId].interfaceId;
    }

    /// @inheritdoc IFacetRegistry
    function facetSelectors(bytes32 facetId) public view override returns (bytes4[] memory selectors) {
        bytes32[] memory selectorBytes = FacetRegistryStorage.layout().facets[facetId].selectors.values();

        selectors = new bytes4[](selectorBytes.length);

        for (uint256 i = 0; i < selectorBytes.length; i++) {
            selectors[i] = bytes4(selectorBytes[i]);
        }
    }

    function _validateFacetInfo(FacetInfo calldata facetInfo) internal view {
        if (facetInfo.addr == address(0)) revert FacetRegistry_validateFacetInfo_FacetAddressZero();
        if (facetInfo.selectors.length == 0) revert FacetRegistry_validateFacetInfo_FacetMustHaveSelectors();
        if (!Address.isContract(facetInfo.addr)) revert FacetRegistry_validateFacetInfo_FacetNotContract();
        if (facetAddress(computeFacetId(facetInfo.addr)) != address(0)) {
            revert FacetRegistry_validateFacetInfo_FacetAlreadyRegistered();
        }
    }
}
