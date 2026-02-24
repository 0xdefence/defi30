// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract PatchParityDelegatecallTest is Test {
    ParityDelegatecallPatched wallet;
    address attacker = address(0xBEEF);

    function setUp() public {
        wallet = new ParityDelegatecallPatched(address(0x1234));
        wallet.init(address(this));
    }

    function testPatch_RejectsInitThroughFallbackAndPreservesOwner() public {
        vm.prank(attacker);
        (bool ok, ) = address(wallet).call(abi.encodeWithSignature("initWallet(address)", attacker));
        assertFalse(ok, "fallback delegatecall path should be closed");
        assertEq(wallet.owner(), address(this), "owner must remain unchanged");
    }
}
