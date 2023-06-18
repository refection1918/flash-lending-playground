// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./VVS_Finance__common.sol";

contract ContractTest is CronosCommon {
    using SafeMath for uint256;

    function setUp() public override {
        super.setUp();

        cheats.createSelectFork("cronos", 8185555);
    }

    // ----------------------------------------------------------------------------
    // USDC Token
    // ----------------------------------------------------------------------------
    function testFail__USDC__authority_change() public {
        console.log("Existing USDC.authority:", USDC.authority());
        USDC.setAuthority(address(this));
        console.log("New USDC.authority:", USDC.authority());
    }

    function testFail__USDC__owner_change() public {
        console.log("Existing USDC.owner:", USDC.owner());
        USDC.setOwner(address(this));
        console.log("New USDC.owner:", USDC.owner());
    }

    function testFail__USDC__unsafe_burn__send_to_ibc() public {
        // Fund the account with flashloan and/or cash
        uint256 exploited_amount = USDC.balanceOf(address(USDC));
        writeTokenBalance(address(this), address(USDC), exploited_amount);

        emit log_named_decimal_uint(
            "[Start] USDC total supply before exploit",
            USDC.totalSupply(),
            USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Attacker USDC balance before exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        // Burn to "Ghost"
        USDC.send_to_ibc("Ghost", USDC.balanceOf(address(this)));
        console.log("[Issue] Attacker burned all USDC balance during exploit");

        emit log_named_decimal_uint(
            "[End] Attacker USDC balance after exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[End] USDC total supply after exploit",
            USDC.totalSupply(),
            USDC.decimals()
        );
    }

    function testFail__USDC__unsafe_burn__send_to_ethereum() public {
        // Fund the account with flashloan and/or cash
        uint256 exploited_amount = USDC.balanceOf(address(USDC));
        writeTokenBalance(address(this), address(USDC), exploited_amount);

        emit log_named_decimal_uint(
            "[Start] USDC total supply before exploit",
            USDC.totalSupply(),
            USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Attacker USDC balance before exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        // Burn to address(0)
        USDC.send_to_ethereum(address(0), USDC.balanceOf(address(this)), 0);
        console.log("[Issue] Attacker burned all USDC balance during exploit");

        emit log_named_decimal_uint(
            "[End] Attacker USDC balance after exploit",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );

        emit log_named_decimal_uint(
            "[End] USDC total supply after exploit",
            USDC.totalSupply(),
            USDC.decimals()
        );
    }

    // ----------------------------------------------------------------------------
    // USDT Token
    // ----------------------------------------------------------------------------
    function testFail__USDT__unsafe_burn__send_to_ibc() public {
        // Fund the account with flashloan and/or cash
        uint256 exploited_amount = USDT.balanceOf(address(USDT));
        writeTokenBalance(address(this), address(USDT), exploited_amount);

        emit log_named_decimal_uint(
            "[Start] USDT total supply before exploit",
            USDT.totalSupply(),
            USDT.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Attacker USDT balance before exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        // Burn to "Ghost"
        USDT.send_to_ibc("Ghost", USDT.balanceOf(address(this)));
        console.log("[Issue] Attacker burned all USDT balance during exploit");

        emit log_named_decimal_uint(
            "[End] Attacker USDT balance after exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        emit log_named_decimal_uint(
            "[End] USDT total supply after exploit",
            USDT.totalSupply(),
            USDT.decimals()
        );
    }

    function testFail__USDT__unsafe_burn__send_to_ethereum() public {
        // Fund the account with flashloan and/or cash
        uint256 exploited_amount = USDT.balanceOf(address(USDT));
        writeTokenBalance(address(this), address(USDT), exploited_amount);

        emit log_named_decimal_uint(
            "[Start] USDT total supply before exploit",
            USDT.totalSupply(),
            USDT.decimals()
        );

        emit log_named_decimal_uint(
            "[Start] Attacker USDT balance before exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        // Burn to address(0)
        USDT.send_to_ethereum(address(0), USDT.balanceOf(address(this)), 0);
        console.log("[Issue] Attacker burned all USDT balance during exploit");

        emit log_named_decimal_uint(
            "[End] Attacker USDT balance after exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        emit log_named_decimal_uint(
            "[End] USDT total supply after exploit",
            USDT.totalSupply(),
            USDT.decimals()
        );
    }

    // ----------------------------------------------------------------------------
    // Workbench
    // ----------------------------------------------------------------------------
    function testFail__Workbench__owner_change() public {
        console.log("Existing Workbench.owner:", Workbench.owner());
        Workbench.transferOwnership(address(this));
        console.log("New Workbench.owner:", Workbench.owner());
    }

    function testFail__Workbench__renounce_ownership() public {
        console.log("Existing Workbench.owner:", Workbench.owner());
        Workbench.renounceOwnership();
        console.log("New Workbench.owner:", Workbench.owner());
    }

    function test__Workbench__increase_allowance() public {
        console.log("Existing Router's Allowance:", Workbench.allowance(address(this), address(Router)));
        Workbench.increaseAllowance(address(Router), type(uint256).max);
        console.log("New Router's Allowance:", Workbench.allowance(address(this), address(Router)));
    }

    function testFail__Workbench__mint() public {
        emit log_named_decimal_uint(
            "[Start] Attacker VVS balance before exploit",
            VVS.balanceOf(address(this)),
            VVS.decimals()
        );

        // Mint VVS token
        uint mint_amount = 1_000 * 1e9;
        Workbench.mint(address(this), mint_amount);

        emit log_named_decimal_uint(
            "[End] Attacker VVS balance after exploit",
            VVS.balanceOf(address(this)),
            VVS.decimals()
        );
    }

    function testFail__Workbench__burn() public {
        Workbench.approve(address(Router), type(uint256).max);
        VVS.approve(address(Router), type(uint256).max);
        WCRO.approve(address(Router), type(uint256).max);

        VVS.approve(address(Workbench), type(uint256).max);
        WCRO.approve(address(Workbench), type(uint256).max);

        Workbench.approve(address(VVS), type(uint256).max);
        Workbench.approve(address(WCRO), type(uint256).max);

        // Fund the account with flashloan and/or cash
        uint burn_amount = 1_000 * 1e9;
        writeTokenBalance(address(this), address(VVS), burn_amount);

        emit log_named_decimal_uint(
            "[Start] Attacker VVS balance before exploit",
            VVS.balanceOf(address(this)),
            VVS.decimals()
        );

        // Burn VVS token
        Workbench.burn(address(this), burn_amount);

        emit log_named_decimal_uint(
            "[End] Attacker VVS balance after exploit",
            VVS.balanceOf(address(this)),
            VVS.decimals()
        );
    }

    function testFail__Workbench__safeVVSTransfer() public {
        emit log_named_decimal_uint(
            "[Start] Attacker VVS balance before exploit",
            VVS.balanceOf(address(this)),
            VVS.decimals()
        );

        // Safe Transfer VVS token
        uint transfer_amount = 1_000 * 1e9;
        Workbench.safeVVSTransfer(address(this), transfer_amount);

        emit log_named_decimal_uint(
            "[End] Attacker VVS balance after exploit",
            VVS.balanceOf(address(this)),
            VVS.decimals()
        );
    }

    // ----------------------------------------------------------------------------
    // Craftsman
    // ----------------------------------------------------------------------------
    function testFail__Craftsman__owner_change() public {
        console.log("Existing Craftsman.owner:", Craftsman.owner());
        Craftsman.transferOwnership(address(this));
        console.log("New Craftsman.owner:", Craftsman.owner());
    }

    function testFail__Craftsman__renounce_ownership() public {
        console.log("Existing Craftsman.owner:", Craftsman.owner());
        Craftsman.renounceOwnership();
        console.log("New Craftsman.owner:", Craftsman.owner());
    }

    function test__Craftsman__list_all_pairs_with_pid() public {
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accVVSPerShare;
        IVVSPair pair;
        address token0;
        address token1;
        IERC20 symbol0;
        IERC20 symbol1;

        uint last_pid = Craftsman.poolLength();

        console.log("Address, PID, Pair");
        for (uint pid = 0; pid < last_pid; pid++) {
            (lpToken, allocPoint, lastRewardBlock, accVVSPerShare) = Craftsman.poolInfo(pid);

            // Determine if the address is a smart contract
            if (ContractHelper.isContract(lpToken)) {
                if (pid == 0) {
                    console.log("%s, %d, VVS Token", lpToken, pid);
                } else {
                    // console.log("pid: %d, accVVSPerShare: %s", pid, accVVSPerShare);
                    if (ContractHelper.hasSuffixOf13Zeros(accVVSPerShare)) {
                        // Skip VVS Boost Deposit Token (BOOST) and VVS Farm Boost Deposit Token (BOOST)
                        string memory boost_name;
                        if (pid == 23) {
                            boost_name = "VVS Boost Deposit Token (BOOST)";
                        } else {
                            boost_name = "VVS Farm Boost Deposit Token (BOOST)";
                        }
                        console.log("%s, %d, %s", lpToken, pid, boost_name);
                    } else {
                        string memory pair_name;

                        pair = IVVSPair(lpToken);
                        token0 = pair.token0();
                        token1 = pair.token1();

                        symbol0 = IERC20(token0);
                        symbol1 = IERC20(token1);

                        pair_name = StringHelper.concatenateStringsWithComma(symbol0.symbol(), symbol1.symbol());
                        console.log("%s, %d, %s", lpToken, pid, pair_name);

                        // // pair_balance = pair.MINIMUM_LIQUIDITY();
                        // uint256 pair_balance = pair.balanceOf(address(pair));
                        // uint256 pair_balance = pair.balanceOf(msg.sender);
                        // console.log("%s, %d", lpToken, pair_balance);
                    }
                }
            }
        }
    }
}