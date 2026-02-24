// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20Patched {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract BadgerApprovalPatched {
    IERC20Patched public immutable token;
    address public treasury;
    address public immutable trustedSpender;

    constructor(address _token, address _treasury, address _trustedSpender) {
        token = IERC20Patched(_token);
        treasury = _treasury;
        trustedSpender = _trustedSpender;
    }

    function approveAndPull(address spender, uint256 amount) external {
        require(spender == trustedSpender, "untrusted spender");
        require(token.approve(spender, amount), "approve failed");
        require(token.transferFrom(msg.sender, treasury, amount), "transferFrom failed");
    }
}
