// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/StdStorage.sol";
import "openzeppelin-contracts/utils/math/SafeMath.sol";

import "interface/cheat_codes.sol";
import "interface/etherscan_blockchain.sol";
import "helper/helper_library.sol";

contract BobaCommon is DSTest {
    // Foundry
    CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    // https://mirror.xyz/brocke.eth/PnX7oAcU4LJCxcoICiaDhq_MUUu9euaM8Y5r465Rd2U
    using stdStorage for StdStorage;
    StdStorage stdstore;

    function writeTokenBalance(
        address owner,
        address token,
        uint256 amount
    ) internal {
        stdstore
            .target(token)
            .sig(IERC20(token).balanceOf.selector)
            .with_key(owner)
            .checked_write(amount);
    }
}