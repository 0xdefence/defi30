// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract MockVoteTokenP is IVoteTokenPatched {
    mapping(address => uint256) public balances;
    function set(address a, uint256 b) external { balances[a] = b; }
    function balanceOf(address account) external view returns (uint256) { return balances[account]; }
}

contract DummyTarget { bool public done; function ping() external { done = true; } }

contract Patch_012_beanstalk_governance is Test {
    function testPatch_BlocksImmediateExecution() public {
        MockVoteTokenP token = new MockVoteTokenP();
        BeanstalkGovernancePatched g = new BeanstalkGovernancePatched(address(token));
        DummyTarget t = new DummyTarget();
        token.set(address(this), 2_000_000 ether);
        uint256 id = g.propose(address(t), abi.encodeWithSignature("ping()"));
        g.vote(id);
        vm.expectRevert("timelocked");
        g.execute(id);
    }
}
