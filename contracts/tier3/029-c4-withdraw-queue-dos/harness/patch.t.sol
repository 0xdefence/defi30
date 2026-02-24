// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_029_c4_withdraw_queue_dos is Test {
    function testPatch_EnforcesBatchLimit() public {
        C4WithdrawQueueDosPatched c = new C4WithdrawQueueDosPatched();
        vm.expectRevert("batch too large");
        c.process(101);
    }
}
