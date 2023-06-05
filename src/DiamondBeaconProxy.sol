// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BeaconProxy } from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import { DelegateCall } from "./utils/DelegateCall.sol";

/**
 * @notice This proxy will implement DiamondBase functionality.
 */
contract DiamondBeaconProxy is BeaconProxy, DelegateCall {
    /// @dev msg.sender is the factory address.
    constructor(bytes memory data) BeaconProxy(msg.sender, data) {
        // solhint-disable-previous-line no-empty-blocks
    }

    /// @dev Protecting from other contracts replicating the diamond fallback.
    function _beforeFallback() internal override noDelegateCall {
        // solhint-disable-previous-line no-empty-blocks
    }
}
