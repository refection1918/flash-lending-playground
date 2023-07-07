// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "interface/ethereum_blockchain.sol";

// https://gnosisscan.io/token/0xa639fb3f8c52e10e10a8623616484d41765d5f82#code
interface ILPToken is IERC20 {
    event Initialized(uint8 version);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function burnFrom(address account, uint256 amount) external;

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) external returns (bool);

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) external returns (bool);

    function initialize(
        string memory name,
        string memory symbol
    ) external returns (bool);

    function mint(address recipient, uint256 amount) external;

    function renounceOwnership() external;

    function transferOwnership(address newOwner) external;
}
