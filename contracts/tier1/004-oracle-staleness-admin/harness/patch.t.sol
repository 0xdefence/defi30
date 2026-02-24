// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract MockFeedPatched is IPriceFeedPatched {
    int256 public ans;
    uint256 public ts;
    function set(int256 a, uint256 t) external { ans = a; ts = t; }
    function latestAnswer() external view returns (int256) { return ans; }
    function latestTimestamp() external view returns (uint256) { return ts; }
}

contract Patch_004_oracle_staleness_admin is Test {
    function testPatch_RejectsStaleFeedValue() public {
        MockFeedPatched f = new MockFeedPatched();
        f.set(2500e8, block.timestamp - 90 days);
        OracleStalenessAdminPatched c = new OracleStalenessAdminPatched(address(f));
        vm.expectRevert("stale");
        c.getPrice();
    }
}
