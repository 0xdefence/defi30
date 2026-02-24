// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract MockF27P is IF27P {
    uint256 public pv = 1e18;
    function p() external view returns (uint256) { return pv; }
    function set(uint256 x) external { pv = x; }
}

contract Patch_027_c4_oracle_window is Test {
    function testPatch_RejectsLargeDeviation() public {
        MockF27P f = new MockF27P();
        C4OracleWindowPatched c = new C4OracleWindowPatched(address(f));
        c.sync();
        f.set(999e18);
        vm.expectRevert("deviation");
        c.sync();
    }
}
