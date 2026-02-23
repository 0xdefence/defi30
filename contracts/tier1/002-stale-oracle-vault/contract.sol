// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IOracle {
    function latestPrice() external view returns (uint256 price, uint256 timestamp);
}

contract StaleOracleVault {
    IOracle public oracle;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    function getPrice() public view returns (uint256) {
        (uint256 p, ) = oracle.latestPrice();
        // vulnerable: no staleness check
        return p;
    }
}
