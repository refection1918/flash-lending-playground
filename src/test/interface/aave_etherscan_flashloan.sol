// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ILendingPool {
    function flashLoan(
        address receiverAddress,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;

    function repay(
        address _reserve,
        uint256 _amount,
        address _onBehalfOf
    ) external payable;
}

