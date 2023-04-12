// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DiamondBaseFacetTest } from "test/facets/base/DiamondBase.t.sol";

import { IERC165 } from "src/facets/introspection/IERC165.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";
import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { IDiamondLoupe } from "src/facets/loupe/IDiamondLoupe.sol";
import { IDiamondIncremental } from "src/facets/incremental/IDiamondIncremental.sol";

contract IntrospectionTest is DiamondBaseFacetTest {
    IERC165 public introspection;

    function setUp() public override {
        super.setUp();

        introspection = IERC165(diamond);
    }

    function test_SupportsBasicInterface() public {
        assertTrue(introspection.supportsInterface(type(IERC165).interfaceId));
        assertTrue(introspection.supportsInterface(type(IERC173).interfaceId));
        assertTrue(introspection.supportsInterface(type(IDiamondCut).interfaceId));
        assertTrue(introspection.supportsInterface(type(IDiamondLoupe).interfaceId));
        assertTrue(introspection.supportsInterface(type(IDiamondIncremental).interfaceId));
    }
}
