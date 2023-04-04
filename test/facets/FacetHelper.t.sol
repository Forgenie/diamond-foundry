// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";
import { IDiamond } from "src/IDiamond.sol";

abstract contract FacetHelper {
    function facet() public virtual returns (address);

    function selectors() public pure virtual returns (bytes4[] memory);

    function initializer() public pure virtual returns (bytes4);

    function name() public pure virtual returns (string memory);

    function facetInfo() public returns (IFacetRegistry.FacetInfo memory info) {
        info = IFacetRegistry.FacetInfo({
            name: name(),
            addr: facet(),
            initializer: initializer(),
            selectors: selectors()
        });
    }

    function makeFacetCut(IDiamond.FacetCutAction action) public returns (IDiamond.FacetCut memory) {
        return IDiamond.FacetCut({ action: action, facet: facet(), selectors: selectors() });
    }
}
