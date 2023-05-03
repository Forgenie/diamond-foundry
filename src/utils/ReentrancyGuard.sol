// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

error ReentrancyGuard_nonReentrant_ReentrantCall();

abstract contract ReentrancyGuard {
    bytes32 private constant _REENTRANCY_GUARD_SLOT = keccak256("utils.reentrancy.guard");
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    struct Storage {
        uint256 status;
    }

    constructor() {
        layout().status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        if (layout().status == _ENTERED) revert ReentrancyGuard_nonReentrant_ReentrantCall();

        layout().status = _ENTERED;
        _;
        layout().status = _NOT_ENTERED;
    }

    function layout() private pure returns (Storage storage s) {
        bytes32 position = _REENTRANCY_GUARD_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            s.slot := position
        }
    }
}