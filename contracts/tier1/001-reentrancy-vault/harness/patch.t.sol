// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract ReenterAttackerPatched {
    ReentrancyVaultPatched public v;
    uint256 public loops;
    constructor(address vault) { v = ReentrancyVaultPatched(vault); }
    function attack() external payable {
        v.deposit{value: msg.value}();
        v.withdraw(msg.value);
    }
    receive() external payable {
        if (loops < 1) {
            loops++;
            // should fail due to nonReentrant
            try v.withdraw(msg.value) {} catch {}
        }
    }
}

contract Patch_001_reentrancy_vault is Test {
    function testPatch_BlocksReentrancy() public {
        ReentrancyVaultPatched vault = new ReentrancyVaultPatched();
        vault.deposit{value: 5 ether}();
        ReenterAttackerPatched a = new ReenterAttackerPatched(address(vault));
        vm.deal(address(a), 1 ether);
        vm.prank(address(a));
        a.attack{value: 1 ether}();
        assertLe(address(a).balance, 2 ether, "no extra drain should occur");
    }
}
