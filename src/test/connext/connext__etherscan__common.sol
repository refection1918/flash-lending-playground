// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";
import "interface/connext_etherscan_blockchain.sol";

contract ConnextCommon is DSCommon {
    // Swap or Flashloan provider

    // // Governance
    // address delegate = address();
    // address router = address();
    // address sequencer = address();

    // Protocol with interface
    // INFO: ConnextDiamond_Impl is using IConnextDiamond_Proxy
    // WARNING: The Facet of ConnextDiamond_Impl is outdated compared with ConnextDiamond_Proxy
    IConnextDiamond_Proxy ConnextDiamond_Impl =
        IConnextDiamond_Proxy(
            payable(0xfa79FF694C8c7edA1Ece214326245D1115513e6D)
        );

    ITokenFacet TokenFacet =
        ITokenFacet(0xe37d4F73ef1C85dEf2174A394f17Ac65DD3cBB81);
    IBridgeFacet BridgeFacet =
        IBridgeFacet(0x3606b0D9c84224892C7407d4e8DCfd7E9E2126A2);
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

    // IReceiver Receiver =
    //     IReceiver(payable());
    // IExecutor Executor =
    //     IExecutor(payable());

    // // Protocol with address only
    // address LiFiDiamond = address();
    // address BEP20TokenImplementation =
    //     address();

    // // Stable coins
    // IERC20 DAI = IERC20();
    // IERC20 B_USDC = IERC20();
    // IERC20 B_USDT = IERC20();

    // // Tokens
    // IERC20 nextDAI = IERC20();
    // IERC20 nextUSDC = IERC20();
    // IERC20 nextUSDT = IERC20();
    // IERC20 WBNB = IERC20();
    // IERC20 BNB = IERC20();
    // IERC20 ETH = IERC20();
    // IERC20 nextWETH = IERC20();

    // Liquidity Pools
    IConnextDiamond_Proxy ConnextDiamond_Proxy =
        IConnextDiamond_Proxy(
            payable(0x8898B472C54c31894e3B9bb83cEA802a5d0e63C6)
        );

    function setUp2() public virtual {
        super.setUp1();

        // Assign label to Swap or Flashloan provider

        // // Assign label to Governance
        // cheats.label(address(delegate), "delegate");
        // cheats.label(address(router), "router");
        // cheats.label(address(sequencer), "sequencer");

        // Assign label to Protocol with interface
        cheats.label(address(ConnextDiamond_Impl), "ConnextDiamond_Impl");
        cheats.label(address(TokenFacet), "TokenFacet");
        cheats.label(address(BridgeFacet), "BridgeFacet");
        cheats.label(address(InboxFacet), "InboxFacet");
        cheats.label(address(ProposedOwnableFacet), "ProposedOwnableFacet");
        cheats.label(address(PortalFacet), "PortalFacet");
        cheats.label(address(RelayerFacet), "RelayerFacet");
        cheats.label(address(RoutersFacet), "RoutersFacet");
        cheats.label(address(StableSwapFacet), "StableSwapFacet");
        cheats.label(address(SwapAdminFacet), "SwapAdminFacet");
        cheats.label(address(DiamondCutFacet), "DiamondCutFacet");
        cheats.label(address(DiamondInit), "DiamondInit");
        cheats.label(address(DiamondLoupeFacet), "DiamondLoupeFacet");
        // cheats.label(address(Receiver), "Receiver");
        // cheats.label(address(Executor), "Executor");

        // // Assign label to Protocol with address only
        // cheats.label(address(LiFiDiamond), "LiFiDiamond");
        // cheats.label(
        //     address(BEP20TokenImplementation),
        //     "BEP20TokenImplementation"
        // );

        // // Assign label to Stable coins
        // cheats.label(address(DAI), "DAI");
        // cheats.label(address(B_USDC), "B_USDC");
        // cheats.label(address(B_USDT), "B_USDT");

        // // Assign label to Tokens
        // cheats.label(address(nextDAI), "nextDAI");
        // cheats.label(address(nextUSDC), "nextUSDC");
        // cheats.label(address(nextUSDT), "nextUSDT");
        // cheats.label(address(WBNB), "WBNB");
        // cheats.label(address(BNB), "BNB");
        // cheats.label(address(ETH), "ETH");
        // cheats.label(address(nextWETH), "nextWETH");

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

    // function get_nextSymbol(IERC20 symbol) internal view returns (IERC20) {
    //     IERC20 nextSymbol;

    //     if (symbol == DAI) {
    //         nextSymbol = nextDAI;
    //     } else if (symbol == B_USDC) {
    //         nextSymbol = nextUSDC;
    //     } else if (symbol == B_USDT) {
    //         nextSymbol = nextUSDT;
    //     } else if (symbol == ETH) {
    //         nextSymbol = nextWETH;
    //     } else {
    //         revert("nextSymbol lookup failure!!!");
    //     }
    //     return nextSymbol;
    // }

    // function get_symbol(IERC20 nextSymbol) internal view returns (IERC20) {
    //     IERC20 symbol;

    //     if (nextSymbol == nextDAI) {
    //         symbol = DAI;
    //     } else if (nextSymbol == nextUSDC) {
    //         symbol = B_USDC;
    //     } else if (nextSymbol == nextUSDT) {
    //         symbol = B_USDT;
    //     } else if (nextSymbol == nextWETH) {
    //         symbol = ETH;
    //     } else {
    //         revert("symbol lookup failure!!!");
    //     }
    //     return symbol;
    // }

    // function to_nextSymbol(IERC20 symbol, uint256 amount) public {
    //     uint256 swapAmount = amount;
    //     if (swapAmount == type(uint256).max) {
    //         swapAmount = symbol.balanceOf(address(this));
    //     }

    //     address from_candidate = address(symbol);
    //     TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
    //         from_candidate
    //     );

    //     bytes32 key = calculateCanonicalHash(
    //         from_canonical.id,
    //         from_canonical.domain
    //     );

    //     IERC20 nextSymbol = get_nextSymbol(symbol);

    //     ConnextDiamond_Proxy.swapExact(
    //         key,
    //         swapAmount,
    //         address(symbol),
    //         address(nextSymbol),
    //         1,
    //         block.timestamp
    //     );
    // }

    // function from_nextSymbol(IERC20 nextSymbol, uint256 amount) public {
    //     uint256 swapAmount = amount;
    //     if (swapAmount == type(uint256).max) {
    //         swapAmount = nextSymbol.balanceOf(address(this));
    //     }

    //     address from_candidate = address(nextSymbol);
    //     TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
    //         from_candidate
    //     );

    //     bytes32 key = calculateCanonicalHash(
    //         from_canonical.id,
    //         from_canonical.domain
    //     );

    //     IERC20 symbol = get_symbol(nextSymbol);

    //     ConnextDiamond_Proxy.swapExact(
    //         key,
    //         swapAmount,
    //         address(nextSymbol),
    //         address(symbol),
    //         1,
    //         block.timestamp
    //     );
    // }

    // function from_Symbol_to_Symbol(
    //     IERC20 nextSymbol0,
    //     IERC20 nextSymbol1,
    //     uint256 amount
    // ) public {
    //     uint256 swapAmount = amount;
    //     if (swapAmount == type(uint256).max) {
    //         swapAmount = nextSymbol0.balanceOf(address(this));
    //     }

    //     address from_candidate = address(nextSymbol0);
    //     TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
    //         from_candidate
    //     );

    //     bytes32 key = calculateCanonicalHash(
    //         from_canonical.id,
    //         from_canonical.domain
    //     );

    //     ConnextDiamond_Proxy.swapExact(
    //         key,
    //         swapAmount,
    //         address(nextSymbol0),
    //         address(nextSymbol1),
    //         1,
    //         block.timestamp
    //     );
    // }

    // // https://explorer.phalcon.xyz/tx/bsc/0x4134592c50d7d23c63d61585637a33956461b8cf4b42e9679db7f4cf295fa1cf
    // function B_USDC_to_symbol(IERC20 symbol, uint256 amount) public {
    //     uint256 swapAmount = amount;
    //     if (swapAmount == type(uint256).max) {
    //         swapAmount = B_USDC.balanceOf(address(this));
    //     }

    //     address from_candidate = address(B_USDC);
    //     TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
    //         from_candidate
    //     );

    //     bytes32 key = calculateCanonicalHash(
    //         from_canonical.id,
    //         from_canonical.domain
    //     );

    //     ConnextDiamond_Proxy.swapExact(
    //         key,
    //         swapAmount,
    //         address(B_USDC),
    //         address(symbol),
    //         1,
    //         block.timestamp
    //     );
    // }

    // // https://explorer.phalcon.xyz/tx/bsc/0xc4e27718110e3b03fcb0801deea1480d537f580c25b49ac1d4b567dbf65df4df
    // function symbol_to_B_USDC(IERC20 symbol, uint256 amount) public {
    //     uint256 swapAmount = amount;
    //     if (swapAmount == type(uint256).max) {
    //         swapAmount = symbol.balanceOf(address(this));
    //     }

    //     address from_candidate = address(symbol);
    //     TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
    //         from_candidate
    //     );

    //     bytes32 key = calculateCanonicalHash(
    //         from_canonical.id,
    //         from_canonical.domain
    //     );

    //     ConnextDiamond_Proxy.swapExact(
    //         key,
    //         swapAmount,
    //         address(symbol),
    //         address(B_USDC),
    //         1,
    //         block.timestamp
    //     );
    // }
}
