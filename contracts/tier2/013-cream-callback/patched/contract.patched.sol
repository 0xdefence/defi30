// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC777LikeP { function transfer(address to, uint256 amount) external returns (bool); }
interface ICallbackP { function tokensReceived(address user, uint256 amount) external; }

contract CreamCallbackPatched {
    IERC777LikeP public token;
    ICallbackP public callback;
    mapping(address => uint256) public collateral;
    mapping(address => uint256) public debt;
    bool locked;

    constructor(address _token, address _callback) { token = IERC777LikeP(_token); callback = ICallbackP(_callback); }

    modifier nonReentrant() {
        require(!locked, "reentrant");
        locked = true;
        _;
        locked = false;
    }

    function deposit(uint256 amount) external { collateral[msg.sender] += amount; }
    function maxBorrow(address user) public view returns (uint256) { return (collateral[user] * 70) / 100; }

    function borrow(uint256 amount) external nonReentrant {
        require(debt[msg.sender] + amount <= maxBorrow(msg.sender), "insufficient collateral");
        debt[msg.sender] += amount;
        callback.tokensReceived(msg.sender, amount);
        require(token.transfer(msg.sender, amount), "transfer failed");
    }
}
