// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./connext__etherscan__common.sol";

// For Proxy Vulnerability,
// Refer to https://github.com/runtimeverification/foundry-upgradeable-contracts-examples/tree/master/test
contract connext_etherscan_Proxy_Test is ConnextCommon {
    using SafeMath for uint256;

    function setUp() public {
        super.setUp2();

        cheats.createSelectFork("ethereum", 17599948);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // ----------------------------------------------------------------------------
    // Governance
    // ----------------------------------------------------------------------------
    function skip_test__governance() public {
        // emit log_named_uint(
        //     "domain",
        //     ConnextDiamond_Proxy.domain()
        // );
        // emit log_named_uint(
        //     "nonce",
        //     ConnextDiamond_Proxy.nonce()
        // );
        // emit log_named_address(
        //     "xAppConnectionManager",
        //     ConnextDiamond_Proxy.xAppConnectionManager()
        // );
    }

    // ----------------------------------------------------------------------------
    // Delegate Call
    // ----------------------------------------------------------------------------
    function skip_test__delegate_call() public {
        // Execute the initialization on the deployed contract
        // ConnextDiamond_Proxy.initializeDiamondCut(msg.sender, new IDiamondCut.FacetCut[](0), initializations);
    }

    // ----------------------------------------------------------------------------
    // Fallback
    // ----------------------------------------------------------------------------
    function skip_test__fallback() public {}

    // ----------------------------------------------------------------------------
    // Token Storage Slot
    // ----------------------------------------------------------------------------
    function skip_test__token_storage_slot() public {
        // address Alice = makeAddr("Alice");
        // t.mint(Alice, 5 ether);
        // // Compute the slot at which Alice's balance is stored in the Token contract
        // bytes32 aliceBalanceSlot = keccak256(
        //     abi.encodePacked(uint256(uint160(Alice)), uint256(1))
        // );
        // // Now load Alice's balance
        // uint256 aliceBalance = uint256(cheats.load(address(t), aliceBalanceSlot));
        // // Make sure that the loaded balance matches Alice's real balance
        // assertEq(aliceBalance, t.balanceOf(Alice));
    }
}
