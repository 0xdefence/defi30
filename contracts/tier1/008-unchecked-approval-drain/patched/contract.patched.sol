// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20Safe {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract UncheckedApprovalDrainPatched {
    IERC20Safe public token;
    address public spender;
    uint256 public constant MAX_APPROVAL = 1e24;

    constructor(address _token, address _spender) {
        token = IERC20Safe(_token);
        spender = _spender;
    }

    function sweep(address from, uint256 amount) external {
        require(token.transferFrom(from, address(this), amount), "transferFrom failed");
    }

    function setLimitedApproval(uint256 amount) external {
        require(amount <= MAX_APPROVAL, "too large");
        require(token.approve(spender, amount), "approve failed");
    }
}
