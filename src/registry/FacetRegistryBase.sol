// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { IFacetRegistryBase } from "./IFacetRegistryBase.sol";
import { FacetRegistryStorage } from "./FacetRegistryStorage.sol";

abstract contract FacetRegistryBase is IFacetRegistryBase {
    using EnumerableSet for *;
    using Address for address;

    function _addFacet(address facet, bytes4[] memory selectors) internal {
        if (facet == address(0)) revert FacetRegistry_FacetAddressZero();
        if (selectors.length == 0) revert FacetRegistry_FacetMustHaveSelectors();
        if (!facet.isContract()) revert FacetRegistry_FacetNotContract();
        if (FacetRegistryStorage.layout().facets.contains(facet)) revert FacetRegistry_FacetAlreadyRegistered();

        FacetRegistryStorage.layout().facets.add(facet);
        for (uint256 i; i < selectors.length; i++) {
            FacetRegistryStorage.layout().facetSelectors[facet].add(selectors[i]);
        }

        emit FacetRegistered(facet, selectors);
    }

    function _removeFacet(address facet) internal {
        FacetRegistryStorage.Layout storage l = FacetRegistryStorage.layout();
        if (!l.facets.remove(facet)) revert FacetRegistry_FacetNotRegistered();

        uint256 selectorCount = l.facetSelectors[facet].length();
        for (uint256 i = 0; i < selectorCount; i++) {
            l.facetSelectors[facet].remove(l.facetSelectors[facet].at(i));
        }

        emit FacetUnregistered(facet);
    }

    function _facetSelectors(address facet) internal view returns (bytes4[] memory selectors) {
        uint256 selectorCount = FacetRegistryStorage.layout().facetSelectors[facet].length();
        selectors = new bytes4[](selectorCount);
        for (uint256 i; i < selectorCount; i++) {
            selectors[i] = bytes4(FacetRegistryStorage.layout().facetSelectors[facet].at(i));
        }
    }

    function _facetAddresses() internal view returns (address[] memory facets) {
        facets = FacetRegistryStorage.layout().facets.values();
    }
}