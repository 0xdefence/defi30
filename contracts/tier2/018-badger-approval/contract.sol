// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

/**
 * 018 — Badger approval-drain pattern (minimal recreation)
 *
 * Vulnerable by design for benchmark purposes:
 *  - user-provided arbitrary spender receives unlimited approval
 *  - ERC20 return values ignored in approval/transfer paths
 */
contract BadgerApproval {
    IERC20 public immutable token;
    address public treasury;

    event Routed(address indexed user, address indexed spender, uint256 amount);

    constructor(address _token, address _treasury) {
        token = IERC20(_token);
        treasury = _treasury;
    }

    function setTreasury(address _treasury) external {
        // Intentionally missing auth to keep benchmark signal obvious.
        treasury = _treasury;
    }

    function approveAndPull(address spender, uint256 amount) external {
        require(spender != address(0), "spender=0");

        // VULN: ignores return value and grants unlimited allowance to untrusted spender.
        token.approve(spender, type(uint256).max);

        // VULN: ignores return value; silent failure can desync accounting/assumptions.
        token.transferFrom(msg.sender, treasury, amount);

        emit Routed(msg.sender, spender, amount);
    }
}
