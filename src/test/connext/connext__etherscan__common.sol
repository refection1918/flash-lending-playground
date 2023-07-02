// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/etherscan__coins_and_tokens.sol";
import "interface/connext_etherscan_blockchain.sol";

contract ConnextEtherscanCommon is EtherscanCommon {
    // Swap or Flashloan provider

    // Governance

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

    // Protocol with address only

    // Stable coins

    // Tokens

    // Liquidity Pools
    IConnextDiamond_Proxy ConnextDiamond_Proxy =
        IConnextDiamond_Proxy(
            payable(0x8898B472C54c31894e3B9bb83cEA802a5d0e63C6)
        );

    function setUp3() public virtual {
        super.setUp2();

        // Assign label to Swap or Flashloan provider

        // Assign label to Governance

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

        // Assign label to Protocol with address only

        // Assign label to Stable coins

        // Assign label to Tokens

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
}
