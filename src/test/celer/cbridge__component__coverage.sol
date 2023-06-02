// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./celer__common.sol";

contract cBridgeComponentTest is CelerCommon {
    using SafeMath for uint256;

    function setUp() public override {
        super.setUp();

        cheats.createSelectFork("ethereum", 17294568);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // ----------------------------------------------------------------------------
    // Governance / Authorization
    // ----------------------------------------------------------------------------
    function testFail__transferOwnership_0() public {
        bridge.transferOwnership(address(0));
    }

    function testFail__transferOwnership_this() public {
        bridge.transferOwnership(address(this));
    }

    function testFail__addGovernor_change_0() public {
        console.log("BEFORE: isGovernor:", bridge.isGovernor(address(0)));
        bridge.addGovernor(address(0));
        console.log("AFTER: isGovernor:", bridge.isGovernor(address(0)));
    }

    function testFail__addGovernor_this() public {
        console.log("BEFORE: isGovernor:", bridge.isGovernor(address(this)));
        bridge.addGovernor(address(this));
        console.log("AFTER: isGovernor:", bridge.isGovernor(address(this)));
    }

    function testFail__addPauser_0() public {
        console.log("BEFORE: isPauser:", bridge.isPauser(address(0)));
        bridge.addPauser(address(0));
        console.log("AFTER: isPauser:", bridge.isPauser(address(0)));
    }

    function testFail__addPauser_this() public {
        console.log("BEFORE: isPauser:", bridge.isPauser(address(this)));
        bridge.addPauser(address(this));
        console.log("AFTER: isPauser:", bridge.isPauser(address(this)));
    }

    function testFail__renounceGovernor() public {
        bridge.renounceGovernor();
    }

    function testFail__renounceOwnership() public {
        bridge.renounceOwnership();
    }

    function testFail__renouncePauser() public {
        bridge.renouncePauser();
    }

    function testFail__removeGovernor_0() public {
        bridge.removeGovernor(address(0));
    }

    function testFail__removeGovernor_this() public {
        bridge.removeGovernor(address(this));
    }

    function testFail__removePauser_0() public {
        bridge.removePauser(address(0));
    }

    function testFail__removePauser_this() public {
        bridge.removePauser(address(this));
    }

    function testFail__pause() public {
        console.log("BEFORE: paused:", bridge.paused());
        bridge.pause();
        console.log("AFTER: paused:", bridge.paused());
    }

    function testFail__notifyResetSigners() public {
        bridge.notifyResetSigners();
    }

    function testFail__unpause() public {
        bridge.unpause();
    }

    function testFail__setWrap_0() public {
        bridge.setWrap(address(0));
    }

    function testFail__setWrap() public {
        bridge.setWrap(address(this));
    }

    // ----------------------------------------------------------------------------
    // Parameter Change
    // ----------------------------------------------------------------------------
    function testFail__setDelayPeriod__min() public {
        bridge.setDelayPeriod(0);
    }

    function testFail__setDelayPeriod__max() public {
        bridge.setDelayPeriod(type(uint256).max);
    }

    function testFail__setEpochLength__min() public {
        bridge.setEpochLength(0);
    }

    function testFail__setEpochLength__max() public {
        bridge.setEpochLength(type(uint256).max);
    }

    function testFail__increaseNoticePeriod__min() public {
        bridge.increaseNoticePeriod(0);
    }

    function testFail__increaseNoticePeriod__max() public {
        bridge.increaseNoticePeriod(type(uint256).max);
    }

    // ----------------------------------------------------------------------------
    // Key Encode and Decode
    // ----------------------------------------------------------------------------
    function test__key__encode_and_decode() public {
        uint256 max_wire_type_iteration = uint256(Pb.WireType.Fixed32) + 1;
        uint256 max_tag_iteration = 5_000;
        for (uint256 input_tag=0; input_tag < max_tag_iteration; input_tag++) {
            for (uint256 i = 0; i < max_wire_type_iteration; i++) {
                Pb.WireType input_wiretype = Pb.WireType(i);
                Pb.Buffer memory buf = Pb.fromBytes(Pb.encKey(input_tag, input_wiretype));
                (uint256 output_tag, Pb.WireType output_wiretype) = Pb.decKey(buf);

                // emit log_named_uint(
                //     "input_tag",
                //     input_tag
                // );

                // emit log_named_uint(
                //     "output_tag",
                //     output_tag
                // );

                assertEq(output_tag, input_tag);
                assertTrue(output_wiretype == input_wiretype);
            }
        }
    }

    // ----------------------------------------------------------------------------
    // Varint Encode and Decode
    // ----------------------------------------------------------------------------
    function test__varint__encode_and_decode() public {
        uint256 max_iteration = 5_000;
        for (uint256 input_v=0; input_v < max_iteration; input_v++) {
            Pb.Buffer memory buf = Pb.fromBytes(Pb.encVarint(input_v));
            uint256 output_v = Pb.decVarint(buf);

            // emit log_named_uint(
            //     "input_v",
            //     input_v
            // );

            // emit log_named_uint(
            //     "output_v",
            //     output_v
            // );

            assertEq(output_v, input_v);
        }
    }

    // ----------------------------------------------------------------------------
    // Bytes Encode and Decode
    // ----------------------------------------------------------------------------
    function test__bytes__encode_and_decode() public {
        bytes memory my_address_in_bytes = Pb.encBytes(addressToBytes(address(this)));
        Pb.Buffer memory buf = Pb.fromBytes(my_address_in_bytes);
        bytes memory output_address_in_bytes = Pb.decBytes(buf);
        address output_address = bytesToAddress(output_address_in_bytes);
        assertEq(output_address, address(this));
    }

    // ----------------------------------------------------------------------------
    // Verify Signature
    // https://etherscan.io/tx/0x15e14e912b20bfea5020ed70e1909f682abe3841b56dd34c24417c0916a28b2f
    // ----------------------------------------------------------------------------
    function test__verify_signature() public {
        bytes memory goldenEncodedWithdrawMsg = hex"0801108db7b2a3061a14089a2c44131b1eb30cc4fc226560163fcef2c2882214a0b86991c6218b36c1d19d4a2e9eb0ce3606eb482a058cc91c9930";
        bytes[] memory sigs = get_sigs();
        address[] memory signers = get_signers();
        uint256[] memory powers = get_powers();

        bytes32 domain = keccak256(abi.encodePacked(block.chainid, address(cbridge), "WithdrawMsg"));
        cbridge.verifySigs(abi.encodePacked(domain, goldenEncodedWithdrawMsg), sigs, signers, powers);
    }

    // ----------------------------------------------------------------------------
    // Verify Withdraw Message Encode and Decode
    // https://etherscan.io/tx/0x15e14e912b20bfea5020ed70e1909f682abe3841b56dd34c24417c0916a28b2f
    // ----------------------------------------------------------------------------
    function test__verify_withdraw____encode_and_decode() public {
        bytes memory goldenEncodedWithdrawMsg = hex"0801108db7b2a3061a14089a2c44131b1eb30cc4fc226560163fcef2c2882214a0b86991c6218b36c1d19d4a2e9eb0ce3606eb482a058cc91c9930";

        WithdrawMsg memory m = decWithdrawMsg(goldenEncodedWithdrawMsg);

        // emit log_named_uint(
        //     "m.chainid",
        //     m.chainid
        // );

        // emit log_named_uint(
        //     "m.seqnum",
        //     m.seqnum
        // );

        // emit log_named_address(
        //     "m.receiver",
        //     m.receiver
        // );

        // emit log_named_address(
        //     "m.token",
        //     m.token
        // );

        // emit log_named_uint(
        //     "m.amount",
        //     m.amount
        // );

        // emit log_named_bytes32(
        //     "m.refid",
        //     m.refid
        // );

        bytes memory exploitedEncodedWithdrawMsg = encWithdrawMsg(m);

        emit log_named_bytes(
            "   goldenEncodedWithdrawMsg",
            goldenEncodedWithdrawMsg
        );

        emit log_named_bytes(
            "exploitedEncodedWithdrawMsg",
            exploitedEncodedWithdrawMsg
        );

        assertTrue(keccak256(exploitedEncodedWithdrawMsg) == keccak256(goldenEncodedWithdrawMsg));
    }
}
