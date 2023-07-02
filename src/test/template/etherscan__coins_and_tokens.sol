// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";
import "interface/etherscan_blockchain.sol";

contract EtherscanCommon is DSCommon {
    // Refer to https://etherscan.io/tokens

    // Stable coins
    ITetherToken USDT =
        ITetherToken(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IFiatTokenV2_1 USDC =
        IFiatTokenV2_1(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IDAI DAI = IDAI(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    // Tokens

    function setUp2() public virtual {
        super.setUp1();

        // Assign label to Stable coins
        cheats.label(address(USDC), "USDC");
        cheats.label(address(USDT), "USDT");
        cheats.label(address(DAI), "DAI");

        // Assign label to tokens
    }
}
