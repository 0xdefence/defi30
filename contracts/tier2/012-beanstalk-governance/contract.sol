// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVoteToken {
    function balanceOf(address account) external view returns (uint256);
}

/**
 * Minimal recreation of governance flash-loan weakness.
 *
 * Core bug: voting power is read from current balance (no snapshot) and
 * execution has no enforced timelock.
 */
contract BeanstalkGovernance {
    IVoteToken public immutable voteToken;
    uint256 public proposalCount;

    struct Proposal {
        address target;
        bytes data;
        uint256 yesVotes;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public voted;

    uint256 public quorum = 1_000_000 ether; // sample threshold

    event Proposed(uint256 indexed id, address indexed proposer);
    event Voted(uint256 indexed id, address indexed voter, uint256 weight);
    event Executed(uint256 indexed id);

    constructor(address _voteToken) {
        voteToken = IVoteToken(_voteToken);
    }

    function propose(address target, bytes calldata data) external returns (uint256 id) {
        id = ++proposalCount;
        proposals[id] = Proposal({target: target, data: data, yesVotes: 0, executed: false});
        emit Proposed(id, msg.sender);
    }

    function vote(uint256 id) external {
        Proposal storage p = proposals[id];
        require(!p.executed, "executed");
        require(!voted[id][msg.sender], "already voted");

        // Vulnerable: current-balance voting; flash-loaned balances count.
        uint256 weight = voteToken.balanceOf(msg.sender);
        require(weight > 0, "no weight");

        voted[id][msg.sender] = true;
        p.yesVotes += weight;
        emit Voted(id, msg.sender, weight);
    }

    function execute(uint256 id) external {
        Proposal storage p = proposals[id];
        require(!p.executed, "executed");

        // Vulnerable: no timelock/cooldown between passing and execution.
        require(p.yesVotes >= quorum, "quorum not reached");

        p.executed = true;
        (bool ok, ) = p.target.call(p.data);
        require(ok, "exec failed");

        emit Executed(id);
    }
}
