// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../cronos/VVS_Finance__common.sol";

contract ContractTest is CronosCommon {
    using SafeMath for uint256;

    // Configure target flashloan here
    address fl_token = address(USDC);
    uint256 constant req_flashloan_amount = 104_000 * 1e6;
    uint256 constant payback_fee_amount = (req_flashloan_amount * 1008) / 1000; // 0.8% fee

    function setUp() public {
        super.setUp2();

        cheats.createSelectFork("cronos", 8305182);

        // Pre-load tokens
        writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    function test_Flashloan_Application() public {
        // Approval
        IERC20(fl_token).approve(address(xUSD_3Pool), type(uint256).max);

        emit log_named_decimal_uint(
            "[Start] Attacker IERC20(fl_token) balance before exploit",
            IERC20(fl_token).balanceOf(address(this)),
            IERC20(fl_token).decimals()
        );

        xUSD_3Pool.flashLoan(
            address(this),
            IERC20(fl_token),
            req_flashloan_amount,
            bytes("decrease_balance_2")
        );

        emit log_named_decimal_uint(
            "[End] Attacker IERC20(fl_token) balance after exploit",
            IERC20(fl_token).balanceOf(address(this)),
            IERC20(fl_token).decimals()
        );
    }

    function testFail_Token_Swap_to_USDC() public {
        // Pre-load tokens
        IERC20 token = IERC20(APE);
        uint swap_token_amount = 1;

        writeTokenBalance(address(this), address(token), swap_token_amount);

        // Approval
        token.approve(address(Router), type(uint256).max);

        // Convert token to USDC
        symbol_to_USDC(token, type(uint256).max);
    }

    // Typical executeOperation function should do the 3 following actions
    // 1. Check if the flashLoan was successful
    // 2. Do actions with the borrowed tokens
    // 3. Repay the debt to the `pool`
    function executeOperation(
        address pool,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata params
    ) external {
        // 1. Check if the flashLoan was valid
        require(
            IERC20(token).balanceOf(address(this)) >= amount,
            "flashloan is broken?"
        );

        emit log_named_decimal_uint(
            "[Loaned] Attacker IERC20(token) balance during exploit",
            IERC20(token).balanceOf(address(this)),
            IERC20(token).decimals()
        );

        // 2. Do actions with the borrowed token
        bytes32 paramsHash = keccak256(params);

        if (paramsHash == keccak256(bytes("nothing"))) {
            console.log("nothing");
            return;
        } else if (paramsHash == keccak256(bytes("increase_balance_1"))) {
            // SOME CODE TO INTERACT WITH OTHER CONTRACTS
            console.log("increase_balance_1");
        } else if (paramsHash == keccak256(bytes("decrease_balance_2"))) {
            // SOME CODE TO INTERACT WITH OTHER CONTRACTS
            console.log("decrease_balance_2");
        }

        // 3. Payback debt
        uint256 ret_flashloan_amount = amount.add(fee);
        // console.log("Flashloan fee:", fee);
        // console.log("Repay flashloan:", ret_flashloan_amount);
        require(
            IERC20(token).balanceOf(address(this)) >= ret_flashloan_amount,
            "Insufficient balance to repay flash loan"
        );
        IERC20(token).transfer(pool, ret_flashloan_amount);
    }
}
