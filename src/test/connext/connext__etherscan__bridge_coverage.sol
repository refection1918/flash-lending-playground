// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./connext__etherscan__common.sol";

contract connext_etherscan_Bridge_Test is ConnextEtherscanCommon {
    using SafeMath for uint256;

    function setUp() public {
        super.setUp3();

        cheats.createSelectFork("ethereum", 17599948);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // ----------------------------------------------------------------------------
    // Replay
    // ----------------------------------------------------------------------------
    // https://explorer.phalcon.xyz/tx/eth/0x841464c1c178234f0de6fb3e5653ec0d478ce37af8da1a1ddc8c3dcc8243a1dd
    function test__replay_add_router_liquidity_for() public {
        // // Customize the block
        // cheats.createSelectFork("ethereum", 17030526);

        // Customize designated router
        address designated_router = address(
            0x8cb19CE8EEDF740389D428879a876A3B030B9170
        );

        // Attacker is current contract
        address attacker_contract_address = address(this);

        // // Attacker is real account
        // attacker_contract_address = address(
        //     0xf368735a1c7D95aDAdB12c0323B778Ca75Dc5667
        // );

        uint account_deposit_amount = 2_000 * 1e6;
        if (attacker_contract_address != address(this)) {
            // Impersonate as attacker
            cheats.prank(attacker_contract_address);
            cheats.label(
                address(attacker_contract_address),
                "Impersonated_Account"
            );
        } else {
            if (account_deposit_amount > 0) {
                // Fund the account with flashloan and/or cash
                writeTokenBalance(
                    attacker_contract_address,
                    address(USDC),
                    account_deposit_amount
                );
            }
        }

        emit log_named_decimal_uint(
            "[Start] Attacker USDC balance before exploit",
            USDC.balanceOf(attacker_contract_address),
            USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Connext:Bridge USDC balance before exploit",
            USDC.balanceOf(address(ConnextDiamond_Proxy)),
            USDC.decimals()
        );

        // Approval
        USDC.approve(address(ConnextDiamond_Proxy), type(uint256).max);

        // Replay the transaction
        ConnextDiamond_Proxy.addRouterLiquidityFor(
            account_deposit_amount,
            address(USDC),
            designated_router
        );

        emit log_named_decimal_uint(
            "[End] Attacker USDC balance after exploit",
            USDC.balanceOf(attacker_contract_address),
            USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[End] Connext:Bridge USDC balance after exploit",
            USDC.balanceOf(address(ConnextDiamond_Proxy)),
            USDC.decimals()
        );
    }

    // https://explorer.phalcon.xyz/tx/eth/0xc79602628e1cd5edc1cb5678be81d7505e9ce57b8ed714a1adfb52f0330dbcf4
    function test__replay_approve_router() public {
        // Customize the block
        cheats.createSelectFork("ethereum", 17123306);

        // Expected revert
        cheats.expectRevert(0x916e73bd);

        // Customize designated router
        address designated_router = address(
            0xC4Ae07F276768A3b74AE8c47bc108a2aF0e40eBa
        );

        // Attacker is current contract
        address attacker_contract_address = address(this);

        // Attacker is real account
        attacker_contract_address = address(
            0x29A519e21d6A97cdB82270b69c98bAc6426CDCf9
        );

        uint account_deposit_amount = 0;
        if (attacker_contract_address != address(this)) {
            // Impersonate as attacker
            cheats.prank(attacker_contract_address);
            cheats.label(
                address(attacker_contract_address),
                "Impersonated_Account"
            );
        } else {
            if (account_deposit_amount > 0) {
                // Fund the account with flashloan and/or cash
                writeTokenBalance(
                    attacker_contract_address,
                    address(USDC),
                    account_deposit_amount
                );
            }
        }

        // Replay the transaction
        ConnextDiamond_Proxy.approveRouter(designated_router);
    }

    // https://explorer.phalcon.xyz/tx/eth/0x69c585b3514c98a8b36416c727fd10c47c34db0a83767f9d7eb01b3493ad2719
    function test__replay_init_router() public {
        // Customize the block
        cheats.createSelectFork("ethereum", 17225012);

        // Expected revert
        cheats.expectRevert(0x1dfb5a62);

        // Customize designated router
        address designated_router = address(
            0x9a9D3DCDC6bF0bD9511201c7848404f6196Cc94A
        );

        // Attacker is current contract
        address attacker_contract_address = address(this);

        // Attacker is real account
        attacker_contract_address = address(
            0x9584Eb0356a380b25D7ED2C14c54De58a25f2581
        );

        uint account_deposit_amount = 0;
        if (attacker_contract_address != address(this)) {
            // Impersonate as attacker
            cheats.prank(attacker_contract_address);
            cheats.label(
                address(attacker_contract_address),
                "Impersonated_Account"
            );
        } else {
            if (account_deposit_amount > 0) {
                // Fund the account with flashloan and/or cash
                writeTokenBalance(
                    attacker_contract_address,
                    address(USDC),
                    account_deposit_amount
                );
            }
        }

        // Replay the transaction
        ConnextDiamond_Proxy.initializeRouter(
            designated_router,
            designated_router
        );
    }
}
