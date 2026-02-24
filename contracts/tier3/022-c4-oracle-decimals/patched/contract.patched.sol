// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IFeed22P {
    function latestAnswer() external view returns (int256);
}

contract C4OracleDecimalsPatched {
    IFeed22P public feed;
    mapping(address => uint256) public collateral;

    constructor(address _feed) { feed = IFeed22P(_feed); }

    function deposit(uint256 amount) external { collateral[msg.sender] += amount; }

    function collateralValue(address user) public view returns (uint256) {
        uint256 p8 = uint256(feed.latestAnswer());
        uint256 p18 = p8 * 1e10; // 1e8 -> 1e18
        return (collateral[user] * p18) / 1e18;
    }
}
