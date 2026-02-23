// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISpotOracle {
    function spotPrice() external view returns (uint256);
}

contract FlashLoanLiquidator {
    ISpotOracle public oracle;
    mapping(address => uint256) public debt;

    constructor(address _oracle) {
        oracle = ISpotOracle(_oracle);
    }

    function liquidate(address user) external {
        uint256 p = oracle.spotPrice(); // vulnerable: manipulable spot source
        require(p > 0, "bad price");

        // starter vulnerability: liquidation threshold directly tied to spot
        if (debt[user] > p) {
            debt[user] = 0;
            // simplified payout logic omitted
        }
    }
}
