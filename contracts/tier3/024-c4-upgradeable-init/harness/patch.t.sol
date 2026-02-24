// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_024_c4_upgradeable_init is Test {
    function testPatch_BlocksReinitialize() public {
        C4UpgradeableInitPatched c = new C4UpgradeableInitPatched();
        c.initialize(address(this));
        vm.expectRevert("already initialized");
        c.initialize(address(0xBEEF));
    }
}
