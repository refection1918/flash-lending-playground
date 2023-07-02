// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./connext__bscscan__common.sol";

contract connext_bscscan_Swap_Test is ConnextBscscanCommon {
    using SafeMath for uint256;

    function setUp() public {
        super.setUp2();

        cheats.createSelectFork("bsc", 29004971);
    }

    // ----------------------------------------------------------------------------
    // Swap Info based on Canonical
    // ----------------------------------------------------------------------------
    function test__query__swap_info() public {
        address candidate = address(B_USDC);
        // address candidate = address(nextUSDC);
        // address candidate = address(B_USDT);
        // address candidate = address(nextUSDC);

        TokenId memory canonical = ConnextDiamond_Proxy.getTokenId(candidate);

        emit log_named_address("candidate", candidate);
        emit log_named_bytes32("canonical.id", canonical.id);
        emit log_named_uint("canonical.domain", canonical.domain);

        bytes32 key = calculateCanonicalHash(canonical.id, canonical.domain);
        emit log_named_bytes32("key", key);

        emit log_named_address(
            "getSwapLPToken(key)",
            ConnextDiamond_Proxy.getSwapLPToken(key)
        );

        SwapUtils.Swap memory swap_storage = ConnextDiamond_Proxy
            .getSwapStorage(key);
        emit log_named_bytes32("swap_storage.key", swap_storage.key);

        uint8 swapTokenIndex = ConnextDiamond_Proxy.getSwapTokenIndex(
            key,
            candidate
        );
        emit log_named_uint("swapTokenIndex", swapTokenIndex);

        // uint8 max_domains = 6;
        // uint32[] memory domains = new uint32[](max_domains);
        // domains[0] = Ethereum_Mainnet_Domain_ID;
        // domains[1] = Optimism_Domain_ID;
        // domains[2] = Polygon_Domain_ID;
        // domains[3] = Arbitrum_Domain_ID;
        // domains[4] = Gnosis_Domain_ID;
        // domains[5] = BNB_Domain_ID;

        // for (uint i = 0; i < max_domains; i++) {
        //     canonical.domain = domains[i];

        //     bytes32 my_key = calculateCanonicalHash(
        //         canonical.id,
        //         canonical.domain
        //     );
        //     emit log_named_bytes32("my_key", my_key);

        //     bytes32 key = my_key;
        //     // emit log_named_bytes32("   key", key);
        //     // TODO: Production
        //     require(my_key == key, "Incompatible keys");

        //     // TODO: Debug Use
        //     // require(my_key != key, "Incompatible keys");

        //     // bytes32 key = hex"9e79219debefdf827d33c85c1bc250b0ba1f2821d37ccae57e96a42c70a442ec";

        //     // emit log_named_address(
        //     //     "getSwapLPToken(key)",
        //     //     ConnextDiamond_Proxy.getSwapLPToken(key)
        //     // );

        //     // SwapUtils.Swap memory swap_storage = ConnextDiamond_Proxy
        //     //     .getSwapStorage(key);
        //     // emit log_named_bytes32("swap_storage.key", swap_storage.key);

        //     // uint8 swapTokenIndex = ConnextDiamond_Proxy.getSwapTokenIndex(
        //     //     key,
        //     //     candidate
        //     // );
        //     // emit log_named_uint("swapTokenIndex", swapTokenIndex);
        // }
    }

    // ----------------------------------------------------------------------------
    // Swap
    // ----------------------------------------------------------------------------
    // Txn: https://explorer.phalcon.xyz/tx/bsc/0x4134592c50d7d23c63d61585637a33956461b8cf4b42e9679db7f4cf295fa1cf
    function test__swap_B_USDC_to_nextUSDC() public {
        // Customize the block
        // cheats.createSelectFork("bsc", 29094370);

        // Attacker is current contract
        address attacker_contract_address = address(this);

        // // Attacker is real account
        // attacker_contract_address = address(
        //     0x0078475E4a37370413db51315488cF54Cc9e883f
        // );

        uint account_deposit_amount = 1_000 * 1e18;
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
                    address(B_USDC),
                    account_deposit_amount
                );
            }
        }

        emit log_named_decimal_uint(
            "[Start] Attacker B_USDC balance before exploit",
            B_USDC.balanceOf(attacker_contract_address),
            B_USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Attacker nextUSDC balance before exploit",
            nextUSDC.balanceOf(attacker_contract_address),
            nextUSDC.decimals()
        );

        // Approval
        B_USDC.approve(address(ConnextDiamond_Proxy), type(uint256).max);

        // Replay the transaction
        address from_candidate = address(B_USDC);
        address to_candidate = address(nextUSDC);
        TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
            from_candidate
        );

        bytes32 key = calculateCanonicalHash(
            from_canonical.id,
            from_canonical.domain
        );
        uint8 tokenIndexFrom = ConnextDiamond_Proxy.getSwapTokenIndex(
            key,
            from_candidate
        );
        uint8 tokenIndexTo = ConnextDiamond_Proxy.getSwapTokenIndex(
            key,
            to_candidate
        );
        uint256 dx = account_deposit_amount;
        uint256 minDy = 1;
        uint256 deadline = block.timestamp;

        // --------------------------------------------------------------------------------------------------
        // BUG: deadline is always greater than block.timestamp due to precision issue
        // --------------------------------------------------------------------------------------------------
        // uint256 deadline = 1686749775526;
        // deadline: 1686749775526
        // block.timestamp: 1686477516
        // emit log_named_uint("deadline", deadline);
        // emit log_named_uint("block.timestamp", block.timestamp);

        ConnextDiamond_Proxy.swap(
            key,
            tokenIndexFrom,
            tokenIndexTo,
            dx,
            minDy,
            deadline
        );

        emit log_named_decimal_uint(
            "[End] Attacker B_USDC balance after exploit",
            B_USDC.balanceOf(attacker_contract_address),
            B_USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[End] Attacker nextUSDC balance after exploit",
            nextUSDC.balanceOf(attacker_contract_address),
            nextUSDC.decimals()
        );
    }

    function test__swapExact_B_USDC_to_nextUSDC() public {
        // Attacker is current contract
        address attacker_contract_address = address(this);

        uint account_deposit_amount = 1_000 * 1e18;
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
                    address(B_USDC),
                    account_deposit_amount
                );
            }
        }

        emit log_named_decimal_uint(
            "[Start] Attacker B_USDC balance before exploit",
            B_USDC.balanceOf(attacker_contract_address),
            B_USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Attacker nextUSDC balance before exploit",
            nextUSDC.balanceOf(attacker_contract_address),
            nextUSDC.decimals()
        );

        // Approval
        B_USDC.approve(address(ConnextDiamond_Proxy), type(uint256).max);

        // Perform SwapExact
        // B_USDC_to_symbol(nextUSDC, account_deposit_amount);
        to_nextSymbol(B_USDC, account_deposit_amount);

        emit log_named_decimal_uint(
            "[End] Attacker B_USDC balance after exploit",
            B_USDC.balanceOf(attacker_contract_address),
            B_USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[End] Attacker nextUSDC balance after exploit",
            nextUSDC.balanceOf(attacker_contract_address),
            nextUSDC.decimals()
        );
    }

    // Txn: https://explorer.phalcon.xyz/tx/bsc/0xc4e27718110e3b03fcb0801deea1480d537f580c25b49ac1d4b567dbf65df4df
    function test__swap_nextUSDC_to_B_USDC() public {
        // Customize the block
        // cheats.createSelectFork("bsc", 29125988);

        // Attacker is current contract
        address attacker_contract_address = address(this);

        // // Attacker is real account
        // attacker_contract_address = address(
        //     0xb51ede61D0a99621a5875252331eFfCE18B3B27C
        // );

        uint account_deposit_amount = 1_000_037_372;
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
                    address(nextUSDC),
                    account_deposit_amount
                );
            }
        }

        emit log_named_decimal_uint(
            "[Start] Attacker B_USDC balance before exploit",
            B_USDC.balanceOf(attacker_contract_address),
            B_USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Attacker nextUSDC balance before exploit",
            nextUSDC.balanceOf(attacker_contract_address),
            nextUSDC.decimals()
        );

        // Approval
        nextUSDC.approve(address(ConnextDiamond_Proxy), type(uint256).max);

        // Replay the transaction
        address from_candidate = address(nextUSDC);
        address to_candidate = address(B_USDC);
        TokenId memory from_canonical = ConnextDiamond_Proxy.getTokenId(
            from_candidate
        );

        bytes32 key = calculateCanonicalHash(
            from_canonical.id,
            from_canonical.domain
        );
        uint8 tokenIndexFrom = ConnextDiamond_Proxy.getSwapTokenIndex(
            key,
            from_candidate
        );
        uint8 tokenIndexTo = ConnextDiamond_Proxy.getSwapTokenIndex(
            key,
            to_candidate
        );
        uint256 dx = account_deposit_amount;
        uint256 minDy = 1;
        uint256 deadline = block.timestamp;

        // --------------------------------------------------------------------------------------------------
        // BUG: deadline is always greater than block.timestamp due to precision issue
        // --------------------------------------------------------------------------------------------------
        // uint256 deadline = 1686845000802;
        // deadline: 1686845000802
        // block.timestamp: 1686841431
        // emit log_named_uint("deadline", deadline);
        // emit log_named_uint("block.timestamp", block.timestamp);

        ConnextDiamond_Proxy.swap(
            key,
            tokenIndexFrom,
            tokenIndexTo,
            dx,
            minDy,
            deadline
        );

        emit log_named_decimal_uint(
            "[End] Attacker B_USDC balance after exploit",
            B_USDC.balanceOf(attacker_contract_address),
            B_USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[End] Attacker nextUSDC balance after exploit",
            nextUSDC.balanceOf(attacker_contract_address),
            nextUSDC.decimals()
        );
    }

    // WARNING: Experimental
    function skip_test__swapExact_nextDAI_to_nextUSDC() public {
        // Customize the block
        // cheats.createSelectFork("bsc", 29125988);

        // For some reason once the expectRevert is added, the test failed with:
        // FAIL. Reason: stdStorage find(StdStorage): Packed slot. This would cause dangerous overwriting and currently isn't supported.
        // As a result, disabling the test for time being
        cheats.expectRevert(0x336752bb);

        // Attacker is current contract
        address attacker_contract_address = address(this);

        uint account_deposit_amount = 1_000 * 1e18;
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
                    address(nextDAI),
                    account_deposit_amount
                );
            }
        }

        emit log_named_decimal_uint(
            "[Start] Attacker nextDAI balance before exploit",
            nextDAI.balanceOf(attacker_contract_address),
            nextDAI.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Attacker nextUSDC balance before exploit",
            nextUSDC.balanceOf(attacker_contract_address),
            nextUSDC.decimals()
        );

        // Approval
        nextDAI.approve(address(ConnextDiamond_Proxy), type(uint256).max);

        // Convert nextDAI to nextUSDC
        from_Symbol_to_Symbol(nextDAI, nextUSDC, account_deposit_amount);

        emit log_named_decimal_uint(
            "[End] Attacker nextDAI balance after exploit",
            nextDAI.balanceOf(attacker_contract_address),
            nextDAI.decimals()
        );

        emit log_named_decimal_uint(
            "[End] Attacker nextUSDC balance after exploit",
            nextUSDC.balanceOf(attacker_contract_address),
            nextUSDC.decimals()
        );
    }
}
