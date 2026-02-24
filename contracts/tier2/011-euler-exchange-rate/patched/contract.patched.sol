// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EulerExchangeRatePatched {
    mapping(address => uint256) public shares;
    mapping(address => uint256) public debt;

    uint256 public totalShares;
    uint256 public totalAssets;
    uint256 public lastRate;
    uint256 public constant LTV_BPS = 7000;

    function exchangeRate() public view returns (uint256) {
        if (totalShares == 0) return 1e18;
        return (totalAssets * 1e18) / totalShares;
    }

    function deposit() external payable {
        uint256 assets = msg.value;
        uint256 minted = (totalShares == 0 || totalAssets == 0) ? assets : (assets * totalShares) / totalAssets;
        shares[msg.sender] += minted;
        totalShares += minted;
        totalAssets += assets;
        lastRate = exchangeRate();
    }

    function donate() external payable {
        revert("donation disabled");
    }

    function collateralValue(address user) public view returns (uint256) {
        uint256 r = lastRate == 0 ? 1e18 : lastRate;
        return (shares[user] * r) / 1e18;
    }
}
