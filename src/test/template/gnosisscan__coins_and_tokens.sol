// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";
import "interface/gnosisscan_blockchain.sol";

contract GnosisScanCommon is DSCommon {
    // Swap or Flashloan provider
    ICurve curve = ICurve(0x7f90122BF0700F9E7e1F688fe926940E8839F353);
    // https://docs.sushi.com/docs/Products/Classic%20AMM/Deployment%20Addresses
    IUniswapV2Router02 Router =
        IUniswapV2Router02(payable(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506));

    // Refer to https://gnosisscan.io/tokens

    // Stable coins
    ITokenProxy USDT =
        ITokenProxy(payable(0x4ECaBa5870353805a9F068101A40E0f32ed605C6));
    ITokenProxy USDC =
        ITokenProxy(payable(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83));

    // Tokens
    IWXDAI WXDAI = IWXDAI(payable(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d));
    IPermittableToken xDAI =
        IPermittableToken(payable(0xf8D1677c8a0c961938bf2f9aDc3F3CFDA759A9d9));
    IUnverified_Proxy HOPR =
        IUnverified_Proxy(payable(0xD057604A14982FE8D88c5fC25Aac3267eA142a08));

    function setUp2() public virtual {
        super.setUp1();

        // Assign label to Swap or Flashloan provider
        cheats.label(address(curve), "curve");
        cheats.label(address(Router), "Router");

        // Assign label to Stable coins
        cheats.label(address(USDT), "USDT");
        cheats.label(address(USDC), "USDC");

        // Assign label to tokens
        cheats.label(address(WXDAI), "WXDAI");
        cheats.label(address(xDAI), "xDAI");
        cheats.label(address(HOPR), "HOPR");
    }

    // https://dashboard.tenderly.co/tx/xdai/0x75546e92efb482957d1f07180ad950dcd038be6a964696bc1a7929f267e71f95?trace=0
    // Note: Not yet working
    function USDC_to_symbol(IERC20 symbol, uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(USDC);
        path[1] = address(symbol);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = USDC.balanceOf(address(this));
        }

        Router.swapExactTokensForTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    // Note: Not yet working
    function symbol_to_USDC(IERC20 symbol, uint256 amount) public {
        address[] memory path = new address[](2);
        path[0] = address(symbol);
        path[1] = address(USDC);

        uint256 swapAmount = amount;
        if (swapAmount == type(uint256).max) {
            swapAmount = symbol.balanceOf(address(this));
        }

        Router.swapExactTokensForTokens(
            swapAmount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }
}
