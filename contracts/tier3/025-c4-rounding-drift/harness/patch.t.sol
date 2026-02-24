// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_025_c4_rounding_drift is Test {
    function testPatch_UsesCorrectFormula() public {
        C4RoundingDriftPatched c = new C4RoundingDriftPatched();
        assertEq(c.mintShares(1e18), 1e18, "patched formula preserves scale");
    }
}
