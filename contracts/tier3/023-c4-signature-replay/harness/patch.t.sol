// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_023_c4_signature_replay is Test {
    function testPatch_RejectsReplayOnSecondUse() public {
        C4SignatureReplayPatched c = new C4SignatureReplayPatched(address(0));
        vm.deal(address(c), 2 ether);

        bytes memory sig = new bytes(65);
        bytes32 digest = keccak256("replay-digest");

        c.execute(address(0xCAFE), 0.5 ether, digest, sig);
        vm.expectRevert("replay");
        c.execute(address(0xCAFE), 0.5 ether, digest, sig);
    }
}
