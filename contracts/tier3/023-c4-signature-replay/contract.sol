// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4SignatureReplay {
    mapping(address => bool) public signer;

    constructor(address s) { signer[s] = true; }

    function execute(address to, uint256 amount, bytes32 digest, bytes calldata sig) external {
        address r = recover(digest, sig);
        require(signer[r], "bad signer");
        // vulnerable: no consumed[digest]/nonce replay guard
        (bool ok,) = to.call{value: amount}("");
        require(ok, "send failed");
    }

    function recover(bytes32 digest, bytes memory sig) public pure returns (address) {
        require(sig.length == 65, "bad sig len");
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(sig, 0x20))
            s := mload(add(sig, 0x40))
            v := byte(0, mload(add(sig, 0x60)))
        }
        if (v < 27) v += 27;
        return ecrecover(digest, v, r, s);
    }

    receive() external payable {}
}
