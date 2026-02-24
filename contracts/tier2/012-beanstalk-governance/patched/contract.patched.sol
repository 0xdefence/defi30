// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVoteTokenPatched {
    function balanceOf(address account) external view returns (uint256);
}

contract BeanstalkGovernancePatched {
    IVoteTokenPatched public immutable voteToken;
    uint256 public proposalCount;
    uint256 public quorum = 1_000_000 ether;
    uint256 public timelockSeconds = 1 days;

    struct Proposal { address target; bytes data; uint256 yesVotes; bool executed; uint256 eta; }
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public voted;

    constructor(address _voteToken) { voteToken = IVoteTokenPatched(_voteToken); }

    function propose(address target, bytes calldata data) external returns (uint256 id) {
        id = ++proposalCount;
        proposals[id] = Proposal(target, data, 0, false, block.timestamp + timelockSeconds);
    }

    function vote(uint256 id) external {
        Proposal storage p = proposals[id];
        require(!voted[id][msg.sender], "already voted");
        uint256 weight = voteToken.balanceOf(msg.sender);
        require(weight > 0, "no weight");
        voted[id][msg.sender] = true;
        p.yesVotes += weight;
    }

    function execute(uint256 id) external {
        Proposal storage p = proposals[id];
        require(!p.executed, "executed");
        require(p.yesVotes >= quorum, "quorum not reached");
        require(block.timestamp >= p.eta, "timelocked");
        p.executed = true;
        (bool ok,) = p.target.call(p.data);
        require(ok, "exec failed");
    }
}
