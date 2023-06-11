// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";
import "interface/dodo_flashloan.sol";
import "interface/ethereum_blockchain.sol";
import "interface/uniswap.sol";

contract ContractTest is DSCommon {
    // Flashloan provider
    // DPPOracle Contract
    DVM dodo = DVM(0x9ad32e3054268B849b84a8dBcC7c8f7c52E4e69A);

    // Router
    Uni_Router_V2 Router = Uni_Router_V2(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    // LP Tokens
    IERC20 USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);

    // LP Pairs
    Uni_Pair_V2 Pair = Uni_Pair_V2(0x40eD17221b3B2D8455F4F1a05CAc6b77c5f707e3);

    // Target flashloan amount
    uint256 req_flashloan_amount = 100_000 * 1e18;
    uint256 ret_flashloan_amount = req_flashloan_amount;

    function setUp() public {
        cheats.createSelectFork("bsc", 23695904);
        cheats.label(address(USDT), "USDT");
        cheats.label(address(Pair), "USDT Pair");
        cheats.label(address(Router), "Router");
    }

    function testExploit() public{
        emit log_named_decimal_uint(
            "[Start] Attacker USDT balance before exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        // Approval
        USDT.approve(address(Router), type(uint).max);

        // console.log("Request flashloan:", req_flashloan_amount);
        dodo.flashLoan(0, req_flashloan_amount, address(this), new bytes(1));

        emit log_named_decimal_uint(
            "[End] Attacker USDT balance after exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );
    }

    function DPPFlashLoanCall(address sender, uint256 baseAmount, uint256 quoteAmount, bytes calldata data) external{
        emit log_named_decimal_uint(
            "[Loaned] Attacker USDT balance during exploit",
            USDT.balanceOf(address(this)),
            USDT.decimals()
        );

        // console.log("Repay flashloan:", ret_flashloan_amount);
        USDT.transfer(address(dodo), ret_flashloan_amount);
    }
}