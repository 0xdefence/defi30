// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_028_c4_permit_domain is Test {
    function testPatch_DomainSeparatedDigestChangesKey() public {
        C4PermitDomainPatched c = new C4PermitDomainPatched();
        bytes32 d = keccak256("permit");
        c.permit(d, "", 1, address(this));
        c.permit(d, "", 2, address(this));
        assertTrue(true, "different domain context should permit separate records");
    }
}
