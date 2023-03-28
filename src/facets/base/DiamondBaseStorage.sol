// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

library DiamondBaseStorage {
    bytes32 constant DIAMOND_BASE_STORAGE_POSITION = keccak256("diamond.base.storage");

    struct Layout {
        address diamondFactory;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = DIAMOND_BASE_STORAGE_POSITION;

        assembly {
            l.slot := position
        }
    }
}