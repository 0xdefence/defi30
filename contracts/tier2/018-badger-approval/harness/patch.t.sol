// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract PatchBadgerApprovalTest is Test {
    address constant TRUSTED = address(0x1111);
    BadgerApprovalPatched app;

    function setUp() public {
        app = new BadgerApprovalPatched(address(0x1234), address(0xDEAD), TRUSTED);
    }

    function testPatch_RejectsUntrustedSpender() public {
        vm.expectRevert("untrusted spender");
        app.approveAndPull(address(0xBEEF), 1 ether);
    }
}
