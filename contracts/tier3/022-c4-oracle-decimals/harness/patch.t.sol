// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract MockFeed22P is IFeed22P {
    int256 public p;
    function set(int256 _p) external { p = _p; }
    function latestAnswer() external view returns (int256) { return p; }
}

contract Patch_022_c4_oracle_decimals is Test {
    function testPatch_UsesCorrectScaling() public {
        MockFeed22P f = new MockFeed22P();
        f.set(2_000e8);
        C4OracleDecimalsPatched c = new C4OracleDecimalsPatched(address(f));
        c.deposit(1e18);
        assertEq(c.collateralValue(address(this)), 2_000e18, "correctly scaled collateral value");
    }
}
