// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Assembly.sol";

contract AssemblyTest is Test {
    Assembly public ass;
    address[] internal adds = [
        address(0xA93DFf7336fd200cE30Bc25F5BFE46b74D2248b5),
        address(0x5e009E6c786Ce23eB95338b8740E66d243520D2f),
        address(0xACB471904C26D1FFE1fD0AA88b75944C513af361)
    ];
    uint256[] internal amounts = [0.1 ether, 0.2 ether, 0.3 ether];

    function setUp() public {
        ass = new Assembly();
    }

    function testAirdrop() public {
        ass.airdropETH{value: 0.6 ether}(adds, amounts);
    }

    function testNativeAirdrop() public {
        ass.airdropETHNative{value: 0.6 ether}(adds, amounts);
    }
}
