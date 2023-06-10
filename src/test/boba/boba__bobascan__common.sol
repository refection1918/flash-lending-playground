// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./boba__common.sol";
import "interface/boba_bobascan_blockchain.sol";

contract BobaBobascanCommon is BobaCommon {
    // Flashloan provider

    // Governance

    // Protocol with interface

    // Protocol with address only

    // Stable coins
    IERC20 USDT = IERC20(0x5DE1677344D3Cb0D7D465c10b72A8f60699C062d);
    IERC20 BOBA = IERC20(0xa18bF3994C0Cc6E3b63ac420308E5383f53120D7);
    IERC20 DODO = IERC20(0x572c5B5BF34f75FB62c39b9BFE9A75bb0bb47984);
    IERC20 OMG = IERC20(0xe1E2ec9a85C607092668789581251115bCBD20de);

    // Tokens

    // Liquidity Pools
    IOVM_SequencerFeeVault OVM_SequencerFeeVault = IOVM_SequencerFeeVault(payable(0x4200000000000000000000000000000000000011));

    function setUp() public virtual {
        // Assign label to Flashloan provider

        // Assign label to governance

        // Assign label to protocol

        // Assign label to tokens
        cheats.label(address(USDT), "USDT");
        cheats.label(address(BOBA), "BOBA");
        cheats.label(address(DODO), "DODO");
        cheats.label(address(OMG), "OMG");

        // Assign label to LPs
        cheats.label(address(OVM_SequencerFeeVault), "OVM_SequencerFeeVault");
    }
}