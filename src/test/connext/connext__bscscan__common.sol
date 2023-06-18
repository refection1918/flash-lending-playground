// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";
import "interface/connext_bscscan_blockchain.sol";

contract ConnextCommon is DSCommon {
    // Flashloan provider

    // Governance
    address delegate = address(0xe5D55FFcfE2191b71464Dd7dF76D18d8482BA9be);
    address router = address(0xFaAB88015477493cFAa5DFAA533099C590876F21);
    address sequencer = address(0x4fFA5968857a6C8242E4A6Ded2418155D33e82E7);

    // Protocol with interface
    // INFO: ConnextDiamond_Impl is using IConnextDiamond_Proxy
    IConnextDiamond_Proxy ConnextDiamond_Impl = IConnextDiamond_Proxy(payable(0x191D761a722E13085e4c95B95CbCF3cC4938600a));
    IDiamondLoupeFacet DiamondLoupeFacet = IDiamondLoupeFacet(0x3Bcf4185443A339517aD4e580067f178d1B68E1D);
    IBridgeFacet BridgeFacet = IBridgeFacet(0xC41A071742A1F2ffe76d075205DB90742C113608);
    IStableSwapFacet StableSwapFacet = IStableSwapFacet(0x9AB5F562Dc2aCcCd1b80d6564B770786e38f0686);
    IReceiver Receiver = IReceiver(payable(0x74674DAFd6f4495e7F63F7637E94b8B89B2f01dB));
    IExecutor Executor = IExecutor(payable(0xDD1305150D27aecc60C066630105DB419977e367));

    // Protocol with address only
    address LiFiDiamond = address(0x1231DEB6f5749EF6cE6943a275A1D3E7486F4EaE);

    // Stable coins
    IERC20 USDC = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);

    // Tokens
    IERC20 BSC_USD = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IERC20 WBNB = IERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    address BNB = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    // Liquidity Pools
    IConnextDiamond_Proxy ConnextDiamond_Proxy = IConnextDiamond_Proxy(payable(0xCd401c10afa37d641d2F594852DA94C700e4F2CE));

    function setUp() public virtual {
        // Assign label to Flashloan provider

        // Assign label to Governance
        cheats.label(address(delegate), "delegate");
        cheats.label(address(router), "router");
        cheats.label(address(sequencer), "sequencer");

        // Assign label to Protocol with interface
        cheats.label(address(ConnextDiamond_Impl), "ConnextDiamond_Impl");
        cheats.label(address(BridgeFacet), "BridgeFacet");
        cheats.label(address(DiamondLoupeFacet), "DiamondLoupeFacet");
        cheats.label(address(StableSwapFacet), "StableSwapFacet");
        cheats.label(address(Receiver), "Receiver");
        cheats.label(address(Executor), "Executor");

        // Assign label to Protocol with address only
        cheats.label(address(LiFiDiamond), "LiFiDiamond");

        // Assign label to Stable coins
        cheats.label(address(USDC), "USDC");

        // Assign label to Tokens
        cheats.label(address(BSC_USD), "BSC_USD");
        cheats.label(address(WBNB), "WBNB");
        cheats.label(address(BNB), "BNB");

        // Assign label to Liquidity Pools
        cheats.label(address(ConnextDiamond_Proxy), "ConnextDiamond_Proxy");
    }
}