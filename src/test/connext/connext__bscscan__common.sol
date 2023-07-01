// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";
import "interface/connext_bscscan_blockchain.sol";
import "interface/pancake_bscscan_flashloan.sol";

contract ConnextCommon is DSCommon {
    // Swap or Flashloan provider
    // // Use test__query_specific_pair() to identify the pancake pair
    // Uni_Pair_V2 DAI_USDC_Pair =
    //     Uni_Pair_V2(0x80e4c159778caED6C5eDd7B1E3e763f8179CADb3);
    // Uni_Pair_V2 USDT_USDC_Pair =
    //     Uni_Pair_V2(0x85F8628BFFF75D08F1Aa415E5C7e85d96bfD7f57);
    // Uni_Pair_V2 ETH_USDC_Pair =
    //     Uni_Pair_V2(0xD6C6C6919070D626aa6671461129ecA3a235dF24);

    // Governance
    address delegate = address(0xe5D55FFcfE2191b71464Dd7dF76D18d8482BA9be);
    address router = address(0xFaAB88015477493cFAa5DFAA533099C590876F21);
    address sequencer = address(0x4fFA5968857a6C8242E4A6Ded2418155D33e82E7);

    // Protocol with interface
    // INFO: ConnextDiamond_Impl is using IConnextDiamond_Proxy
    // WARNING: The Facet of ConnextDiamond_Impl is outdated compared with ConnextDiamond_Proxy
    IConnextDiamond_Proxy ConnextDiamond_Impl =
        IConnextDiamond_Proxy(
            payable(0x191D761a722E13085e4c95B95CbCF3cC4938600a)
        );

    ITokenFacet TokenFacet =
        ITokenFacet(0xe37d4F73ef1C85dEf2174A394f17Ac65DD3cBB81);
    IBridgeFacet BridgeFacet =
        IBridgeFacet(0xC41A071742A1F2ffe76d075205DB90742C113608);
    IInboxFacet InboxFacet =
        IInboxFacet(0x5Ccd25372A41eeB3D4E5353879Bb28213dF5a295);
    IProposedOwnableFacet ProposedOwnableFacet =
        IProposedOwnableFacet(0x086B5A16D7Bd6B2955fCC7d5F9AA2a1544b67e0d);
    IPortalFacet PortalFacet =
        IPortalFacet(0x7993Bb17D8D8A0676Cc1527f8b4CE52A2B490352);
    IRelayerFacet RelayerFacet =
        IRelayerFacet(0xcCb64fDf1c0Cc1aac1C39E5968E82f89c1B8C769);
    IRoutersFacet RoutersFacet =
        IRoutersFacet(0xBe8D8Ac9a44fBa6cb7A7E02c1E6576E06C7da72D);
    IStableSwapFacet StableSwapFacet =
        IStableSwapFacet(0x9AB5F562Dc2aCcCd1b80d6564B770786e38f0686);
    ISwapAdminFacet SwapAdminFacet =
        ISwapAdminFacet(0x6369F971fd1f1f230B8584151Ed7747FF710Cc68);
    IDiamondCutFacet DiamondCutFacet =
        IDiamondCutFacet(0x324c5834cD3bD19c4991F4fC5b3a0Ff5257a692b);
    IDiamondInit DiamondInit =
        IDiamondInit(0x44e799f47A5599f5c9158d1F2457E30A6D77aDb4);
    IDiamondLoupeFacet DiamondLoupeFacet =
        IDiamondLoupeFacet(0x3Bcf4185443A339517aD4e580067f178d1B68E1D);

    IReceiver Receiver =
        IReceiver(payable(0x74674DAFd6f4495e7F63F7637E94b8B89B2f01dB));
    IExecutor Executor =
        IExecutor(payable(0xDD1305150D27aecc60C066630105DB419977e367));

    // Protocol with address only
    address LiFiDiamond = address(0x1231DEB6f5749EF6cE6943a275A1D3E7486F4EaE);
    address BEP20TokenImplementation =
        address(0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C);

    // Stable coins
    IERC20 DAI = IERC20(0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3);
    IERC20 B_USDC = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
    IERC20 B_USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);

    // Tokens
    IERC20 nextDAI = IERC20(0x86a343BCF17D79C475d300eed35F0145F137D0c9);
    IERC20 nextUSDC = IERC20(0x5e7D83dA751F4C9694b13aF351B30aC108f32C38);
    IERC20 nextUSDT = IERC20(0xD609f26B5547d5E31562B29150769Cb7c774B97a);
    IERC20 WBNB = IERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    IERC20 BNB = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    IERC20 ETH = IERC20(0x2170Ed0880ac9A755fd29B2688956BD959F933F8);
    IERC20 nextWETH = IERC20(0xA9CB51C666D2AF451d87442Be50747B31BB7d805);

    // Liquidity Pools
    IConnextDiamond_Proxy ConnextDiamond_Proxy =
        IConnextDiamond_Proxy(
            payable(0xCd401c10afa37d641d2F594852DA94C700e4F2CE)
        );

    function setUp2() public virtual {
        super.setUp1();

        // Assign label to Swap or Flashloan provider
        // cheats.label(address(DAI_USDC_Pair), "DAI_USDC_Pair");
        // cheats.label(address(USDT_USDC_Pair), "USDT_USDC_Pair");
        // cheats.label(address(ETH_USDC_Pair), "ETH_USDC_Pair");

        // Assign label to Governance
        cheats.label(address(delegate), "delegate");
        cheats.label(address(router), "router");
        cheats.label(address(sequencer), "sequencer");

        // Assign label to Protocol with interface
        cheats.label(address(ConnextDiamond_Impl), "ConnextDiamond_Impl");
        cheats.label(address(TokenFacet), "TokenFacet");
        cheats.label(address(BridgeFacet), "BridgeFacet");
        cheats.label(address(InboxFacet), "InboxFacet");
        cheats.label(address(PortalFacet), "PortalFacet");
        cheats.label(address(RelayerFacet), "RelayerFacet");
        cheats.label(address(RoutersFacet), "RoutersFacet");
        cheats.label(address(StableSwapFacet), "StableSwapFacet");
        cheats.label(address(SwapAdminFacet), "SwapAdminFacet");
        cheats.label(address(DiamondCutFacet), "DiamondCutFacet");
        cheats.label(address(DiamondInit), "DiamondInit");
        cheats.label(address(DiamondLoupeFacet), "DiamondLoupeFacet");
        cheats.label(address(Receiver), "Receiver");
        cheats.label(address(Executor), "Executor");

        // Assign label to Protocol with address only
        cheats.label(address(LiFiDiamond), "LiFiDiamond");
        cheats.label(
            address(BEP20TokenImplementation),
            "BEP20TokenImplementation"
        );

        // Assign label to Stable coins
        cheats.label(address(DAI), "DAI");
        cheats.label(address(B_USDC), "B_USDC");
        cheats.label(address(B_USDT), "B_USDT");

        // Assign label to Tokens
        cheats.label(address(nextDAI), "nextDAI");
        cheats.label(address(nextUSDC), "nextUSDC");
        cheats.label(address(nextUSDT), "nextUSDT");
        cheats.label(address(WBNB), "WBNB");
        cheats.label(address(BNB), "BNB");
        cheats.label(address(ETH), "ETH");
        cheats.label(address(nextWETH), "nextWETH");

        // Assign label to Liquidity Pools
        cheats.label(address(ConnextDiamond_Proxy), "ConnextDiamond_Proxy");
    }

    /**
     * @notice Calculates the hash of canonical ID and domain.
     * @dev This hash is used as the key for many asset-related mappings.
     * @param _id Canonical ID.
     * @param _domain Canonical domain.
     * @return bytes32 Canonical hash, used as key for accessing token info from mappings.
     */
    function calculateCanonicalHash(
        bytes32 _id,
        uint32 _domain
    ) internal pure returns (bytes32) {
        return keccak256(abi.encode(_id, _domain));
    }

    function get_nextSymbol(IERC20 symbol) internal view returns (IERC20) {
        IERC20 nextSymbol;

        if (symbol == DAI) {
            nextSymbol = nextDAI;
        } else if (symbol == B_USDC) {
            nextSymbol = nextUSDC;
        } else if (symbol == B_USDT) {
            nextSymbol = nextUSDT;
        } else if (symbol == ETH) {
            nextSymbol = nextWETH;
        } else {
            revert("nextSymbol lookup failure!!!");
        }
        return nextSymbol;
    }

    function get_symbol(IERC20 nextSymbol) internal view returns (IERC20) {
        IERC20 symbol;

        if (nextSymbol == nextDAI) {
            symbol = DAI;
        } else if (nextSymbol == nextUSDC) {
            symbol = B_USDC;
        } else if (nextSymbol == nextUSDT) {
            symbol = B_USDT;
        } else if (nextSymbol == nextWETH) {
            symbol = ETH;
        } else {
            revert("symbol lookup failure!!!");
        }
        return symbol;
    }

    function to_nextSymbol(IERC20 symbol, uint256 amount) public {
        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = symbol.balanceOf(address(this));
        }

        address from_candidate = address(symbol);
        TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
            from_candidate
        );

        bytes32 key = calculateCanonicalHash(
            from_canonical.id,
            from_canonical.domain
        );

        IERC20 nextSymbol = get_nextSymbol(symbol);

        ConnextDiamond_Proxy.swapExact(
            key,
            swapAmount,
            address(symbol),
            address(nextSymbol),
            1,
            block.timestamp
        );
    }

    function from_nextSymbol(IERC20 nextSymbol, uint256 amount) public {
        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = nextSymbol.balanceOf(address(this));
        }

        address from_candidate = address(nextSymbol);
        TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
            from_candidate
        );

        bytes32 key = calculateCanonicalHash(
            from_canonical.id,
            from_canonical.domain
        );

        IERC20 symbol = get_symbol(nextSymbol);

        ConnextDiamond_Proxy.swapExact(
            key,
            swapAmount,
            address(nextSymbol),
            address(symbol),
            1,
            block.timestamp
        );
    }

    function from_Symbol_to_Symbol(
        IERC20 nextSymbol0,
        IERC20 nextSymbol1,
        uint256 amount
    ) public {
        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = nextSymbol0.balanceOf(address(this));
        }

        address from_candidate = address(nextSymbol0);
        TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
            from_candidate
        );

        bytes32 key = calculateCanonicalHash(
            from_canonical.id,
            from_canonical.domain
        );

        ConnextDiamond_Proxy.swapExact(
            key,
            swapAmount,
            address(nextSymbol0),
            address(nextSymbol1),
            1,
            block.timestamp
        );
    }

    // https://explorer.phalcon.xyz/tx/bsc/0x4134592c50d7d23c63d61585637a33956461b8cf4b42e9679db7f4cf295fa1cf
    function B_USDC_to_symbol(IERC20 symbol, uint256 amount) public {
        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = B_USDC.balanceOf(address(this));
        }

        address from_candidate = address(B_USDC);
        TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
            from_candidate
        );

        bytes32 key = calculateCanonicalHash(
            from_canonical.id,
            from_canonical.domain
        );

        ConnextDiamond_Proxy.swapExact(
            key,
            swapAmount,
            address(B_USDC),
            address(symbol),
            1,
            block.timestamp
        );
    }

    // https://explorer.phalcon.xyz/tx/bsc/0xc4e27718110e3b03fcb0801deea1480d537f580c25b49ac1d4b567dbf65df4df
    function symbol_to_B_USDC(IERC20 symbol, uint256 amount) public {
        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = symbol.balanceOf(address(this));
        }

        address from_candidate = address(symbol);
        TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
            from_candidate
        );

        bytes32 key = calculateCanonicalHash(
            from_canonical.id,
            from_canonical.domain
        );

        ConnextDiamond_Proxy.swapExact(
            key,
            swapAmount,
            address(symbol),
            address(B_USDC),
            1,
            block.timestamp
        );
    }
}
