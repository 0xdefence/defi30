// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../patched/contract.patched.sol";

contract MockTokenP is IERC777LikeP { function transfer(address, uint256) external pure returns (bool) { return true; } }

contract ReenterCallbackP is ICallbackP {
    CreamCallbackPatched public c;
    bool entered;
    constructor(address _c) { c = CreamCallbackPatched(_c); }
    function tokensReceived(address, uint256 amount) external {
        if (!entered) {
            entered = true;
            try c.borrow(amount) { revert("should not reenter"); } catch {}
        }
    }
}

contract Patch_013_cream_callback is Test {
    function testPatch_BlocksReentrantBorrow() public {
        MockTokenP t = new MockTokenP();
        CreamCallbackPatched c = new CreamCallbackPatched(address(t), address(0));
        ReenterCallbackP cb = new ReenterCallbackP(address(c));
        c = new CreamCallbackPatched(address(t), address(cb));
        c.deposit(100);
        c.borrow(70);
        assertEq(c.debt(address(this)), 70, "debt should only update once");
    }
}
