// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./celer_etherscan__common.sol";
import "openzeppelin-contracts/utils/cryptography/ECDSA.sol";

contract cBridgeLPTest is CelerCommon {
    using SafeMath for uint256;
    using ECDSA for bytes32;

    // Configure target flashloan here
    address fl_token = address(USDC);
    uint256 constant req_flashloan_amount = 104_000 * 1e6;
    uint256 constant payback_fee_amount = (req_flashloan_amount * 1008) / 1000; // 0.8% fee

    function setUp() public {
        super.setUp2();

        cheats.createSelectFork("ethereum", 17321482);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    function test__balance_of__LP() public {
        emit log_named_decimal_uint(
            "cBridge ETH balance",
            address(cbridge).balance,
            18
        );

        emit log_named_decimal_uint(
            "cBridge USDT balance",
            USDT.balanceOf(address(cbridge)),
            USDT.decimals()
        );

        emit log_named_decimal_uint(
            "cBridge USDC balance",
            USDC.balanceOf(address(cbridge)),
            USDC.decimals()
        );

        emit log_named_decimal_uint(
            "cBridge MASK balance",
            MASK.balanceOf(address(cbridge)),
            MASK.decimals()
        );

        emit log_named_decimal_uint(
            "cBridge WETH balance",
            WETH.balanceOf(address(cbridge)),
            WETH.decimals()
        );

        // Balance check on Tokens
        assertTrue(address(cbridge).balance > 0);
        assertTrue(IERC20(USDT).balanceOf(address(cbridge)) > 0);
        assertTrue(IERC20(USDC).balanceOf(address(cbridge)) > 0);
        assertTrue(IERC20(MASK).balanceOf(address(cbridge)) > 0);
        assertTrue(IERC20(WETH).balanceOf(address(cbridge)) > 0);
    }

    // ----------------------------------------------------------------------------
    // Exploit Withdrawal
    // https://etherscan.io/tx/0x15e14e912b20bfea5020ed70e1909f682abe3841b56dd34c24417c0916a28b2f
    // ----------------------------------------------------------------------------
    function testFail__exploit_withdrawal() public {
        // bytes memory goldenEncodedWithdrawMsg = hex"0801108db7b2a3061a14089a2c44131b1eb30cc4fc226560163fcef2c2882214a0b86991c6218b36c1d19d4a2e9eb0ce3606eb482a058cc91c9930";
        // WithdrawMsg memory m = decWithdrawMsg(goldenEncodedWithdrawMsg);
        // bytes memory exploitedEncodedWithdrawMsg = encWithdrawMsg(m);

        WithdrawMsg memory m;
        m.chainid = 1;
        m.seqnum = 1684839309;
        m.receiver = 0x089A2C44131b1Eb30CC4fc226560163FcEF2C288;
        // m.receiver = address(this);
        m.token = address(USDC);
        m.amount = 604669516080;
        m.refid = 0;

        // Initialize w.r.t. the golden values
        bytes memory exploitedEncodedWithdrawMsg = encWithdrawMsg(m);

        bytes[] memory sigs = get_sigs();
        address[] memory signers = get_signers();
        uint256[] memory powers = get_powers();

        cbridge.withdraw(exploitedEncodedWithdrawMsg, sigs, signers, powers);

        // Convert memory to calldata using `this` pointer
        bytes32 domain = keccak256(abi.encodePacked(block.chainid, address(cbridge), "WithdrawMsg"));
        // this.verifySigs(abi.encodePacked(domain, goldenEncodedWithdrawMsg), sigs, signers, powers);
        // this.verifySigs(abi.encodePacked(domain, exploitedEncodedWithdrawMsg), sigs, signers, powers);
    }

    function verifySigs(
        bytes memory _msg,
        bytes[] calldata _sigs,
        address[] calldata _signers,
        uint256[] calldata _powers
    ) public {
        bytes32 ssHash = hex"92bfc4ee4a8df9864de9b196ddbfe4cf3f257a42355c63394c12caf984ef5b9f";

        // emit log_named_bytes32(
        //     "ssHash",
        //     ssHash
        // );

        bytes32 h = keccak256(abi.encodePacked(_signers, _powers));

        // emit log_named_bytes32(
        //     "h",
        //     h
        // );

        require(ssHash == h, "Mismatch current signers");

        _verifySignedPowers(keccak256(_msg).toEthSignedMessageHash(), _sigs, _signers, _powers);
    }

    // separate from verifySigs func to avoid "stack too deep" issue
    function _verifySignedPowers(
        bytes32 _hash,
        bytes[] calldata _sigs,
        address[] calldata _signers,
        uint256[] calldata _powers
    ) private {
        require(_signers.length == _powers.length, "signers and powers length not match");

        // emit log_named_uint(
        //     "_signers.length",
        //     _signers.length
        // );

        // emit log_named_uint(
        //     "_powers.length",
        //     _powers.length
        // );

        emit log_named_bytes32(
            "_hash",
            _hash
        );

        uint256 totalPower; // sum of all signer.power
        for (uint256 i = 0; i < _signers.length; i++) {
            totalPower += _powers[i];
        }
        uint256 quorum = (totalPower * 2) / 3 + 1;

        // emit log_named_uint(
        //     "quorum",
        //     quorum
        // );

        uint256 signedPower; // sum of signer powers who are in sigs
        address prev = address(0);
        uint256 index = 0;
        for (uint256 i = 0; i < _sigs.length; i++) {
            emit log_named_uint(
                "i",
                i
            );

            emit log_named_bytes(
                "_sigs[i]",
                _sigs[i]
            );

            address signer = _hash.recover(_sigs[i]);

            emit log_named_address(
                "signer",
                signer
            );

            require(signer > prev, "signers not in ascending order");
            prev = signer;
            // now find match signer add its power
            while (signer > _signers[index]) {
                index += 1;
                require(index < _signers.length, "signer not found");
            }
            if (signer == _signers[index]) {
                signedPower += _powers[index];
            }
            if (signedPower >= quorum) {
                // return early to save gas
                return;
            }
        }
        revert("quorum not reached");
    }
}