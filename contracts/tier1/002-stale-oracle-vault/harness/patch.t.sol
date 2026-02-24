// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract MockOraclePatched is IOraclePatched {
    uint256 public p;
    uint256 public ts;
    function set(uint256 _p, uint256 _ts) external { p = _p; ts = _ts; }
    function latestPrice() external view returns (uint256 price, uint256 timestamp) { return (p, ts); }
}

contract Patch_002_stale_oracle_vault is Test {
    function testPatch_RejectsStalePrice() public {
        MockOraclePatched mo = new MockOraclePatched();
        mo.set(2_000e8, block.timestamp - 30 days);
        StaleOracleVaultPatched v = new StaleOracleVaultPatched(address(mo));
        vm.expectRevert("stale");
        v.getPrice();
    }
}
