// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_014_ronin_access_control is Test {
    function testPatch_BlocksThresholdLowering() public {
        address[] memory vals = new address[](2);
        vals[0] = address(this);
        vals[1] = address(0xBEEF);
        RoninAccessControlPatched r = new RoninAccessControlPatched(vals, 2);
        vm.expectRevert("cannot lower threshold");
        r.setThreshold(1);
    }
}
