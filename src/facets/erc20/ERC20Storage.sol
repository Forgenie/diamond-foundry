// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library ERC20Storage {
    bytes32 internal constant ERC20_STORAGE_SLOT = keccak256("diamond.standard.erc20.storage");

    struct Layout {
        uint256 totalSupply;
        mapping(address => uint256) balances;
        mapping(address => mapping(address => uint256)) allowances;
        string name;
        string symbol;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = ERC20_STORAGE_SLOT;
        assembly {
            l.slot := position
        }
    }
}
