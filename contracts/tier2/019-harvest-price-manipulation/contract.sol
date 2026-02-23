// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAMM {
    function getSpotPrice() external view returns (uint256);
}

/**
 * Minimal recreation of vault accounting abuse via AMM spot manipulation.
 *
 * Core bug: share minting and share redemption both trust manipulable spot price.
 */
contract HarvestPriceManipulation {
    IAMM public amm;

    mapping(address => uint256) public shares;
    uint256 public totalShares;

    event Deposit(address indexed user, uint256 amount, uint256 mintedShares);
    event Withdraw(address indexed user, uint256 burnedShares, uint256 returnedAssets);

    constructor(address _amm) {
        amm = IAMM(_amm);
    }

    function spot() public view returns (uint256) {
        // Vulnerable: direct AMM spot usage without TWAP/deviation controls.
        return amm.getSpotPrice();
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "zero");

        // Vulnerable mint path: manipulated spot can over-mint shares.
        uint256 minted = (amount * 1e18) / spot();
        shares[msg.sender] += minted;
        totalShares += minted;

        emit Deposit(msg.sender, amount, minted);
    }

    function withdraw(uint256 burnShares) external {
        require(burnShares > 0, "zero");
        require(shares[msg.sender] >= burnShares, "insufficient shares");

        // Vulnerable redemption path: manipulated spot can over-redeem assets.
        uint256 assetsOut = (burnShares * spot()) / 1e18;

        shares[msg.sender] -= burnShares;
        totalShares -= burnShares;

        (bool ok, ) = msg.sender.call{value: assetsOut}("");
        require(ok, "send failed");

        emit Withdraw(msg.sender, burnShares, assetsOut);
    }

    receive() external payable {}
}
