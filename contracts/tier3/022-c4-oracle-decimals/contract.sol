// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IFeed22 {
    function latestAnswer() external view returns (int256);
}

contract C4OracleDecimals {
    IFeed22 public feed;
    mapping(address => uint256) public collateral;

    constructor(address _feed) { feed = IFeed22(_feed); }

    function deposit(uint256 amount) external { collateral[msg.sender] += amount; }

    function collateralValue(address user) public view returns (uint256) {
        uint256 p = uint256(feed.latestAnswer()); // feed is 1e8, but treated as 1e18
        // vulnerable precision/decimals mismatch
        return collateral[user] * p;
    }
}
