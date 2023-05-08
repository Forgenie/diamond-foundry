// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { ERC20Storage } from "./ERC20Storage.sol";
import { Initializable } from "src/utils/Initializable.sol";

library ERC20Behavior {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function __ERC20_init(string memory name_, string memory symbol_) internal {
        ERC20Storage.layout().name = name_;
        ERC20Storage.layout().symbol = symbol_;
    }

    function name() internal view returns (string memory) {
        return ERC20Storage.layout().name;
    }

    function symbol() internal view returns (string memory) {
        return ERC20Storage.layout().symbol;
    }

    function totalSupply() internal view returns (uint256) {
        return ERC20Storage.layout().totalSupply;
    }

    function balanceOf(address account) internal view returns (uint256) {
        return ERC20Storage.layout().balances[account];
    }

    function allowance(address owner, address spender) internal view returns (uint256) {
        return ERC20Storage.layout().allowances[owner][spender];
    }
}
