// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAmmPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32);
}

/**
 * Minimal recreation of thin-liquidity oracle manipulation.
 *
 * Core bug: collateral valuation uses AMM spot reserve ratio directly,
 * which can be temporarily manipulated.
 */
contract MangoOracle {
    IAmmPair public pair;
    mapping(address => uint256) public collateralUnits;
    mapping(address => uint256) public debt;

    uint256 public constant LTV_BPS = 7500;

    event DepositCollateral(address indexed user, uint256 units);
    event Borrow(address indexed user, uint256 amount);

    constructor(address _pair) {
        pair = IAmmPair(_pair);
    }

    function spotPrice() public view returns (uint256) {
        (uint112 base, uint112 quote, ) = pair.getReserves();
        require(base > 0 && quote > 0, "bad reserves");
        // Vulnerable: direct spot reserve ratio; no TWAP/outlier controls.
        return (uint256(quote) * 1e18) / uint256(base);
    }

    function depositCollateral(uint256 units) external {
        require(units > 0, "zero");
        collateralUnits[msg.sender] += units;
        emit DepositCollateral(msg.sender, units);
    }

    function collateralValue(address user) public view returns (uint256) {
        return (collateralUnits[user] * spotPrice()) / 1e18;
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "zero");

        uint256 maxBorrow = (collateralValue(msg.sender) * LTV_BPS) / 10_000;
        require(debt[msg.sender] + amount <= maxBorrow, "insufficient collateral");

        debt[msg.sender] += amount;
        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "send failed");

        emit Borrow(msg.sender, amount);
    }
}
