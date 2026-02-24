// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_010_initializer_exposed is Test {
    function testPatch_BlocksReinitialization() public {
        InitializerExposedPatched c = new InitializerExposedPatched();
        c.initialize(address(this));
        vm.expectRevert("already initialized");
        c.initialize(address(0xBEEF));
    }
}
