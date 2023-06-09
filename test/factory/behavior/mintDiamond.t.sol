// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { DiamondFoundryTest } from "../DiamondFoundry.t.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";

contract DiamondFoundry_mintDiamond is DiamondFoundryTest {
    Diamond.InitParams public diamondInitParams;

    function setUp() public override {
        super.setUp();

        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();

        IDiamond.FacetCut[] memory baseFacets = new IDiamond.FacetCut[](1);
        baseFacets[0] = ownableHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        IDiamond.FacetInit[] memory diamondInitData = new IDiamond.FacetInit[](1);
        diamondInitData[0] = ownableHelper.makeInitData(abi.encode(users.owner));

        diamondInitParams.baseFacets.push(baseFacets[0]);
        diamondInitParams.init = address(ownableHelper);
        diamondInitParams.initData = abi.encodeWithSelector(ownableHelper.multiDelegateCall.selector, diamondInitData);
    }

    function test_ZeroTokenIdIsMinted() public {
        assertEq(diamondFoundry.ownerOf(0), address(diamondFoundry));
    }

    function test_MintDiamond() public {
        address diamond = diamondFoundry.mintDiamond(diamondInitParams);

        assertEq(diamondFoundry.ownerOf(1), users.owner);
        assertEq(diamondFoundry.diamondAddress(1), diamond);
        assertEq(diamondFoundry.diamondId(diamond), 1);
    }
}
