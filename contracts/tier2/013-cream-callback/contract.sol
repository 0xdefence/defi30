// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC777Like {
    function transfer(address to, uint256 amount) external returns (bool);
}

interface ICallback {
    function tokensReceived(address user, uint256 amount) external;
}

/**
 * Minimal recreation of callback-driven reentrancy in lending flows.
 *
 * Core bug: external callback + token transfer happen before debt state update.
 */
contract CreamCallback {
    IERC777Like public token;
    ICallback public callback;

    mapping(address => uint256) public collateral;
    mapping(address => uint256) public debt;

    event Deposit(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);

    constructor(address _token, address _callback) {
        token = IERC777Like(_token);
        callback = ICallback(_callback);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "zero");
        collateral[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    function maxBorrow(address user) public view returns (uint256) {
        return (collateral[user] * 70) / 100;
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "zero");
        require(debt[msg.sender] + amount <= maxBorrow(msg.sender), "insufficient collateral");

        // Vulnerable ordering: callback + transfer before debt update.
        callback.tokensReceived(msg.sender, amount);
        bool ok = token.transfer(msg.sender, amount);
        require(ok, "transfer failed");

        debt[msg.sender] += amount;
        emit Borrow(msg.sender, amount);
    }
}
