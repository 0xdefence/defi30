// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract UncheckedApprovalDrain {
    IERC20 public token;
    address public spender;

    constructor(address _token, address _spender) {
        token = IERC20(_token);
        spender = _spender;
    }

    function sweep(address from, uint256 amount) external {
        // starter vulnerability: unchecked return value
        token.transferFrom(from, address(this), amount);
    }

    function setUnlimitedApproval() external {
        // starter vulnerability: unsafe unlimited approval path
        token.approve(spender, type(uint256).max);
    }
}
