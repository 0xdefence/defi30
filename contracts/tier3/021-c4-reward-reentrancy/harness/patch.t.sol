// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract Att021P {
    C4RewardReentrancyPatched c;
    constructor(address _c){ c = C4RewardReentrancyPatched(_c); }
    function attack() external { c.claim(); }
    receive() external payable { try c.claim() {} catch {} }
}

contract Patch_021_c4_reward_reentrancy is Test {
    function testPatch_BlocksReentrancy() public {
        C4RewardReentrancyPatched c = new C4RewardReentrancyPatched();
        Att021P a = new Att021P(address(c));
        c.fund{value: 2 ether}(address(a));
        a.attack();
        assertEq(address(a).balance, 2 ether, "single claim only");
    }
}
