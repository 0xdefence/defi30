// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract MockPair016P is IAmmPairP016 {
    uint112 public r0;
    uint112 public r1;

    function set(uint112 _r0, uint112 _r1) external {
        r0 = _r0;
        r1 = _r1;
    }

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32) {
        return (r0, r1, 0);
    }
}

contract Patch_016_mango_oracle is Test {
    function testPatch_RejectsLargeSpotDeviation() public {
        MockPair016P pair = new MockPair016P();
        pair.set(1000, 1000);

        MangoOraclePatched m = new MangoOraclePatched(address(pair));
        m.updatePrice();

        pair.set(10, 5000);
        vm.expectRevert("deviation too large");
        m.updatePrice();
    }
}
