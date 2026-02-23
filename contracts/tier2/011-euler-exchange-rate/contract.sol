// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Minimal recreation pattern inspired by exchange-rate manipulation incidents.
 *
 * Core bug: collateral valuation uses a manipulable exchange rate that can be
 * inflated via donation before borrow checks.
 */
contract EulerExchangeRate {
    mapping(address => uint256) public shares;
    mapping(address => uint256) public debt;

    uint256 public totalShares;
    uint256 public totalAssets;

    uint256 public constant LTV_BPS = 7000; // 70%

    event Deposit(address indexed user, uint256 assets, uint256 mintedShares);
    event Donate(address indexed user, uint256 assets);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);

    function exchangeRate() public view returns (uint256) {
        if (totalShares == 0) return 1e18;
        return (totalAssets * 1e18) / totalShares;
    }

    function deposit() external payable {
        uint256 assets = msg.value;
        uint256 minted;
        if (totalShares == 0 || totalAssets == 0) {
            minted = assets;
        } else {
            minted = (assets * totalShares) / totalAssets;
        }

        shares[msg.sender] += minted;
        totalShares += minted;
        totalAssets += assets;

        emit Deposit(msg.sender, assets, minted);
    }

    // Vulnerable primitive: direct donation pumps exchangeRate for all shares.
    function donate() external payable {
        require(msg.value > 0, "zero");
        totalAssets += msg.value;
        emit Donate(msg.sender, msg.value);
    }

    function collateralValue(address user) public view returns (uint256) {
        // Vulnerable valuation path: instantly trusts current exchange rate.
        return (shares[user] * exchangeRate()) / 1e18;
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

    function repay() external payable {
        uint256 pay = msg.value;
        require(pay > 0, "zero");
        if (pay > debt[msg.sender]) pay = debt[msg.sender];
        debt[msg.sender] -= pay;
        emit Repay(msg.sender, pay);
    }
}
