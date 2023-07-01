// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";
import "interface/dodo_bscscan_flashloan.sol";
import "interface/pancake_bscscan_flashloan.sol";

contract Dodo_Swap_Test is DSCommon {
    using SafeMath for uint256;

    // Swap or Flashloan provider
    IDPPFactory DPPFactory =
        IDPPFactory(0xd9CAc3D964327e47399aebd8e1e6dCC4c251DaAE);
    IDVMFactory DVMFactory =
        IDVMFactory(0x790B4A80Fb1094589A3c0eFC8740aA9b0C1733fB);

    // Governance
    // Protocol with interface
    // Protocol with address only
    // Stable coins
    // Tokens
    // Liquidity Pools

    function setUp2() public virtual {
        super.setUp1();

        // Assign label to Swap or Flashloan provider
        cheats.label(address(DPPFactory), "DPPFactory");
        cheats.label(address(DVMFactory), "DVMFactory");

        // Assign label to Governance
        // Assign label to Protocol with interface
        // Assign label to Protocol with address only
        // Assign label to Stable coins
        // Assign label to Tokens
        // Assign label to Liquidity Pools
    }

    function setUp() public {
        setUp2();

        // Default fork
        cheats.createSelectFork("bsc", 29004971);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    function test__query_specific_pair() public {
        // TODO: Enter the known token address below
        address token0 = address(0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3);
        address token1 = address(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);

        IERC20 symbol0 = IERC20(token0);
        IERC20 symbol1 = IERC20(token1);

        string memory pair_name = StringHelper.concatenateStringsWithComma(
            symbol0.symbol(),
            symbol1.symbol()
        );

        address[] memory pair_contracts = DPPFactory.getDODOPool(
            token0,
            token1
        );

        if (pair_contracts.length > 0) {
            console.log("Pair Name, Pair Contract");
            for (uint i = 0; i < pair_contracts.length; i++) {
                address pair_contract = pair_contracts[i];
                console.log("%d, %s, %s", i, pair_name, pair_contract);

                // Query reserves
                (
                    uint112 _reserve0,
                    uint112 _reserve1,
                    uint32 _blockTimestampLast
                ) = Uni_Pair_V2(pair_contract).getReserves();

                console.log("Pair Reserves:");
                emit log_named_decimal_uint(
                    symbol0.symbol(),
                    _reserve0,
                    symbol0.decimals()
                );
                emit log_named_decimal_uint(
                    symbol1.symbol(),
                    _reserve1,
                    symbol1.decimals()
                );
            }
        } else {
            console.log("%s pair not found", pair_name);
        }
    }
}
