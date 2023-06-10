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
}
