// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_026_c4_manager_auth is Test {
    function testPatch_OnlyOwnerCanSetManager() public {
        C4ManagerAuthPatched c = new C4ManagerAuthPatched();
        vm.prank(address(0xBEEF));
        vm.expectRevert("not owner");
        c.setManager(address(0xBEEF));
    }
}
