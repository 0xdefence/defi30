// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Patch_011_euler_exchange_rate is Test {
    function testPatch_BlocksDonationPump() public {
        EulerExchangeRatePatched e = new EulerExchangeRatePatched();
        e.deposit{value: 1 ether}();
        vm.expectRevert("donation disabled");
        e.donate{value: 9 ether}();
    }
}
