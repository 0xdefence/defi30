// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract MockERC20Fail is IERC20Safe {
    function transferFrom(address, address, uint256) external pure returns (bool) { return false; }
    function approve(address, uint256) external pure returns (bool) { return true; }
}

contract Patch_008_unchecked_approval_drain is Test {
    function testPatch_RevertsOnFailedTransferFrom() public {
        MockERC20Fail t = new MockERC20Fail();
        UncheckedApprovalDrainPatched u = new UncheckedApprovalDrainPatched(address(t), address(0xBEEF));
        vm.expectRevert("transferFrom failed");
        u.sweep(address(0xCAFE), 1 ether);
    }
}
