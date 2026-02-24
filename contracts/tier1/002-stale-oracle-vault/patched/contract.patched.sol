// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IOraclePatched {
    function latestPrice() external view returns (uint256 price, uint256 timestamp);
}

contract StaleOracleVaultPatched {
    IOraclePatched public oracle;
    uint256 public maxAge = 1 hours;

    constructor(address _oracle) { oracle = IOraclePatched(_oracle); }

    function getPrice() public view returns (uint256) {
        (uint256 p, uint256 ts) = oracle.latestPrice();
        require(block.timestamp - ts <= maxAge, "stale");
        return p;
    }
}
