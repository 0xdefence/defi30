// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_020_wormhole_signature is Test {
    function testPatch_RejectsMalformedSignature() public {
        WormholeSignaturePatched w = new WormholeSignaturePatched(address(0xABCD));
        vm.deal(address(w), 2 ether);

        bytes memory malformed = hex"1234";
        vm.expectRevert("bad sig len");
        w.execute(address(0xCAFE), 1 ether, 1, malformed);
    }
}
