// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";
import "interface/celer_etherscan_blockchain.sol";

import "./Pb.sol";

contract CelerCommon is DSCommon {
    // Swap or Flashloan provider

    // Protocol
    // ISGN sgn = ISGN(0xCb4A7569a61300C50Cf80A2be16329AD9F5F8F9e);
    // IGovernance gov = IGovernance(0xea129aE043C4cB73DcB241AAA074F9E667641BA0);
    IERC20 relay_executor_2 =
        IERC20(0x98E9D288743839e96A8005a6B51C770Bbf7788C0);

    // Tokens
    ITetherToken USDT =
        ITetherToken(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IFiatTokenV2_1 USDC =
        IFiatTokenV2_1(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IMaskToken MASK = IMaskToken(0x69af81e73A73B40adF4f3d4223Cd9b1ECE623074);
    IWETH9 WETH = IWETH9(payable(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2));

    // Liquidity Pools
    IStaking staking =
        IStaking(payable(0x8a4B4C2aCAdeAa7206Df96F00052e41d74a015CE));
    IStakingReward staking_reward =
        IStakingReward(0xb01fd7Bc0B3c433e313bf92daC09FF3942212b42);
    IBridge cbridge =
        IBridge(payable(0x5427FEFA711Eff984124bFBB1AB6fbf5E3DA1820));

    using Pb for Pb.Buffer; // so we can call Pb funcs on Buffer obj

    // Refer to PbBridge.sol
    struct Relay {
        address sender; // tag: 1
        address receiver; // tag: 2
        address token; // tag: 3
        uint256 amount; // tag: 4
        uint64 srcChainId; // tag: 5
        uint64 dstChainId; // tag: 6
        bytes32 srcTransferId; // tag: 7
    } // end struct Relay

    // Refer to PbPool.sol
    struct WithdrawMsg {
        uint64 chainid; // tag: 1
        uint64 seqnum; // tag: 2
        address receiver; // tag: 3
        address token; // tag: 4
        uint256 amount; // tag: 5
        bytes32 refid; // tag: 6
    } // end struct WithdrawMsg

    function setUp2() public virtual {
        super.setUp1();

        // Assign label to Swap or Flashloan provider

        // Assign label to protocol
        cheats.label(address(relay_executor_2), "Relay Executor 2");

        // Assign label to tokens
        cheats.label(address(USDC), "USDC");
        cheats.label(address(USDT), "USDT");
        cheats.label(address(MASK), "MASK");
        cheats.label(address(WETH), "WETH");

        // Assign label to LPs
        cheats.label(address(staking), "staking");
        cheats.label(address(staking_reward), "staking_reward");
        cheats.label(address(cbridge), "cBridge V2");
    }

    function get_sigs() public returns (bytes[] memory) {
        bytes[] memory sigs = new bytes[](7);
        sigs[
            0
        ] = hex"dbc47d4ba80be9227b17baa50f32a5b1e5a98c52546e74ad39deb68e7863c9cd42d8feefd16bd9e7b0d74d760c75664397c7f6b83ac414ce36f3c6e9db01780f1b";
        sigs[
            1
        ] = hex"097b31bef24d19a3528652b0b82617495a8fe83194d589347dfe15a6939b1e98271686635ddee053035882593919dd7159280776a5e95a995637bbdf601b7aa21c";
        sigs[
            2
        ] = hex"b91c8cdcacb4d2e7c2699975b76d484e79cb5dd57de0b952acfddb3d793e96df76459db7b90b731f745d1d75e00884e1f80430c2cd39f593f72864fb8cff033e1b";
        sigs[
            3
        ] = hex"465668b4a7114c0128a7d0b9350d39a39a9a0f65830afc7a19ea109a28a0955e4d8c9f6eb0228271b8ee46ebd7fd56d8bb3feab3fb2848b383cd598a148230831b";
        sigs[
            4
        ] = hex"df49a96f807a12435a87f4d8420e4592905cb02699de0a308443f8b705eaef681c96fc53f710d1ad5833109d707cdbf596411cd97edae1d9d5c6181076b0cdba1c";
        sigs[
            5
        ] = hex"227bff9546f23fdda7ccddae7d6fa87c1cee5a01178cf540e4da606baf54671027b1cbb59e1c82327d21e6a11440a619b02758e3db858409a8d17983702917c81c";
        sigs[
            6
        ] = hex"8104fc29800e8e2669ec7711a839a2a92505692afd21a32403a1129bdab5a7fe4866134ccde0616c589efd450d899071402c7ed6a9f1031a6d0d1acdd16ff90f1c";
        return sigs;
    }

    function get_signers() public returns (address[] memory) {
        address[] memory signers = new address[](20);
        signers[0] = 0x241A100333EEfA2efC389Ec836A6fF619fC1c644;
        signers[1] = 0x273035E10F106499efAce385DbA07135E7cC8E54;
        signers[2] = 0x55f4A1BFc655cf55eD325F2338a1deE84f754Df2;
        signers[3] = 0x870cF8Dd5d9C8eB1403dfd6e6A4753f4d617A538;
        signers[4] = 0x95016E36Adb4e0151735Ced3992A7Fa54E16BD08;
        signers[5] = 0x954ADc74481634b4d278C459853b4e6cc17aE8D2;
        signers[6] = 0x98E9D288743839e96A8005a6B51C770Bbf7788C0;
        signers[7] = 0x9a66644084108a1bC23A9cCd50d6d63E53098dB6;
        signers[8] = 0x9a8CFAcF513fB3d5E39F5952C8608e985B3DC6eF;
        signers[9] = 0x9AC5279013EdfEC74c5c2976FC831Ad0527402E0;
        signers[10] = 0x9Cd5006e1BfF785dad5869efd81a2c42545C9d9b;
        signers[11] = 0xa73B339c3fae27bedf7Cb72D9D000b08fc899609;
        signers[12] = 0xbfa2F68bf9Ad60Dc3cFB1cEF04730Eb7FA251424;
        signers[13] = 0xc74ACAb8C0a340f585d008cB521d64d2554171A8;
        signers[14] = 0xcF12DD34d7597D06ff98F85d2B9483D9D5f7D952;
        signers[15] = 0xd10c833f4305E1053a64Bc738c550381f48104Ca;
        signers[16] = 0xf3d912E7FB180ACDEa31A52797D55Ee2988AB907;
        signers[17] = 0xF4151eEbFa1B9C87dD92c8243A18B1bAEf8C1813;
        signers[18] = 0xF5AD7f3782E8A67BffA297684e27CF9fCC781Be1;
        signers[19] = 0xF6e93Eb288658de5E2E982f99D2b378B22959d15;
        return signers;
    }

    function get_powers() public returns (uint256[] memory) {
        uint256[] memory powers = new uint256[](20);

        // Block: 17321482
        powers[0] = 58017430330000000000000000;
        powers[1] = 375359560282780000000000000;
        powers[2] = 64009851920000000000000000;
        powers[3] = 99129699420000000000000000;
        powers[4] = 33355101190000000000000000;
        powers[5] = 52996859290000000000000000;
        powers[6] = 204585358100000000000000000;
        powers[7] = 357732784813052544900122309;
        powers[8] = 86935125656910000000000000;
        powers[9] = 69034273610000000000000000;
        powers[10] = 331192749490000000000000000;
        powers[11] = 100636098270000000000000000;
        powers[12] = 249528699350000000000000000;
        powers[13] = 175795640370000000000000000;
        powers[14] = 73788848100000000000000000;
        powers[15] = 150384202350000000000000000;
        powers[16] = 111614731910000000000000;
        powers[17] = 81572970450000000000000000;
        powers[18] = 121127353300000000000000000;
        powers[19] = 76006516000000000000000000;
        return powers;
    }

    function encWithdrawMsg(
        WithdrawMsg memory m
    ) internal returns (bytes memory encoded) {
        bytes memory buf;

        buf = abi.encodePacked(buf, Pb.encKey(1, Pb.WireType.Varint));
        buf = abi.encodePacked(buf, Pb.encVarint(uint64(m.chainid)));

        buf = abi.encodePacked(buf, Pb.encKey(2, Pb.WireType.Varint));
        buf = abi.encodePacked(buf, Pb.encVarint(uint64(m.seqnum)));

        buf = abi.encodePacked(buf, Pb.encKey(3, Pb.WireType.LengthDelim));
        buf = abi.encodePacked(buf, Pb.encBytes(addressToBytes(m.receiver)));

        buf = abi.encodePacked(buf, Pb.encKey(4, Pb.WireType.LengthDelim));
        buf = abi.encodePacked(buf, Pb.encBytes(addressToBytes(m.token)));

        buf = abi.encodePacked(buf, Pb.encKey(5, Pb.WireType.LengthDelim));

        // emit log_named_bytes(
        //     "abi.encodePacked(m.amount)",
        //     abi.encodePacked(m.amount)
        // );

        bytes memory value = getNonZeroValue(m.amount);

        // emit log_named_bytes(
        //     "value",
        //     value
        // );

        // buf = abi.encodePacked(buf, Pb.encBytes(length));
        buf = abi.encodePacked(buf, Pb.encBytes(value));

        encoded = buf;
        return encoded;
    }

    function getNonZeroValue(
        uint256 amount
    ) internal returns (bytes memory value) {
        bytes memory packedAmount = abi.encodePacked(amount);
        uint256 offset = 0;

        // Find the first non-zero byte
        while (offset < packedAmount.length && packedAmount[offset] == 0) {
            offset++;
        }

        // Compute the length of the non-zero value
        uint256 nonZeroLength = packedAmount.length - offset;

        // Extract the non-zero value
        value = new bytes(nonZeroLength);
        for (uint256 i = 0; i < nonZeroLength; i++) {
            value[i] = packedAmount[offset + i];
        }
    }

    function uint256ToBytes(uint256 x) internal returns (bytes memory b) {
        b = new bytes(32);
        assembly {
            mstore(add(b, 32), x)
        }

        emit log_named_bytes("b", b);
    }

    // Refer to PbPool.sol
    function decWithdrawMsg(
        bytes memory raw
    ) internal returns (WithdrawMsg memory m) {
        Pb.Buffer memory buf = Pb.fromBytes(raw);

        uint256 tag;
        Pb.WireType wire;
        while (buf.hasMore()) {
            (tag, wire) = buf.decKey();
            if (false) {}
            // solidity has no switch/case
            else if (tag == 1) {
                m.chainid = uint64(buf.decVarint());
            } else if (tag == 2) {
                m.seqnum = uint64(buf.decVarint());
            } else if (tag == 3) {
                m.receiver = Pb._address(buf.decBytes());
            } else if (tag == 4) {
                m.token = Pb._address(buf.decBytes());
            } else if (tag == 5) {
                m.amount = Pb._uint256(buf.decBytes());
            } else if (tag == 6) {
                m.refid = Pb._bytes32(buf.decBytes());
            } else {
                buf.skipValue(wire);
            } // skip value of unknown tag
        }
    } // end decoder WithdrawMsg

    function addressToBytes(address a) internal returns (bytes memory b) {
        assembly {
            let m := mload(0x40)
            a := and(a, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            mstore(
                add(m, 20),
                xor(0x140000000000000000000000000000000000000000, a)
            )
            mstore(0x40, add(m, 52))
            b := m
        }
    }

    function bytesToAddress(bytes memory b) internal returns (address a) {
        require(b.length == 20, "Invalid address length"); // Ensure the input bytes length is correct
        assembly {
            a := mload(add(b, 20)) // Load the 20 bytes from memory starting at the offset of 20
        }
    }

    function bytes32ToBytes(bytes32 x) internal returns (bytes memory b) {
        b = new bytes(32);
        assembly {
            mstore(add(b, 32), x)
        }
    }
}
