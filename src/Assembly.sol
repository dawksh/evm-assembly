// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Assembly {
    function airdropETH(
        address[] calldata recipients,
        uint256[] calldata amount
    ) external payable {
        assembly {
            // store current ETH spent
            let total := 0
            // store length of amounts
            let len := amount.length

            for {
                let i := 0
            } lt(i, len) {
                i := add(i, 1)
            } {
                // setting offset bc 20 bytes of address
                let offset := mul(i, 0x20)
                // store value
                let amt := calldataload(add(amount.offset, offset))
                // store receipient
                let addr := calldataload(add(recipients.offset, offset))

                let success := call(
                    gas(),
                    addr, //recipient address
                    amt, // amount
                    0,
                    0,
                    0,
                    0
                )
                if iszero(success) {
                    revert(0, 0)
                }
                total := add(total, amt)
            }
            if iszero(eq(total, callvalue())) {
                revert(0, 0)
            }
        }
    }

    function airdropETHNative(
        address[] calldata recipients,
        uint256[] calldata amount
    ) external payable {
        uint256 len = amount.length;
        uint256 used = 0;
        for (uint256 i = 0; i < len; ) {
            uint256 amt = amount[i];
            (bool s, ) = address(recipients[i]).call{value: amt}("");
            if (!s) revert();
            used += amt;

            unchecked {
                i++;
            }
        }
        if (used != msg.value) revert();
    }
}
