// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_015_nomad_initialization is Test {
    function testPatch_BlocksReinitializeAndZeroRoot() public {
        NomadInitializationPatched n = new NomadInitializationPatched();
        n.initialize(bytes32(uint256(1)), address(this));

        vm.expectRevert("already initialized");
        n.initialize(bytes32(uint256(2)), address(0xBEEF));
    }

    function testPatch_RejectsZeroRoot() public {
        NomadInitializationPatched n = new NomadInitializationPatched();
        vm.expectRevert("zero root");
        n.initialize(bytes32(0), address(this));
    }
}
