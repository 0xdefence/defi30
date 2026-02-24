// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_030_c4_multicall_reentrancy is Test {
    function testPatch_MulticallStillWorksUnderGuard() public {
        C4MulticallReentrancyPatched c = new C4MulticallReentrancyPatched();
        bytes[] memory x = new bytes[](2);
        x[0] = abi.encodeWithSignature("inc()");
        x[1] = abi.encodeWithSignature("inc()");
        c.multicall(x);
        assertEq(c.n(), 2);
    }
}
