// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPriceFeedPatched {
    function latestAnswer() external view returns (int256);
    function latestTimestamp() external view returns (uint256);
}

contract OracleStalenessAdminPatched {
    IPriceFeedPatched public feed;
    address public admin;
    uint256 public maxAge = 1 hours;

    constructor(address _feed) {
        feed = IPriceFeedPatched(_feed);
        admin = msg.sender;
    }

    function setFeed(address _feed) external {
        require(msg.sender == admin, "not admin");
        feed = IPriceFeedPatched(_feed);
    }

    function getPrice() external view returns (uint256) {
        require(block.timestamp - feed.latestTimestamp() <= maxAge, "stale");
        int256 p = feed.latestAnswer();
        require(p > 0, "bad");
        return uint256(p);
    }
}
