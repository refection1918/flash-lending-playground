// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IOVM_SequencerFeeVault {
    function MIN_WITHDRAWAL_AMOUNT() external view returns (uint256);

    function l1FeeWallet() external view returns (address);

    function withdraw() external;

    receive() external payable;
}