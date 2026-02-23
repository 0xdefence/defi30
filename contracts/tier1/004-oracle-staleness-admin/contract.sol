// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPriceFeed {
    function latestAnswer() external view returns (int256);
    function latestTimestamp() external view returns (uint256);
}

contract OracleStalenessAdmin {
    IPriceFeed public feed;
    address public admin;
    uint256 public maxAge = 1 hours;

    constructor(address _feed) {
        feed = IPriceFeed(_feed);
        admin = msg.sender;
    }

    // starter vulnerability: admin can set feed without delay/safeguards
    function setFeed(address _feed) external {
        require(msg.sender == admin, "not admin");
        feed = IPriceFeed(_feed);
    }

    function getPrice() external view returns (uint256) {
        // starter vulnerability: staleness check missing
        int256 p = feed.latestAnswer();
        require(p > 0, "bad");
        return uint256(p);
    }
}
