// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { FacetInit } from "src/factory/IDiamondFactory.sol";
import { BaseTest } from "test/Base.t.sol";
import { Diamond, IDiamond } from "src/Diamond.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";
import { IOwnableEvents, IERC173 } from "src/facets/ownable/IERC173.sol";
import { OwnableFacet } from "src/facets/ownable/OwnableFacet.sol";
import { FacetTest } from "../Facet.t.sol";
import { FacetHelper } from "../Helpers.t.sol";

abstract contract OwnableFacetTest is IOwnableEvents, FacetTest {
    IERC173 public ownable;

    function setUp() public virtual override {
        super.setUp();

        ownable = IERC173(diamond);
    }

    function diamondInitParams() internal override returns (Diamond.InitParams memory) {
        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();

        FacetCut[] memory baseFacets = new IDiamond.FacetCut[](1);
        baseFacets[0] = ownableHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        FacetInit[] memory diamondInitData = new FacetInit[](1);
        diamondInitData[0] = ownableHelper.makeInitData(abi.encode(users.owner));

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: address(ownableHelper),
            initData: abi.encodeWithSelector(ownableHelper.multiDelegateCall.selector, diamondInitData)
        });
    }
}

contract OwnableFacetHelper is FacetHelper {
    OwnableFacet public ownableFacet;

    constructor() {
        ownableFacet = new OwnableFacet();
    }

    function facet() public view override returns (address) {
        return address(ownableFacet);
    }

    function selectors() public pure override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](2);
        selectors_[0] = OwnableFacet.transferOwnership.selector;
        selectors_[1] = OwnableFacet.owner.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IERC173).interfaceId;
    }

    function initializer() public pure override returns (bytes4) {
        return OwnableFacet.initialize.selector;
    }

    function name() public pure override returns (string memory) {
        return "Ownable";
    }

    // NOTE: This is a hack to give the initializer the owner address
    function makeInitData(bytes memory args) public view override returns (FacetInit memory) {
        return FacetInit({ facet: facet(), data: abi.encodeWithSelector(initializer(), abi.decode(args, (address))) });
    }
}
