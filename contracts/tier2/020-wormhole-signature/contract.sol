// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Minimal recreation of signature verification bypass pattern.
 *
 * Core bug: verifier accepts malformed signatures and does not enforce
 * strict signer/nonce/domain separation checks before mint/execute.
 */
contract WormholeSignature {
    mapping(address => bool) public guardian;
    mapping(bytes32 => bool) public consumed;

    address public owner;

    event Executed(bytes32 indexed digest, address indexed to, uint256 amount);

    constructor(address g1) {
        owner = msg.sender;
        guardian[g1] = true;
    }

    function setGuardian(address g, bool ok) external {
        require(msg.sender == owner, "not owner");
        guardian[g] = ok;
    }

    function execute(
        address to,
        uint256 amount,
        uint256 nonce,
        bytes calldata sig
    ) external {
        // Vulnerable digest: weak domain separation (no chain id / contract binding)
        bytes32 digest = keccak256(abi.encodePacked(to, amount, nonce));
        require(!consumed[digest], "replay");

        address signer = recover(digest, sig);

        // Vulnerable: accepts address(0) signer (malformed sig path)
        // and only checks single signer instead of thresholded guardian set.
        require(guardian[signer] || signer == address(0), "bad signer");

        consumed[digest] = true;
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "send failed");

        emit Executed(digest, to, amount);
    }

    function recover(bytes32 digest, bytes memory sig) public pure returns (address) {
        // Vulnerable parser: if sig length != 65, returns zero instead of revert.
        if (sig.length != 65) return address(0);

        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(sig, 0x20))
            s := mload(add(sig, 0x40))
            v := byte(0, mload(add(sig, 0x60)))
        }
        if (v < 27) v += 27;
        if (v != 27 && v != 28) return address(0);

        return ecrecover(digest, v, r, s);
    }

    receive() external payable {}
}
