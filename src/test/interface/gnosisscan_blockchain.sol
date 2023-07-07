// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "interface/ethereum_blockchain.sol";

// Proxy Impl: https://gnosisscan.io/address/0xf8d1677c8a0c961938bf2f9adc3f3cfda759a9d9#code
interface IPermittableToken is IERC20 {
    event Mint(address indexed to, uint256 amount);
    event MintFinished();
    event OwnershipRenounced(address indexed previousOwner);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Burn(address indexed burner, uint256 value);
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data
    );

    function mintingFinished() external view returns (bool);

    function setBridgeContract(address _bridgeContract) external;

    function PERMIT_TYPEHASH() external view returns (bytes32);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function increaseAllowance(
        address _to,
        uint256 _addedValue
    ) external returns (bool result);

    function transferAndCall(
        address _to,
        uint256 _value,
        bytes memory _data
    ) external returns (bool);

    function mint(address _to, uint256 _amount) external returns (bool);

    function burn(uint256 _value) external;

    function version() external view returns (string memory);

    function decreaseApproval(
        address _spender,
        uint256 _subtractedValue
    ) external returns (bool);

    function claimTokens(address _token, address _to) external;

    function renounceOwnership() external;

    function isBridge(address _address) external view returns (bool);

    function finishMinting() external returns (bool);

    function nonces(address) external view returns (uint256);

    function getTokenInterfacesVersion()
        external
        pure
        returns (uint64 major, uint64 minor, uint64 patch);

    function permit(
        address _holder,
        address _spender,
        uint256 _nonce,
        uint256 _expiry,
        bool _allowed,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external;

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) external returns (bool);

    function push(address _to, uint256 _amount) external;

    function move(address _from, address _to, uint256 _amount) external;

    function PERMIT_TYPEHASH_LEGACY() external view returns (bytes32);

    function bridgeContract() external view returns (address);

    function permit(
        address _holder,
        address _spender,
        uint256 _value,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external;

    function increaseApproval(
        address _spender,
        uint256 _addedValue
    ) external returns (bool);

    function pull(address _from, uint256 _amount) external;

    function transferOwnership(address _newOwner) external;

    function expirations(address, address) external view returns (uint256);
}

// https://gnosisscan.io/token/0x4ecaba5870353805a9f068101a40e0f32ed605c6#code
interface ITokenProxy is IPermittableToken {
    function implementation() external view returns (address impl);

    fallback() external payable;

    receive() external payable;
}

// https://gnosisscan.io/token/0xe91d153e0b41518a2ce8dd3d7944fa863463a97d#code
interface IWXDAI is IERC20 {
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    function deposit() external payable;

    fallback() external payable;

    receive() external payable;
}

// https://gnosisscan.io/token/0xd057604a14982fe8d88c5fc25aac3267ea142a08#code
interface IUnverified_Proxy {
    /*
    Bytecodes: 0x608060405260043610603e5763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416635c60da1b81146092575b6000604660cd565b905073ffffffffffffffffffffffffffffffffffffffff81161515606957600080fd5b60405136600082376000803683855af43d82016040523d6000833e808015608e573d83f35b3d83fd5b348015609d57600080fd5b5060a460cd565b6040805173ffffffffffffffffffffffffffffffffffffffff9092168252519081900360200190f35b7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc54905600a165627a7a7230582034da58b5567cb69b69fa69e0e2201b959d96b8a3720dfa4a43427289723d36cc0029

    // Decompiled by library.dedaub.com
    // Compiled using the solidity compiler version 0.4.7<=v<0.5.9

    // Data structures and variables inferred from the use of storage instructions
    uint256 stor_360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc_0_0; // STORAGE[0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc] bytes 0 to 0
    uint256 _implementation; // STORAGE[0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc] bytes 0 to 19



    function () public payable { 
        require(stor_360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc_0_0);
        v0, v1 = STORAGE[0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc].delegatecall(MEM[(MEM[64]) len msg.data.length], MEM[0 len 0]).gas(msg.gas);
        MEM[64] = MEM[64] + RETURNDATASIZE();
        require(v0, MEM[64], RETURNDATASIZE());
        return MEM[(MEM[64]) len (RETURNDATASIZE())];
    }

    function implementation() public nonPayable { 
        return _implementation;
    }

    // Note: The function selector is not present in the original solidity code.
    // However, we display it for the sake of completeness.

    function __function_selector__(bytes4 function_selector) public payable { 
        MEM[64] = 128;
        if (msg.data.length >= 4) {
            if (uint32(function_selector >> 224) == 0x5c60da1b) {
                implementation();
            }
        }
        ();
    }
    */

    function implementation() external view returns (address impl);

    fallback() external payable;

    receive() external payable;
}

// github/DeFiHackLabs
interface ICurve {
    function exchange(
        int128 i,
        int128 j,
        uint256 _dx,
        uint256 _min_dy
    ) external;
}

// https://gnosisscan.io/address/0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506#code
interface IUniswapV2Router02 {
    function WETH() external view returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function factory() external view returns (address);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountsIn(
        uint256 amountOut,
        address[] memory path
    ) external view returns (uint256[] memory amounts);

    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) external view returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external;

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    receive() external payable;
}

// github/DeFiHackLabs
// https://docs.sushi.com/docs/Products/Classic%20AMM/Contracts/V2Factory
interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

// github/DeFiHackLabs
// https://docs.sushi.com/docs/Products/Classic%20AMM/Contracts/V2Pair
interface IUniswapV2Pair {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function balanceOf(address account) external view returns (uint256);
}

// github/DeFiHackLabs
// https://github.com/sushiswap/sushiswap/blob/master/protocols/sushixswap/contracts/interfaces/IWETH.sol
interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}
