// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/StdStorage.sol";
import "openzeppelin-contracts/utils/math/SafeMath.sol";

import "interface/cheat_codes.sol";
import "interface/cronos_blockchain.sol";
import "interface/cronos_flashloan.sol";
import "helper/helper_library.sol";

contract CronosCommon is DSTest {
    // Foundry
    CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    // Flashloan provider
    ISwapFlashLoan xUSD_3Pool = ISwapFlashLoan(0x43F3671b099b78D26387CD75283b826FD9585B60);

    // VVS Protocol
    IVVSZap Zap = IVVSZap(payable(0x8D13982c702FE7c6537529986dF67daBeAFc4C19));
    IVVSVault Vault = IVVSVault(0xA6fF77fC8E839679D4F7408E8988B564dE1A2dcD);
    IVVSBoost Boost_Proxy = IVVSBoost(0x990E9683E6Ba5079CdB235838856029A50DAd84c);
    IWorkbench Workbench = IWorkbench(0x6a2d178585806De5A2e5E7F9acFCE44680637284);
    ICraftsman Craftsman = ICraftsman(0xDccd6455AE04b03d785F12196B492b18129564bc);
    IRewarder Rewarder = IRewarder(0x862C41c4a9b3a21989585Fd92b66C7023FCf4C7D);
    IVVSFactory Factory = IVVSFactory(0x3B44B2a187a7b3824131F8db5a74194D0a42Fc15);
    IVVSRouter Router = IVVSRouter(payable(0x145863Eb42Cf62847A6Ca784e6416C1682b1b2Ae));

    // For reference only, subject to change in future
    // IVVSBoost VVSBoostV2 = IVVSBoost(0xC70B9317197c75b1E946540dDa9c36E7bcD06dBa);

    // Tokens
    // Refer to https://cronoscan.com/tokens
    ICronosCRC20 USDT = ICronosCRC20(0x66e428c3f67a68878562e79A0234c1F83c208770);
    ICronosCRC20 BNB = ICronosCRC20(0xfA9343C3897324496A05fC75abeD6bAC29f8A40f);
    ICronosCRC20 USDC = ICronosCRC20(0xc21223249CA28397B4B6541dfFaEcC539BfF0c59);
    ICronosCRC20 DAI = ICronosCRC20(0xF2001B145b43032AAF5Ee2884e456CCd805F677D);
    ICronosCRC20 WETH = ICronosCRC20(0xe44Fd7fCb2b1581822D0c862B68222998a0c299a);
    ICronosCRC20 WBTC = ICronosCRC20(0x062E66477Faf219F25D27dCED647BF57C3107d52);

    // Do NOT remove: Needed for exclusion
    ICronosCRC20 APE = ICronosCRC20(0x9C62F89a8C9907582f21205Ce90443730361EA05);
    ICronosCRC20 DARK = ICronosCRC20(0x83b2AC8642aE46FC2823Bc959fFEB3c1742c48B5);
    ICronosCRC20 SKY = ICronosCRC20(0x9D3BBb0e988D9Fb2d55d07Fe471Be2266AD9c81c);
    ICronosCRC20 LCRO = ICronosCRC20(0x9Fae23A2700FEeCd5b93e43fDBc03c76AA7C08A6);

    IVVS VVS = IVVS(0x2D03bECE6747ADC00E1a131BBA1469C15fD11e03);
    IERC20 WCRO = IERC20(0x5C7F8A570d578ED84E63fdFA7b1eE72dEae1AE23);
    ITONIC TONIC = ITONIC(0xDD73dEa10ABC2Bff99c60882EC5b2B81Bb1Dc5B2);

    // Liquidity Pools
    // Refer to https://docs.vvs.finance/fundamentals/smart-contracts-and-security
    IVVSPair WCRO_WETH_Pair = 
        IVVSPair(0xA111C17f8B8303280d3EB01BBcd61000AA7F39F9);
    IVVSPair WBTC_WCRO_Pair = 
        IVVSPair(0x8F09fFf247B8fDB80461E5Cf5E82dD1aE2EBd6d7);
    IVVSPair WCRO_USDC_Pair = 
        IVVSPair(0xe61Db569E231B3f5530168Aa2C9D50246525b6d6);
    IVVSPair VVS_WCRO_Pair =
        IVVSPair(0xbf62c67eA509E86F07c8c69d0286C0636C50270b);
    IVVSPair VVS_USDC_Pair =
        IVVSPair(0x814920D1b8007207db6cB5a2dD92bF0b082BDBa1);
    IVVSPair USDT_USDC_Pair =
        IVVSPair(0x39cC0E14795A8e6e9D02A21091b81FE0d61D82f9);
    IVVSPair VVS_USDT_Pair =
        IVVSPair(0x280aCAD550B2d3Ba63C8cbff51b503Ea41a1c61B);
    IVVSPair WCRO_USDT_Pair =
        IVVSPair(0x3d2180DB9E1B909f35C398BC39EF36108C0FC8c3);
    IVVSPair WCRO_DAI_Pair =
        IVVSPair(0x3Eb9FF92e19b73235A393000C176c8bb150F1B20);
    IVVSPair WCRO_TONIC_Pair =
        IVVSPair(0x4B377121d968Bf7a62D51B96523d59506e7c2BF0);
    IVVSPair USDC_TONIC_Pair =
        IVVSPair(0x2f12D47Fe49B907d7a5Df8159C1CE665187F15c4);
    IVVSPair VVS_TONIC_Pair =
        IVVSPair(0xA922530960A1F94828A7E132EC1BA95717ED1eab);

    // Alternatively, generate either using the following or run getPair from the Read Contract of Factory contract above:
    // Pair = Factory.getPair(address(TONIC), address(VVS));
    // console.log("TONIC/VVS Pair: %s", Pair);

    // https://mirror.xyz/brocke.eth/PnX7oAcU4LJCxcoICiaDhq_MUUu9euaM8Y5r465Rd2U
    using stdStorage for StdStorage;
    StdStorage stdstore;

    function writeTokenBalance(
        address owner,
        address token,
        uint256 amount
    ) internal {
        stdstore
            .target(token)
            .sig(IERC20(token).balanceOf.selector)
            .with_key(owner)
            .checked_write(amount);
    }

    function setUp() public virtual {
        cheats.label(address(xUSD_3Pool), "xUSD_3Pool");
        cheats.label(address(Zap), "Zap");
        cheats.label(address(Vault), "Vault");
        cheats.label(address(Boost_Proxy), "Boost_Proxy");
        cheats.label(address(Rewarder), "Rewarder");
        cheats.label(address(Factory), "Factory");
        cheats.label(address(Router), "Router");
        cheats.label(address(Craftsman), "Craftsman");
        cheats.label(address(Workbench), "Workbench");

        // For reference only, subject to change in future
        // cheats.label(address(VVSBoostV2), "VVSBoostV2");

        // Assign label to address
        cheats.label(address(USDC), "USDC");
        cheats.label(address(USDT), "USDT");
        cheats.label(address(DAI), "DAI");
        cheats.label(address(VVS), "VVS");
        cheats.label(address(WETH), "WETH");
        cheats.label(address(WCRO), "WCRO");
        cheats.label(address(TONIC), "TONIC");

        // Do NOT remove: Needed for exclusion
        cheats.label(address(APE), "APE");
        cheats.label(address(DARK), "DARK");
        cheats.label(address(SKY), "SKY");
        cheats.label(address(LCRO), "LCRO");

        cheats.label(address(WCRO_WETH_Pair), "WCRO/WETH Pair");
        cheats.label(address(WBTC_WCRO_Pair), "WBTC/WCRO Pair");
        cheats.label(address(WCRO_USDC_Pair), "WCRO/USDC Pair");
        cheats.label(address(VVS_WCRO_Pair), "VVS/WCRO Pair");
        cheats.label(address(VVS_USDC_Pair), "VVS/USDC Pair");
        cheats.label(address(USDT_USDC_Pair), "USDT/USDC Pair");
        cheats.label(address(VVS_USDT_Pair), "VVS/USDT Pair");
        cheats.label(address(WCRO_USDT_Pair), "WCRO/USDT Pair");
        cheats.label(address(WCRO_DAI_Pair), "WCRO/DAI Pair");
        cheats.label(address(USDC_TONIC_Pair), "USDC/TONIC Pair");
        cheats.label(address(WCRO_TONIC_Pair), "WCRO/TONIC Pair");
        cheats.label(address(VVS_TONIC_Pair), "VVS/TONIC Pair");
    }

    function USDC_to_symbol(IERC20 symbol, uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDC);
        path[1] = address(symbol);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDC.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function symbol_to_USDC(IERC20 symbol, uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(symbol);
        path[1] = address(USDC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = symbol.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function DAI_to_WCRO(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(DAI);
        path[1] = address(WCRO);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = DAI.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function TONIC_to_USDC(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(TONIC);
        path[1] = address(USDC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = TONIC.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function USDC_to_VVS(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDC);
        path[1] = address(VVS);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDC.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function USDC_to_WBTC(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDC);
        path[1] = address(WBTC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDC.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function USDC_to_WCRO(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDC);
        path[1] = address(WCRO);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDC.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function USDC_to_USDT(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDC);
        path[1] = address(USDT);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDC.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function USDC_to_TONIC(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDC);
        path[1] = address(TONIC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDC.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function USDT_to_VVS(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDT);
        path[1] = address(VVS);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDT.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function USDT_to_WCRO(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDT);
        path[1] = address(WCRO);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDT.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function USDT_to_TONIC(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDT);
        path[1] = address(TONIC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDT.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function USDT_to_USDC(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDT);
        path[1] = address(USDC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDT.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function VVS_to_WCRO(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(VVS);
        path[1] = address(WCRO);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = VVS.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function VVS_to_USDC(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(VVS);
        path[1] = address(USDC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = VVS.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function VVS_to_USDT(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(VVS);
        path[1] = address(USDT);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = VVS.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function WCRO_to_VVS(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(WCRO);
        path[1] = address(VVS);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = WCRO.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function WBTC_to_USDC(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(WBTC);
        path[1] = address(USDC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = WBTC.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function WCRO_to_USDC(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(WCRO);
        path[1] = address(USDC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = WCRO.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function WCRO_to_USDT(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(WCRO);
        path[1] = address(USDT);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = WCRO.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function WCRO_to_DAI(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(WCRO);
        path[1] = address(DAI);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = WCRO.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function WCRO_to_WETH(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(WCRO);
        path[1] = address(WETH);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = WCRO.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function WETH_to_WCRO(uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(WETH);
        path[1] = address(WCRO);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = WETH.balanceOf(address(this));
        }

        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }
}
