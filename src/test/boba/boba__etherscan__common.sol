// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./boba__common.sol";
import "interface/boba_etherscan_blockchain.sol";

contract BobaEtherscanCommon is BobaCommon {
    // Flashloan provider

    // Governance
    address L2__BatchMessageRelayer = address(0x5273a421Ef862DfCeFb9144F7C90fdC6342Ad462);
    address ProxyAdmin = address(0x1f2414D0af8741Bc822dBc2f88069c2b2907a840);

    // Protocol with interface
    IL1MultiMessageRelayer L1__MultiMessageRelayer = IL1MultiMessageRelayer(0x5fD2CF99586B9D92f56CbaD0A3Ea4DF256A0070B);

    // Protocol with address only
    address Proxy_OVM_L1CrossDomainMessenger = address(0x6D4528d192dB72E282265D6092F4B872f9Dff69e);
    address L1__CrossDomainMessenger = address(0x12Acf6E3ca96A60fBa0BBFd14D2Fe0EB6ae47820);
    address Lib_AddressManager = address(0x8376ac6C3f73a25Dd994E0b0669ca7ee0C02F089);
    address StateCommitmentChain = address(0xdE7355C971A5B733fe2133753Abd7e5441d441Ec);
    address ChainStorageContainer = address(0x13992B9f327faCA11568BE18a8ad3E9747e87d93);

    // Stable coins
    ITetherToken USDT = ITetherToken(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IFiatTokenV2_1 USDC = IFiatTokenV2_1(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    // Tokens
    IBOBA BOBA = IBOBA(0x42bBFa2e77757C645eeaAd1655E0911a7553Efbc);
    IOMGToken OMG = IOMGToken(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
    IWBTC WBTC = IWBTC(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    IDAI DAI = IDAI(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IERC20 DODO = IERC20(0x43Dfc4159D86F3A37A5A4B3D4580b888ad7d4DDd);

    // Liquidity Pools
    IL1StandardBridge proxy__L1__StandardBridge = IL1StandardBridge(payable(0xdc1664458d2f0B6090bEa60A8793A4E66c2F1c00));
    address L1__StandardBridge = address(0xAf41c681143Cb91f218959375f4452A604504833);

    function setUp() public virtual {
        // Assign label to Flashloan provider

        // Assign label to governance
        cheats.label(address(L2__BatchMessageRelayer), "L2__BatchMessageRelayer");
        cheats.label(address(ProxyAdmin), "ProxyAdmin");

        // Assign label to protocol
        cheats.label(address(L1__MultiMessageRelayer), "L1__MultiMessageRelayer");
        cheats.label(address(Proxy_OVM_L1CrossDomainMessenger), "Proxy_OVM_L1CrossDomainMessenger");
        cheats.label(address(L1__CrossDomainMessenger), "L1__CrossDomainMessenger");
        cheats.label(address(Lib_AddressManager), "Lib_AddressManager");
        cheats.label(address(StateCommitmentChain), "StateCommitmentChain");
        cheats.label(address(ChainStorageContainer), "ChainStorageContainer");

        // Assign label to tokens
        cheats.label(address(USDC), "USDC");
        cheats.label(address(USDT), "USDT");
        cheats.label(address(BOBA), "BOBA");
        cheats.label(address(OMG), "OMG");
        cheats.label(address(WBTC), "WBTC");
        cheats.label(address(DAI), "DAI");
        cheats.label(address(DODO), "DODO");

        // Assign label to LPs
        cheats.label(address(proxy__L1__StandardBridge), "proxy__L1__StandardBridge");
        cheats.label(address(L1__StandardBridge), "L1__StandardBridge");
    }
}