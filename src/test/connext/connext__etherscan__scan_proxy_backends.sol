// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./connext__etherscan__common.sol";

// For Proxy Vulnerability,
// Refer to https://github.com/runtimeverification/foundry-upgradeable-contracts-examples/tree/master/test
contract connext_etherscan_Scan_Proxy_Test is ConnextEtherscanCommon {
    using SafeMath for uint256;

    function setUp() public {
        super.setUp3();

        cheats.createSelectFork("ethereum", 17599948);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // ----------------------------------------------------------------------------
    // Decode Constructor Args
    // ----------------------------------------------------------------------------
    function skip_test__dump_connext_diamond_impl__constructor_arg() public {
        bytes32[] memory args = new bytes32[](205);
        args[
            0
        ] = hex"000000000000000000000000ade09131c6f43fe22c2cbabb759636c43cfc181e";
        args[
            1
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            2
        ] = hex"0000000000000000000000000000000000000000000000000000000000001720";
        args[
            3
        ] = hex"000000000000000000000000000000000000000000000000000000000000000b";
        args[
            4
        ] = hex"0000000000000000000000000000000000000000000000000000000000000160";
        args[
            5
        ] = hex"0000000000000000000000000000000000000000000000000000000000000460";
        args[
            6
        ] = hex"0000000000000000000000000000000000000000000000000000000000000700";
        args[
            7
        ] = hex"00000000000000000000000000000000000000000000000000000000000007a0";
        args[
            8
        ] = hex"0000000000000000000000000000000000000000000000000000000000000a60";
        args[
            9
        ] = hex"0000000000000000000000000000000000000000000000000000000000000b80";
        args[
            10
        ] = hex"0000000000000000000000000000000000000000000000000000000000000f00";
        args[
            11
        ] = hex"0000000000000000000000000000000000000000000000000000000000001200";
        args[
            12
        ] = hex"00000000000000000000000000000000000000000000000000000000000013e0";
        args[
            13
        ] = hex"00000000000000000000000000000000000000000000000000000000000014e0";
        args[
            14
        ] = hex"0000000000000000000000000000000000000000000000000000000000001580";
        args[
            15
        ] = hex"000000000000000000000000ab81339759a1fa51c7509f7b83b8173de4ece848";
        args[
            16
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            17
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            18
        ] = hex"0000000000000000000000000000000000000000000000000000000000000014";
        args[
            19
        ] = hex"1506e46300000000000000000000000000000000000000000000000000000000";
        args[
            20
        ] = hex"6006209100000000000000000000000000000000000000000000000000000000";
        args[
            21
        ] = hex"80dc224800000000000000000000000000000000000000000000000000000000";
        args[
            22
        ] = hex"9b59851900000000000000000000000000000000000000000000000000000000";
        args[
            23
        ] = hex"57bd0a3200000000000000000000000000000000000000000000000000000000";
        args[
            24
        ] = hex"ae8bc0de00000000000000000000000000000000000000000000000000000000";
        args[
            25
        ] = hex"2c1999d000000000000000000000000000000000000000000000000000000000";
        args[
            26
        ] = hex"bd8671a700000000000000000000000000000000000000000000000000000000";
        args[
            27
        ] = hex"1ecf6f9f00000000000000000000000000000000000000000000000000000000";
        args[
            28
        ] = hex"ad4c777100000000000000000000000000000000000000000000000000000000";
        args[
            29
        ] = hex"949de96900000000000000000000000000000000000000000000000000000000";
        args[
            30
        ] = hex"07a38d7b00000000000000000000000000000000000000000000000000000000";
        args[
            31
        ] = hex"f153768600000000000000000000000000000000000000000000000000000000";
        args[
            32
        ] = hex"5a2164e500000000000000000000000000000000000000000000000000000000";
        args[
            33
        ] = hex"a1b1930100000000000000000000000000000000000000000000000000000000";
        args[
            34
        ] = hex"03e418c200000000000000000000000000000000000000000000000000000000";
        args[
            35
        ] = hex"b64a5e0700000000000000000000000000000000000000000000000000000000";
        args[
            36
        ] = hex"e1cb395800000000000000000000000000000000000000000000000000000000";
        args[
            37
        ] = hex"c405842900000000000000000000000000000000000000000000000000000000";
        args[
            38
        ] = hex"e9d7bcec00000000000000000000000000000000000000000000000000000000";
        args[
            39
        ] = hex"0000000000000000000000001a92fc9ec2b55f6b0a5d33996349099623c9c4fc";
        args[
            40
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            41
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            42
        ] = hex"0000000000000000000000000000000000000000000000000000000000000011";
        args[
            43
        ] = hex"8a33623100000000000000000000000000000000000000000000000000000000";
        args[
            44
        ] = hex"159e041f00000000000000000000000000000000000000000000000000000000";
        args[
            45
        ] = hex"2424401f00000000000000000000000000000000000000000000000000000000";
        args[
            46
        ] = hex"c2fb26a600000000000000000000000000000000000000000000000000000000";
        args[
            47
        ] = hex"b49c53a700000000000000000000000000000000000000000000000000000000";
        args[
            48
        ] = hex"63e3e7d200000000000000000000000000000000000000000000000000000000";
        args[
            49
        ] = hex"cb8058ba00000000000000000000000000000000000000000000000000000000";
        args[
            50
        ] = hex"5412671100000000000000000000000000000000000000000000000000000000";
        args[
            51
        ] = hex"affed0e000000000000000000000000000000000000000000000000000000000";
        args[
            52
        ] = hex"121cca3100000000000000000000000000000000000000000000000000000000";
        args[
            53
        ] = hex"6989ca7c00000000000000000000000000000000000000000000000000000000";
        args[
            54
        ] = hex"1a8bc0e100000000000000000000000000000000000000000000000000000000";
        args[
            55
        ] = hex"41bdc8b500000000000000000000000000000000000000000000000000000000";
        args[
            56
        ] = hex"bfd7903000000000000000000000000000000000000000000000000000000000";
        args[
            57
        ] = hex"3339df9600000000000000000000000000000000000000000000000000000000";
        args[
            58
        ] = hex"8aac16ba00000000000000000000000000000000000000000000000000000000";
        args[
            59
        ] = hex"91f5de7900000000000000000000000000000000000000000000000000000000";
        args[
            60
        ] = hex"0000000000000000000000005bc7c227629acda6c799d6487a0c2b4a8d7e2ae9";
        args[
            61
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            62
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            63
        ] = hex"0000000000000000000000000000000000000000000000000000000000000001";
        args[
            64
        ] = hex"ab2dc3f500000000000000000000000000000000000000000000000000000000";
        args[
            65
        ] = hex"000000000000000000000000e535c4d213d54a8bc32e11f5df4eb6fee8a599b7";
        args[
            66
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            67
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            68
        ] = hex"0000000000000000000000000000000000000000000000000000000000000012";
        args[
            69
        ] = hex"c5b350df00000000000000000000000000000000000000000000000000000000";
        args[
            70
        ] = hex"bb271a2700000000000000000000000000000000000000000000000000000000";
        args[
            71
        ] = hex"2ec0c00200000000000000000000000000000000000000000000000000000000";
        args[
            72
        ] = hex"a9943b1b00000000000000000000000000000000000000000000000000000000";
        args[
            73
        ] = hex"6a42b8f800000000000000000000000000000000000000000000000000000000";
        args[
            74
        ] = hex"8da5cb5b00000000000000000000000000000000000000000000000000000000";
        args[
            75
        ] = hex"8456cb5900000000000000000000000000000000000000000000000000000000";
        args[
            76
        ] = hex"5c975abb00000000000000000000000000000000000000000000000000000000";
        args[
            77
        ] = hex"b1f8100d00000000000000000000000000000000000000000000000000000000";
        args[
            78
        ] = hex"c56ce35800000000000000000000000000000000000000000000000000000000";
        args[
            79
        ] = hex"d1851c9200000000000000000000000000000000000000000000000000000000";
        args[
            80
        ] = hex"3cf52ffb00000000000000000000000000000000000000000000000000000000";
        args[
            81
        ] = hex"c91cb56a00000000000000000000000000000000000000000000000000000000";
        args[
            82
        ] = hex"23986f7d00000000000000000000000000000000000000000000000000000000";
        args[
            83
        ] = hex"80e52e3f00000000000000000000000000000000000000000000000000000000";
        args[
            84
        ] = hex"6be5578500000000000000000000000000000000000000000000000000000000";
        args[
            85
        ] = hex"1223293700000000000000000000000000000000000000000000000000000000";
        args[
            86
        ] = hex"3f4ba83a00000000000000000000000000000000000000000000000000000000";
        args[
            87
        ] = hex"0000000000000000000000000e110ce2571986e43ca3a296b6f3aa0cf5e1cffa";
        args[
            88
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            89
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            90
        ] = hex"0000000000000000000000000000000000000000000000000000000000000005";
        args[
            91
        ] = hex"dd39f00d00000000000000000000000000000000000000000000000000000000";
        args[
            92
        ] = hex"8cba8b6a00000000000000000000000000000000000000000000000000000000";
        args[
            93
        ] = hex"65bc858200000000000000000000000000000000000000000000000000000000";
        args[
            94
        ] = hex"60f0a5ac00000000000000000000000000000000000000000000000000000000";
        args[
            95
        ] = hex"f01b3e0100000000000000000000000000000000000000000000000000000000";
        args[
            96
        ] = hex"00000000000000000000000007b2edf050b93986f1ac96fe6d1be05919f73bd1";
        args[
            97
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            98
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            99
        ] = hex"0000000000000000000000000000000000000000000000000000000000000018";
        args[
            100
        ] = hex"4b72c5da00000000000000000000000000000000000000000000000000000000";
        args[
            101
        ] = hex"0951d6d800000000000000000000000000000000000000000000000000000000";
        args[
            102
        ] = hex"09935b8f00000000000000000000000000000000000000000000000000000000";
        args[
            103
        ] = hex"5406459400000000000000000000000000000000000000000000000000000000";
        args[
            104
        ] = hex"2d3f9ef600000000000000000000000000000000000000000000000000000000";
        args[
            105
        ] = hex"f259cd2700000000000000000000000000000000000000000000000000000000";
        args[
            106
        ] = hex"da3a892f00000000000000000000000000000000000000000000000000000000";
        args[
            107
        ] = hex"3b688da600000000000000000000000000000000000000000000000000000000";
        args[
            108
        ] = hex"12d5717000000000000000000000000000000000000000000000000000000000";
        args[
            109
        ] = hex"1407093b00000000000000000000000000000000000000000000000000000000";
        args[
            110
        ] = hex"8770e68200000000000000000000000000000000000000000000000000000000";
        args[
            111
        ] = hex"e9160f3e00000000000000000000000000000000000000000000000000000000";
        args[
            112
        ] = hex"c6bf691d00000000000000000000000000000000000000000000000000000000";
        args[
            113
        ] = hex"b214c90100000000000000000000000000000000000000000000000000000000";
        args[
            114
        ] = hex"9bf6d87500000000000000000000000000000000000000000000000000000000";
        args[
            115
        ] = hex"22a3c00700000000000000000000000000000000000000000000000000000000";
        args[
            116
        ] = hex"f72c504800000000000000000000000000000000000000000000000000000000";
        args[
            117
        ] = hex"fd5bd5fe00000000000000000000000000000000000000000000000000000000";
        args[
            118
        ] = hex"41258b5c00000000000000000000000000000000000000000000000000000000";
        args[
            119
        ] = hex"582c78d200000000000000000000000000000000000000000000000000000000";
        args[
            120
        ] = hex"8290471600000000000000000000000000000000000000000000000000000000";
        args[
            121
        ] = hex"ffaf3f1a00000000000000000000000000000000000000000000000000000000";
        args[
            122
        ] = hex"911b8ee200000000000000000000000000000000000000000000000000000000";
        args[
            123
        ] = hex"04376ff400000000000000000000000000000000000000000000000000000000";
        args[
            124
        ] = hex"000000000000000000000000578eeb7b76558009933046ad2e3d888c9b9b9b63";
        args[
            125
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            126
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            127
        ] = hex"0000000000000000000000000000000000000000000000000000000000000014";
        args[
            128
        ] = hex"8d36545700000000000000000000000000000000000000000000000000000000";
        args[
            129
        ] = hex"a02288f400000000000000000000000000000000000000000000000000000000";
        args[
            130
        ] = hex"29d99b1000000000000000000000000000000000000000000000000000000000";
        args[
            131
        ] = hex"8f11d27f00000000000000000000000000000000000000000000000000000000";
        args[
            132
        ] = hex"76ca2e5200000000000000000000000000000000000000000000000000000000";
        args[
            133
        ] = hex"d251dc3500000000000000000000000000000000000000000000000000000000";
        args[
            134
        ] = hex"7652f59d00000000000000000000000000000000000000000000000000000000";
        args[
            135
        ] = hex"1301caa200000000000000000000000000000000000000000000000000000000";
        args[
            136
        ] = hex"8b480b1200000000000000000000000000000000000000000000000000000000";
        args[
            137
        ] = hex"2d91a51500000000000000000000000000000000000000000000000000000000";
        args[
            138
        ] = hex"b3a4eab400000000000000000000000000000000000000000000000000000000";
        args[
            139
        ] = hex"bb0577eb00000000000000000000000000000000000000000000000000000000";
        args[
            140
        ] = hex"ad94911b00000000000000000000000000000000000000000000000000000000";
        args[
            141
        ] = hex"f495e80700000000000000000000000000000000000000000000000000000000";
        args[
            142
        ] = hex"4bbcba8e00000000000000000000000000000000000000000000000000000000";
        args[
            143
        ] = hex"241ca57a00000000000000000000000000000000000000000000000000000000";
        args[
            144
        ] = hex"b6618dff00000000000000000000000000000000000000000000000000000000";
        args[
            145
        ] = hex"ff126de900000000000000000000000000000000000000000000000000000000";
        args[
            146
        ] = hex"80b297e800000000000000000000000000000000000000000000000000000000";
        args[
            147
        ] = hex"74c6b89b00000000000000000000000000000000000000000000000000000000";
        args[
            148
        ] = hex"000000000000000000000000bb4f294236d9c834847adfe2d4ca4f43b6836dd8";
        args[
            149
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            150
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            151
        ] = hex"000000000000000000000000000000000000000000000000000000000000000b";
        args[
            152
        ] = hex"ea027c2f00000000000000000000000000000000000000000000000000000000";
        args[
            153
        ] = hex"e5f6220f00000000000000000000000000000000000000000000000000000000";
        args[
            154
        ] = hex"4b141bb400000000000000000000000000000000000000000000000000000000";
        args[
            155
        ] = hex"2bf63bcc00000000000000000000000000000000000000000000000000000000";
        args[
            156
        ] = hex"1963e42600000000000000000000000000000000000000000000000000000000";
        args[
            157
        ] = hex"3e74aea000000000000000000000000000000000000000000000000000000000";
        args[
            158
        ] = hex"9c8eab9700000000000000000000000000000000000000000000000000000000";
        args[
            159
        ] = hex"43be5eaf00000000000000000000000000000000000000000000000000000000";
        args[
            160
        ] = hex"72a30e0800000000000000000000000000000000000000000000000000000000";
        args[
            161
        ] = hex"8dc5148400000000000000000000000000000000000000000000000000000000";
        args[
            162
        ] = hex"a1a23c2900000000000000000000000000000000000000000000000000000000";
        args[
            163
        ] = hex"000000000000000000000000324c5834cd3bd19c4991f4fc5b3a0ff5257a692b";
        args[
            164
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            165
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            166
        ] = hex"0000000000000000000000000000000000000000000000000000000000000004";
        args[
            167
        ] = hex"1f931c1c00000000000000000000000000000000000000000000000000000000";
        args[
            168
        ] = hex"56a8ea4800000000000000000000000000000000000000000000000000000000";
        args[
            169
        ] = hex"bbf2358e00000000000000000000000000000000000000000000000000000000";
        args[
            170
        ] = hex"2c67849c00000000000000000000000000000000000000000000000000000000";
        args[
            171
        ] = hex"00000000000000000000000005822fa03809f948dece53c05c4abb93aeeb044c";
        args[
            172
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            173
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            174
        ] = hex"0000000000000000000000000000000000000000000000000000000000000001";
        args[
            175
        ] = hex"9a7e155e00000000000000000000000000000000000000000000000000000000";
        args[
            176
        ] = hex"0000000000000000000000003bcf4185443a339517ad4e580067f178d1b68e1d";
        args[
            177
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            178
        ] = hex"0000000000000000000000000000000000000000000000000000000000000060";
        args[
            179
        ] = hex"0000000000000000000000000000000000000000000000000000000000000005";
        args[
            180
        ] = hex"cdffacc600000000000000000000000000000000000000000000000000000000";
        args[
            181
        ] = hex"52ef6b2c00000000000000000000000000000000000000000000000000000000";
        args[
            182
        ] = hex"adfca15e00000000000000000000000000000000000000000000000000000000";
        args[
            183
        ] = hex"7a0ed62700000000000000000000000000000000000000000000000000000000";
        args[
            184
        ] = hex"01ffc9a700000000000000000000000000000000000000000000000000000000";
        args[
            185
        ] = hex"0000000000000000000000000000000000000000000000000000000000000002";
        args[
            186
        ] = hex"0000000000000000000000000000000000000000000000000000000000000040";
        args[
            187
        ] = hex"0000000000000000000000000000000000000000000000000000000000000160";
        args[
            188
        ] = hex"000000000000000000000000e68d85348f227d2ebee814c38918f8a2d7d9b603";
        args[
            189
        ] = hex"0000000000000000000000000000000000000000000000000000000000000040";
        args[
            190
        ] = hex"00000000000000000000000000000000000000000000000000000000000000a4";
        args[
            191
        ] = hex"2a84809100000000000000000000000000000000000000000000000000000000";
        args[
            192
        ] = hex"0000004000000000000000000000000000000000000000000000000000000000";
        args[
            193
        ] = hex"0000008000000000000000000000000000000000000000000000000000000000";
        args[
            194
        ] = hex"0000000148e2b093000000000000000000000000000000000000000000000000";
        args[
            195
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            196
        ] = hex"0000000000000000000000000000000000000000000000000000000000000000";
        args[
            197
        ] = hex"00000000000000000000000005822fa03809f948dece53c05c4abb93aeeb044c";
        args[
            198
        ] = hex"0000000000000000000000000000000000000000000000000000000000000040";
        args[
            199
        ] = hex"0000000000000000000000000000000000000000000000000000000000000084";
        args[
            200
        ] = hex"9a7e155e00000000000000000000000000000000000000000000000000000000";
        args[
            201
        ] = hex"00657468000000000000000000000000dcf026d7fbbffc1633c79e97a2b4dae1";
        args[
            202
        ] = hex"c374406b00000000000000000000000000000000000000000000000000000000";
        args[
            203
        ] = hex"00000000000000000000000000000000f7de5aceeee6091d1103209c337fa00d";
        args[
            204
        ] = hex"0b4b909200000000000000000000000000000000000000000000000000000000";

        string memory data_name;
        bytes32 data_content;
        bool skip_zero_extcode = true;

        /* Smart contracts of connext_diamond_impl
        args[15]: 0xAb81339759A1fA51C7509F7B83b8173De4ece848 => TokenFacet
        args[39]: 0x1A92Fc9ec2B55F6B0a5d33996349099623C9C4fC => BridgeFacet
        args[60]: 0x5bC7C227629AcDA6C799D6487A0c2B4a8d7e2AE9 => InboxFacet
        args[65]: 0xE535c4D213D54a8bc32e11F5DF4EB6FEE8a599B7 => ProposedOwnableFacet
        args[87]: 0x0E110ce2571986e43cA3a296B6f3Aa0Cf5E1CffA => RelayerFacet
        args[96]: 0x07B2EdF050B93986f1Ac96fe6D1Be05919f73bD1 => RoutersFacet
        args[124]: 0x578Eeb7b76558009933046Ad2E3d888C9b9B9B63 => StableSwapFacet
        args[148]: 0xBb4f294236d9C834847AdFe2d4Ca4F43b6836DD8 => SwapAdminFacet
        args[163]: 0x324c5834cD3bD19c4991F4fC5b3a0Ff5257a692b => DiamondCutFacet
        args[171]: 0x05822fA03809F948decE53C05c4abB93AEEb044C => DiamondInit
        args[176]: 0x3Bcf4185443A339517aD4e580067f178d1B68E1D => DiamondLoupeFacet
        args[188]: 0xe68d85348f227d2ebEE814C38918F8A2D7d9B603 => DiamondERC165Init
        args[197]: 0x05822fA03809F948decE53C05c4abB93AEEb044C => DiamondInit
        */
        for (uint256 i = 0; i < 205; i++) {
            data_name = StringHelper.concatenateStringsWithIndex(
                "args",
                cheats.toString(i)
            );
            data_content = args[i];
            dumpBytes(data_name, data_content, skip_zero_extcode);
        }
    }

    // ----------------------------------------------------------------------------
    // Decode Diamond using ConnextDiamond_Proxy
    // ----------------------------------------------------------------------------
    function skip_test__dump_diamond_loupe__using__ConnextDiamond_Proxy()
        public
    {
        // Get all facet addresses
        address[] memory facetAddresses = ConnextDiamond_Proxy.facetAddresses();
        uint256 facetCount = facetAddresses.length;

        emit log_named_uint("facetCount", facetCount);

        IDiamondLoupe.Facet[] memory facets = new IDiamondLoupe.Facet[](
            facetCount
        );

        /* Calling IDiamondLoupeFacet through ConnextDiamond_Proxy
        facetCount: 12
        facetAddress[0]: 0xe37d4f73ef1c85def2174a394f17ac65dd3cbb81 => TokenFacet
        functionSelectors.length: 20
        functionSelector[0]: 0x1506e463
        functionSelector[1]: 0x60062091
        functionSelector[2]: 0x80dc2248
        functionSelector[3]: 0x9b598519
        functionSelector[4]: 0x57bd0a32
        functionSelector[5]: 0xae8bc0de
        functionSelector[6]: 0x2c1999d0
        functionSelector[7]: 0xbd8671a7
        functionSelector[8]: 0x1ecf6f9f
        functionSelector[9]: 0xad4c7771
        functionSelector[10]: 0x949de969
        functionSelector[11]: 0x07a38d7b
        functionSelector[12]: 0xf1537686
        functionSelector[13]: 0x5a2164e5
        functionSelector[14]: 0xa1b19301
        functionSelector[15]: 0x03e418c2
        functionSelector[16]: 0xb64a5e07
        functionSelector[17]: 0xe1cb3958
        functionSelector[18]: 0xc4058429
        functionSelector[19]: 0xe9d7bcec

        facetAddress[1]: 0x3606b0d9c84224892c7407d4e8dcfd7e9e2126a2 => BridgeFacet
        functionSelectors.length: 20
        functionSelector[0]: 0x8a336231
        functionSelector[1]: 0x159e041f
        functionSelector[2]: 0x2424401f
        functionSelector[3]: 0xc2fb26a6
        functionSelector[4]: 0xb49c53a7
        functionSelector[5]: 0x63e3e7d2
        functionSelector[6]: 0xcb8058ba
        functionSelector[7]: 0x54126711
        functionSelector[8]: 0xaffed0e0
        functionSelector[9]: 0x121cca31
        functionSelector[10]: 0x6989ca7c
        functionSelector[11]: 0x1a8bc0e1
        functionSelector[12]: 0x41bdc8b5
        functionSelector[13]: 0xbfd79030
        functionSelector[14]: 0x3339df96
        functionSelector[15]: 0x8aac16ba
        functionSelector[16]: 0x91f5de79
        functionSelector[17]: 0x59efa162
        functionSelector[18]: 0x93f18ac5
        functionSelector[19]: 0x674dc933

        facetAddress[2]: 0x5ccd25372a41eeb3d4e5353879bb28213df5a295 => InboxFacet
        functionSelectors.length: 1
        functionSelector[0]: 0xab2dc3f5

        facetAddress[3]: 0x086b5a16d7bd6b2955fcc7d5f9aa2a1544b67e0d => ProposedOwnableFacet
        functionSelectors.length: 18
        functionSelector[0]: 0xc5b350df
        functionSelector[1]: 0xbb271a27
        functionSelector[2]: 0x2ec0c002
        functionSelector[3]: 0xa9943b1b
        functionSelector[4]: 0x6a42b8f8
        functionSelector[5]: 0x8da5cb5b
        functionSelector[6]: 0x8456cb59
        functionSelector[7]: 0x5c975abb
        functionSelector[8]: 0xb1f8100d
        functionSelector[9]: 0xc56ce358
        functionSelector[10]: 0xd1851c92
        functionSelector[11]: 0x3cf52ffb
        functionSelector[12]: 0xc91cb56a
        functionSelector[13]: 0x23986f7d
        functionSelector[14]: 0x80e52e3f
        functionSelector[15]: 0x6be55785
        functionSelector[16]: 0x12232937
        functionSelector[17]: 0x3f4ba83a

        facetAddress[4]: 0x7993bb17d8d8a0676cc1527f8b4ce52a2b490352 => PortalFacet
        functionSelectors.length: 8
        functionSelector[0]: 0xa03e4bc3
        functionSelector[1]: 0xef1eb0c1
        functionSelector[2]: 0x09d7ba54
        functionSelector[3]: 0xd1e5f31c
        functionSelector[4]: 0xb3f62fcb
        functionSelector[5]: 0x75d32371
        functionSelector[6]: 0x349f937c
        functionSelector[7]: 0x3bd30d34

        facetAddress[5]: 0xccb64fdf1c0cc1aac1c39e5968e82f89c1b8c769 => RelayerFacet
        functionSelectors.length: 5
        functionSelector[0]: 0xdd39f00d
        functionSelector[1]: 0x8cba8b6a
        functionSelector[2]: 0x65bc8582
        functionSelector[3]: 0x60f0a5ac
        functionSelector[4]: 0xf01b3e01

        facetAddress[6]: 0xbe8d8ac9a44fba6cb7a7e02c1e6576e06c7da72d => RoutersFacet
        functionSelectors.length: 24
        functionSelector[0]: 0x4b72c5da
        functionSelector[1]: 0x0951d6d8
        functionSelector[2]: 0x09935b8f
        functionSelector[3]: 0x54064594
        functionSelector[4]: 0x2d3f9ef6
        functionSelector[5]: 0xf259cd27
        functionSelector[6]: 0xda3a892f
        functionSelector[7]: 0x3b688da6
        functionSelector[8]: 0x12d57170
        functionSelector[9]: 0x1407093b
        functionSelector[10]: 0x8770e682
        functionSelector[11]: 0xe9160f3e
        functionSelector[12]: 0xc6bf691d
        functionSelector[13]: 0xb214c901
        functionSelector[14]: 0x9bf6d875
        functionSelector[15]: 0x22a3c007
        functionSelector[16]: 0xf72c5048
        functionSelector[17]: 0xfd5bd5fe
        functionSelector[18]: 0x41258b5c
        functionSelector[19]: 0x582c78d2
        functionSelector[20]: 0x82904716
        functionSelector[21]: 0xffaf3f1a
        functionSelector[22]: 0x911b8ee2
        functionSelector[23]: 0x04376ff4

        facetAddress[7]: 0x9ab5f562dc2acccd1b80d6564b770786e38f0686 => StableSwapFacet
        functionSelectors.length: 20
        functionSelector[0]: 0x8d365457
        functionSelector[1]: 0xa02288f4
        functionSelector[2]: 0x29d99b10
        functionSelector[3]: 0x8f11d27f
        functionSelector[4]: 0x76ca2e52
        functionSelector[5]: 0xd251dc35
        functionSelector[6]: 0x7652f59d
        functionSelector[7]: 0x1301caa2
        functionSelector[8]: 0x8b480b12
        functionSelector[9]: 0x2d91a515
        functionSelector[10]: 0xb3a4eab4
        functionSelector[11]: 0xbb0577eb
        functionSelector[12]: 0xad94911b
        functionSelector[13]: 0xf495e807
        functionSelector[14]: 0x4bbcba8e
        functionSelector[15]: 0x241ca57a
        functionSelector[16]: 0xb6618dff
        functionSelector[17]: 0xff126de9
        functionSelector[18]: 0x80b297e8
        functionSelector[19]: 0x74c6b89b

        facetAddress[8]: 0x6369f971fd1f1f230b8584151ed7747ff710cc68 => SwapAdminFacet
        functionSelectors.length: 11
        functionSelector[0]: 0xea027c2f
        functionSelector[1]: 0xe5f6220f
        functionSelector[2]: 0x4b141bb4
        functionSelector[3]: 0x2bf63bcc
        functionSelector[4]: 0x1963e426
        functionSelector[5]: 0x3e74aea0
        functionSelector[6]: 0x9c8eab97
        functionSelector[7]: 0x43be5eaf
        functionSelector[8]: 0x72a30e08
        functionSelector[9]: 0x8dc51484
        functionSelector[10]: 0xa1a23c29

        facetAddress[9]: 0x324c5834cd3bd19c4991f4fc5b3a0ff5257a692b => DiamondCutFacet
        functionSelectors.length: 4
        functionSelector[0]: 0x1f931c1c
        functionSelector[1]: 0x56a8ea48
        functionSelector[2]: 0xbbf2358e
        functionSelector[3]: 0x2c67849c

        facetAddress[10]: 0x44e799f47a5599f5c9158d1f2457e30a6d77adb4 => DiamondInit
        functionSelectors.length: 1
        functionSelector[0]: 0x9a7e155e

        facetAddress[11]: 0x3bcf4185443a339517ad4e580067f178d1b68e1d => DiamondLoupeFacet
        functionSelectors.length: 5
        functionSelector[0]: 0xcdffacc6
        functionSelector[1]: 0x52ef6b2c
        functionSelector[2]: 0xadfca15e
        functionSelector[3]: 0x7a0ed627
        functionSelector[4]: 0x01ffc9a7
         */
        string memory address_name;
        string memory fs_name;
        for (uint256 i = 0; i < facetCount; i++) {
            address facetAddress = facetAddresses[i];
            bytes4[] memory functionSelectors = ConnextDiamond_Proxy
                .facetFunctionSelectors(facetAddress);

            facets[i] = IDiamondLoupe.Facet({
                facetAddress: facetAddress,
                functionSelectors: functionSelectors
            });

            address_name = StringHelper.concatenateStringsWithIndex(
                "facetAddress",
                cheats.toString(i)
            );
            emit log_named_address(address_name, facetAddress);

            emit log_named_uint(
                "functionSelectors.length",
                functionSelectors.length
            );

            for (uint256 j = 0; j < functionSelectors.length; j++) {
                fs_name = StringHelper.concatenateStringsWithIndex(
                    "functionSelector",
                    cheats.toString(j)
                );
                bytes memory functionSelector = abi.encodePacked(
                    functionSelectors[j]
                );
                emit log_named_bytes(fs_name, functionSelector);
            }
        }
    }

    // ----------------------------------------------------------------------------
    // Decode slot data
    // ----------------------------------------------------------------------------
    function test__decode_slot_data() public {
        /* TokenFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(TokenFacet), 0, 100, true);

        /* BridgeFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(BridgeFacet), 0, 100, true);

        /* InboxFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(InboxFacet), 0, 100, true);

        /* ProposedOwnableFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(ProposedOwnableFacet), 0, 100, true);

        /* PortalFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(PortalFacet), 0, 100, true);

        /* RelayerFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(RelayerFacet), 0, 100, true);

        /* RoutersFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(RoutersFacet), 0, 100, true);

        /* StableSwapFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(StableSwapFacet), 0, 100, true);

        /* SwapAdminFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(SwapAdminFacet), 0, 100, true);

        /* DiamondCutFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(DiamondCutFacet), 0, 100, true);

        /* DiamondInit
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(DiamondInit), 0, 100, true);

        /* DiamondLoupeFacet
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(address(DiamondLoupeFacet), 0, 100, true);

        /* ConnextDiamond_Impl
         */
        // dumpContinuousSlotData(address(ConnextDiamond_Impl), 0, 100, true);
        // dumpContinuousSlotData(address(ConnextDiamond_Impl), 100, 100, true);
        // dumpContinuousSlotData(address(ConnextDiamond_Impl), 200, 100, true);
        // dumpContinuousSlotData(address(ConnextDiamond_Impl), 300, 100, true);
        // dumpContinuousSlotData(address(ConnextDiamond_Impl), 400, 100, true);
        // dumpContinuousSlotData(address(ConnextDiamond_Impl), 500, 100, true);

        /* ConnextDiamond_Proxy
        slot_data[2]: 0x4d50a469fc788a3c0CdC8Fd67868877dCb246625 => GnosisSafeProxy
        slot_data[26]: 0xf7DE5aCeEeE6091d1103209C337fA00D0B4b9092 => LPToken (NxtpStableLPToken)
        slot_data[32]: 0xF7c4d7dcEc2c09A15f2Db5831d6d25eAEf0a296c => MainnetSpokeConnector
        */
        dumpContinuousSlotData(address(ConnextDiamond_Proxy), 0, 10, false);
        // dumpContinuousSlotData(address(ConnextDiamond_Proxy), 0, 100, true);
        // dumpContinuousSlotData(address(ConnextDiamond_Proxy), 100, 100, true);
        // dumpContinuousSlotData(address(ConnextDiamond_Proxy), 200, 100, true);

        // GnosisSafeProxy
        /*
        slot_data[0]: 0xd9Db270c1B5E3Bd161E8c8503c55cEABeE709552 => GnosisSafe
        */
        // dumpContinuousSlotData(
        //     address(0x4d50a469fc788a3c0CdC8Fd67868877dCb246625),
        //     0,
        //     100,
        //     true
        // );

        // GnosisSafe
        /*
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(
        //     address(0xd9Db270c1B5E3Bd161E8c8503c55cEABeE709552),
        //     0,
        //     100,
        //     true
        // );

        // LPToken
        /*
        slot_data[0]: 0x
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        */
        // dumpContinuousSlotData(
        //     address(0xf7DE5aCeEeE6091d1103209C337fA00D0B4b9092),
        //     0,
        //     100,
        //     true
        // );

        // MainnetSpokeConnector
        /*
        slot_data[0]: 0x4d50a469fc788a3c0CdC8Fd67868877dCb246625 => GnosisSafeProxy
        slot_data[4]: 0x6a595E41893a5ACBA9dBf8288B92eb71106Ba7A6 => WatcherManager
        */
        // dumpContinuousSlotData(
        //     address(0xF7c4d7dcEc2c09A15f2Db5831d6d25eAEf0a296c),
        //     0,
        //     100,
        //     true
        // );

        // WatcherManager
        /*
        slot_data[0]: 0x4d50a469fc788a3c0CdC8Fd67868877dCb246625 => GnosisSafeProxy
        */
        // dumpContinuousSlotData(
        //     address(0x6a595E41893a5ACBA9dBf8288B92eb71106Ba7A6),
        //     0,
        //     100,
        //     true
        // );
    }
}
