// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAmmPairP016 {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32);
}

contract MangoOraclePatched {
    IAmmPairP016 public pair;
    mapping(address => uint256) public collateralUnits;

    uint256 public constant LTV_BPS = 7500;
    uint256 public lastSafePrice;

    constructor(address _pair) {
        pair = IAmmPairP016(_pair);
        lastSafePrice = 1e18;
    }

    function spotPrice() public view returns (uint256) {
        (uint112 base, uint112 quote, ) = pair.getReserves();
        require(base > 0 && quote > 0, "bad reserves");
        return (uint256(quote) * 1e18) / uint256(base);
    }

    function updatePrice() external {
        uint256 p = spotPrice();
        // basic deviation guard from last accepted price
        uint256 hi = (lastSafePrice * 120) / 100;
        uint256 lo = (lastSafePrice * 80) / 100;
        require(p <= hi && p >= lo, "deviation too large");
        lastSafePrice = p;
    }

    function depositCollateral(uint256 units) external {
        collateralUnits[msg.sender] += units;
    }

    function collateralValue(address user) public view returns (uint256) {
        return (collateralUnits[user] * lastSafePrice) / 1e18;
    }
}
