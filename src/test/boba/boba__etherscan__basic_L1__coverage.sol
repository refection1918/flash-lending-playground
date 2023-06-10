// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./boba__etherscan__common.sol";

contract boba_etherscan_Basic_L1_Test is BobaEtherscanCommon {
    using SafeMath for uint256;

    function setUp() public override {
        super.setUp();

        cheats.createSelectFork("ethereum", 17405912);
        // cheats.createSelectFork("ethereum", 16989340);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    // ----------------------------------------------------------------------------
    // Signature Replay
    // ----------------------------------------------------------------------------
    // https://explorer.phalcon.xyz/tx/eth/0x5724ed880a23d6c2b359abf47ce58b07b4cb4d0becd1dfb2cf49dccfa1b3cd19
    function skip_test__batchRelayMessages() public {
        cheats.expectRevert("Invalid large internal hash");

        // Impersonate as L2BatchMessageRelayer
        cheats.prank(address(L2__BatchMessageRelayer));

        L1MultiMessageRelayer.L2ToL1Message[] memory messages = new L1MultiMessageRelayer.L2ToL1Message[](1);
        messages[0].target = address(proxy__L1__StandardBridge);
        messages[0].sender = address(0);
        messages[0].message = hex"a9f9e675000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000066a2a913e447d6b4bf33efbec43aaef87890fbbc0000000000000000000000001bd0a503ef149b188bfa31205028db04011861070000000000000000000000009c42c4921b9320b76be0a4772061d88ed13373c00000000000000000000000000000000000000000000000000000000bd7e0fc6300000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000203136383031373336333230323200000000000000000000000000000000000000";
        messages[0].messageNonce = 115892;

        Lib_OVMCodec.ChainBatchHeader memory stateRootBatchHeader;
        Lib_OVMCodec.ChainInclusionProof memory stateRootProof;
        
        stateRootBatchHeader.batchIndex = 14647;
        stateRootBatchHeader.batchRoot = hex"cf2df7e7df6c683bd523a2a32005a3e499bef8db9b4bc7bbf5d35cc10bc49b92";
        stateRootBatchHeader.batchSize = 40;
        stateRootBatchHeader.prevTotalElements = 993546;
        stateRootBatchHeader.extraData = hex"00000000000000000000000000000000000000000000000000000000642575270000000000000000000000005558c63d5bf229450995adc160c023c9f4d4be80";

        stateRootProof.index = 16;

        bytes32[] memory siblings = new bytes32[](6);
        siblings[0] = hex"d3bc70b03121cceeb24efec96880d3f1978a2a7e5ffe6845639567da276358ca";
        siblings[1] = hex"44065db30a9ffe00462d4e5e7dd55ffdd08ff934f48d38ee88329d4f9da96819";
        siblings[2] = hex"b75f1aeae5bffeeda50604573a6dd184ac99fe1a8dbea2b16721a17904405617";
        siblings[3] = hex"30db367e518033cc05a74b4afec71f8d9f103bf270c594851b4c7c4683518ee3";
        siblings[4] = hex"8b33ef389d0592dc257fc59e53d4d510b98fa7c2be06063578d027657bd2ceb7";
        siblings[5] = hex"d78effff421c49b006d4d4f8a5a37f5d25e14cde1cf3d8b33aca29205b3b3294";
        stateRootProof.siblings = siblings;

        IL1CrossDomainMessenger.L2MessageInclusionProof memory proof;
        proof.stateRoot = hex"f04585bfdea21b17d823a4095533f9ef89a5d75f33b7414a20edac8d9544384b";
        proof.stateRootBatchHeader = stateRootBatchHeader;
        proof.stateRootProof = stateRootProof;
        proof.stateTrieWitness = hex"f90786b90214f90211a00b55585ae88f683dca53d158524e62add1c056dcf28dd3dc7caf7b0190528e52a06c33a95ed3122a3a576e648f47194100d0463c3e75a0bf1dbf497da54c08fd98a0082ba6275da5008c38d85712697c52e9f7d419bb77dc2589e67ce96acbf37b1ea03e9d554c07f8fcc6f4f06d34e9aabe68d9320c576496bd5210f178550a0a930da0a3a9481db7f21de3c11f8526d80bce255515460dc67dbf2b4b46202364f80722a08265d8c033b16aaf3fcd3413c6f5cd0a8df6e8be377a8b7fcbe33df7463afdd7a0d3370a16ee6f9c8e93f5f0eb45e0a1745026b0df4a6f07bd70cda36d5345cdf3a090c436633676005ee17a3ca9388683b5998caef4cdca2025a9a91683efa6995da0b67387761ccc984cb117f25cae8b9ff6e2fbdbeb47234354713989a29cf7fbb4a0a4261b952f58f18ec4276609ee7b3ab1ef8f5c28cf1941d1bbc59cce7d31d1d2a0269977e23f51463a1580f134deeac38e7ab018bc5ae466bca803dbf708d4023da084c7fd5b8d275fe2dca2fd1c91ef13c8707fa10a55a65cb66592c1a98d7ac1c7a07f40606eb9039059a9fd8cd44a1cb0bef20c980d88d16a451c817f47243722a1a024cae711e7befc9b2677b6043bf0cc3e20c26576a46f07cdec803c27b0a69d20a078229b85e5c00d15f3e5675ecaad7cba5fd3b13cd06a77db0d1d00d490cb973fa03a84ce917c5680be962c0bafbf71ec2619a6d1d16558f8c425d6e571be2f008380b90214f90211a0e221a2b5e8a119869c53306a7a1d4bc704ea1152118280ec09caa2fd2f4bfc4aa04de1db55a79d67ea0f87702540ac89a5975799f0dd459f9fd2e12ae2d396d589a095df5c578d60cecd10f5409281a1e94452d6d29974c0268194f226e55b3d37d4a095b4240c01e6fc1cd0f5b7c370fefe5256e863fd522d086919cd61482d1838a3a099de4ddaf374a55680e503ca9bd0d80c2c62445823cdad4fd1b564ed483e8277a010be0a757dd75e4c4980ab181ac5989a89c26bd09a2be733d5a2fe97622c4951a0dbea874e6f276232f89f0d436fae02089bd8ff3870372308457a735199ed2296a0fca805d6e55339ff84d5623019d64aeea8f2ead02bfd5a25a878791ed95e2739a0e909cd97f09ac092a86a3f8975fbf6e0a33f91fb9cae47dbe5b046c5922f5230a01b04b6ac906fec6eb852a72014cc3f3dd80f0cc001acd543ba43e1f6c4403d83a08c155453a9647934b06a2c573d1e3f933ade579fad604c6e9523f9af421b4ccba0f8b91d97a3f7b9f2b70c5a6773284ad48945344a015b6c15f627789a89462bcfa00464f6235030fbc49b7d09954b446d2c44b36e8c407dbf79d47f6a0fb9a63a97a007ce07afd769cee55fb17b35bde2ea642a89e1c17440ee57e755ba6f7a47d37ca0b3939618ca522104887f3eae9be32a8452eed57038ebfa22461e2b6b140b9e20a0dc7816d0a65e216ebc0e2b3aa62bac5f418de711cfd516c4e2d65f9afc507c2d80b90214f90211a092972975038b08345b86b0af6d0be4f893a625a7dd4369529b2f1f483d1737e8a0f1c50aaab5e6b785431bb92b098b8ef4e2d372f6312e778e1a256d2cfb574cc7a07cff579acdf8b3b53ca82b0bbac280afcc1ce2ad2c676dbd0510366e16a0a69ca0988d630d98339286409a64209c5318a4820b48d01a669bbcb1184f81157d4a16a075550328143643af0e36bc74874cb06444818e21a490fe85598a01c812cc1ee7a0b88cfe418705d697b994f09c197755aa09b26f442f3ee5bd23606b59233507a7a0f68bdf0bcce55db23349ba41d9e6dbbaca6ecf38f4904b579ae53a4199f07a63a057d56844861b6e501cb7ce8af6461fc4761a8af78bbcbc16bed3f38d28712e15a034fa9701b30a3a02bccac79c5d2d75084365de8e0d5ebabc55972c678c1d8553a090c47fa5427378ea6ca8678e39ae746dfb48e6ce9ff1ed72b86025d4ccc69bc0a06939920aca8cc83a805f7374db5661b69442f660ebec0d3175e9051b81af8aafa0896935bfc224e3998bd8ecd465a70e78375c9afbc3dc0eb78ee912698a2ac57da0108a836c3ff0dbb679eb1e2ac83fd6b194db1ba2b91d45e14f409fc4c74d58d3a0d03f12be021ebf7d16952e15ed9deb45cd78a6e895510bf56262c20149195177a0b9a2e785244b72e9da21dd49ddad701a28ed4d519d8f4088f69f41398d54d5e9a0bd918ad17c0c0fb40769644eabaf5e90956ce6e8c9b79b8b2ce236549275b66e80b8d3f8d180a0a7b9161eff9d39ca38965143c077ec722fba49c197015c985b8fcf36c10d8da48080a0d20ba1d34ea4dda65447a9e685d0a0a1965f8d1fd126800e2e43a89a764f303c80a0cf9233edd21c871bd20fd4134e081fd2853dc31e1fd7ed56e391e95f8a54669580808080a02818db806a9f42ead84deca779d619dd3a68d0224259f58057999b57410f229580a0b184775618631d04c25e10e944eb7b073ada97fdb251a8440b75e870c5528643a0d08fa3a18a382ca06ea3a9a3fd0e251366a2352da1bf36bb72990c05bdf8e3298080b86af8689f20311b46a2440f3eaf346b6c1ce588ed08712591822a258c5a1c4cf44cd0c9b846f8448080a0c8288cf51a5140c62492bfd968863f2ec2a1129b697f3131317722ea72b2ba0ba0a8336a38da5f9408d017f8e46bff2c7c66e3d09120641e4186f58e73e2308f61";
        proof.storageTrieWitness = hex"f906ddb90214f90211a07cb68329afeb20238053e74585742b6d8103dcad514343e2a339a323293e7676a04d5a2b17ef69dcfac90ead198e3decf53d17d17d330dd0564dc723d5fcfafbc5a0e3cf8a803c6311cdca7ee87a688ec686f04fbaa0ca6306c514985a0e0bd0d3f9a0ced28bf2ed8be699d1b9bfed7482b1b0c9fbe790eeeb0f6b7da5e335f88bad95a082702e1a4da32494e5767cf90349616d130075bda6b9293e5476dc2319b57b99a0b7d5b7eb277f4a0d9ac537723862630b0366f219599e082233ce3d9177ae3b5ca0aced81dcc1726ee845eaa5f29ce9e51dd51c69811158997f305a30731d76fcbfa095177b1062057270aee08c6c8c533656c7392674749619e545e9a153906472cba0b116dcb9147d6f1efb829ddd5b476ffda6938fc0d60b3099df5cf0d26eb90bb3a02f381873ce88790c9c0039f6806f6cd93393d4f148dcab2b222d805b4b051448a06c08085de5e3c765005bf0f85de77fa05cec67007915e3adb2c0fd7f494be841a02d781ed48757b67660bb9e6fd365f92f3425c57cc616eab0f108553ad057b966a05f151cc0c6fe372d73af95bc2b748120ca73887eb9353996b2619a9cfff51cf8a092a68fed8f1dde1fcf297cb8845a1e6ce1d3b606afae51010b42b18ebf3ff196a01adcb4d10732ce712f7e48cf2f46ce4ff30f56b51f2a8a3fcfd805e8be326f03a0a073cd8d1698325f7c6ff0732e0c55be93044f7d6ce066cc17711d8fb01ad62b80b90214f90211a03bcecf4dc346f7636469b8836e1a467af2864abdc9ea177eb40c0d854fc573faa05681b3ad1019d91f3085ef30560988663a9f5879e86a8d4a33d9c8b0e3e4a58aa09ec73bc1738118aff34c80bb0bf69b543f4ebf87ff2f6add020b3ac7436375cca0121c96abc908cae8c4f75b347b594bb9f4c3f5ba716370d679db66c76601323ca06732389f0f44bb1b5d1e8cd1627ea0a9b4a39d507b216b09b6e1c43e7b06c746a03f9ca49b126fec58660ee60fd5a0327cf33526d38aed6bb8b07388531349b6c0a005e0cc151e5c063adc230dc2f3b421ace5691e6376662f6ae4e7765079149e33a03a72af48bfd2f53a17c195c10414906b49c9315426e2b970feb1e3ac4f56afa1a04c33c55373269587da0b325864be1cb8e0611677e0b13e25e162d7a1894ab0f9a0417798082364258d14cac2901ff16c8db352ff4fcbe1bade3ecb35a6ee7f745da0a6165b00b8188174ce2b1e5edb86b2bd09cdb3cadae220f27030a7c11b6fae2da0490376e49204be23e9696e9ebdd9e5c747e51539c90c8e088899fc0d967c5848a0b2bb74d07981ebb6d357f7a1006bb861695c29d54fcbcd6b6f99c54e3a448d18a0bfdc136f86f559cfcc2e3d253139616c4209ec0369b5057767a55d9d33c917fba025893c63f3848364c28b804026dde7068b74f5e8b3cf72bcab25ffd30012df61a05c7889a4a5410fdb94e9022ef8a8ab9663f18bafc40235f9a958ec0fa541be5480b901f4f901f180a02d7899d54e22249b753696928db064c7fb52744e6bffee2357ea71ac7531343fa00049f7f3a3d7621b9401e74a07a5929d6b9982afc48d43544966300b18bbebeea0776ad0ec2ed602a5c0a51836e019b64c0ace1854f145906229b279f9222639cea0dce9ae99e2abe4e2043ae771d4eadfe6f0fdb8c3d19dc82c5a52ac121887b50da0412d2205cb5627e361a89db31f5605a1a184ecf21bd499e29dad6e01fbc77c33a08f0b39f6494a783a12d0d709827f92359952df53652ea20056400ab089b85efaa00a744cf96cf0423cf3e2274e69db6afadaedcbd18980276b97620f5e3b41f118a0965f9e4fbc763f738788482be4ee77992f96c95fa072a204440336cc0c7ba602a07f82963c1995d70a30c3bbabfb01afa1408c1aca10dbc430480b737b0f0f7ea8a00a3ec4bd52bc20366ab084eb98adb7c9ec4bce6b777d34badb965b8bca7ca8eea032f4ace79585fdfb57909032f01a484826cff1538dc03e0000339c70e206e78aa01e9c8daf5ef4a2354539342809e03a930e777434642f274a440edbe5ed6cd312a0dae5ba32529a36c6ab7ccc02f58ae89d6ca38f81dba61479bed58da356f353d2a0da8c434627a2bfeaa5c322b15c82a9443ff216b49e94cf2278ddd5f3a420a7aca09976c7cbfc8e9170a6538bde7731fe57822327be53d0f2b5049ce4a6f2d0504180b893f891a084b453a6e69e653c9ed2496bb2cb481cb158082bc6b3418601c57e67d1f77230808080a0a68d42d6c5e50f3ed1a28eecc7d38744b4ea99efde416d3f970e8204920161d780808080a02db2bedcf1483b29705481b7044b691d8b08953b5830b3c01b509c0c704e93cda066b43fc100ba61e4f585dc308bb9a95c3ee4a23f77c0452942f09be97c68d5da808080808080a2e19f20a7759ccfa8de9c629a71c76f83583e0ba2a2e0b6994723e865f4ec90ca4401";

        // proof tuple = (bytes32,
        //                (uint256,bytes32,uint256,uint256,bytes),
        //                (uint256,bytes32[]),
        //                bytes,
        //                bytes)
        //                )
        messages[0].proof = proof;

        L1__MultiMessageRelayer.batchRelayMessages(messages);
    }

    // ----------------------------------------------------------------------------
    // Withdrawal
    // ----------------------------------------------------------------------------
    function test__finalizeERC20Withdrawal() public {
        cheats.expectRevert("xDomainMessageSender is not set");

        // Impersonate as Proxy_OVM_L1CrossDomainMessenger
        cheats.prank(address(Proxy_OVM_L1CrossDomainMessenger));

        address l1Token = address(USDC);
        address l2Token = address(0x66a2A913e447d6b4BF33EFbec43aAeF87890FBbc);
        address from = address(proxy__L1__StandardBridge);
        address to = address(this);
        uint256 amount = 1;
        bytes memory data = new bytes(1);

        proxy__L1__StandardBridge.finalizeERC20Withdrawal(l1Token, l2Token, from, to, amount, data);
    }

    function skip_test__finalizeETHWithdrawal() public {
        cheats.expectRevert("xDomainMessageSender is not set");

        // Impersonate as Proxy_OVM_L1CrossDomainMessenger
        cheats.prank(address(Proxy_OVM_L1CrossDomainMessenger));

        address from = address(proxy__L1__StandardBridge);
        address to = address(this);
        uint256 amount = 1;
        bytes memory data = new bytes(1);

        /**
        * @dev Complete a withdrawal from L2 to L1, and credit funds to the recipient's balance of the
        * L1 ETH token. Since only the xDomainMessenger can call this function, it will never be called
        * before the withdrawal is finalized.
        * @param _from L2 address initiating the transfer.
        * @param _to L1 address to credit the withdrawal to.
        * @param _amount Amount of the ERC20 to deposit.
        * @param _data Optional data to forward to L2. This data is provided
        *        solely as a convenience for external contracts. Aside from enforcing a maximum
        *        length, these contracts provide no guarantees about its content.
        */
        proxy__L1__StandardBridge.finalizeETHWithdrawal(from, to, amount, data);
    }
}