// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAMMP019 {
    function getSpotPrice() external view returns (uint256);
}

contract HarvestPriceManipulationPatched {
    IAMMP019 public amm;
    mapping(address => uint256) public shares;
    uint256 public totalShares;
    uint256 public lastSafePrice;

    constructor(address _amm) {
        amm = IAMMP019(_amm);
        lastSafePrice = 1e18;
    }

    function spot() public view returns (uint256) {
        return amm.getSpotPrice();
    }

    function syncPrice() external {
        uint256 p = spot();
        uint256 hi = (lastSafePrice * 120) / 100;
        uint256 lo = (lastSafePrice * 80) / 100;
        require(p <= hi && p >= lo, "deviation too large");
        lastSafePrice = p;
    }

    function deposit(uint256 amount) external {
        uint256 minted = (amount * 1e18) / lastSafePrice;
        shares[msg.sender] += minted;
        totalShares += minted;
    }

    function withdraw(uint256 burnShares) external {
        require(shares[msg.sender] >= burnShares, "insufficient shares");
        uint256 assetsOut = (burnShares * lastSafePrice) / 1e18;
        shares[msg.sender] -= burnShares;
        totalShares -= burnShares;
        (bool ok,) = msg.sender.call{value: assetsOut}("");
        require(ok, "send failed");
    }

    receive() external payable {}
}
