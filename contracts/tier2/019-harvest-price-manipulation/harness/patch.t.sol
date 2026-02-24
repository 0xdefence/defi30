// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract MockAMM019P is IAMMP019 {
    uint256 public p;
    function set(uint256 _p) external { p = _p; }
    function getSpotPrice() external view returns (uint256) { return p; }
}

contract Patch_019_harvest_price_manipulation is Test {
    function testPatch_RejectsExtremeSpotMove() public {
        MockAMM019P amm = new MockAMM019P();
        HarvestPriceManipulationPatched h = new HarvestPriceManipulationPatched(address(amm));

        amm.set(1e18);
        h.syncPrice();

        amm.set(4e18);
        vm.expectRevert("deviation too large");
        h.syncPrice();
    }
}
