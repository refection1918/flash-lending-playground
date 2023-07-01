// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./boba__etherscan__common.sol";

contract Proxy_Contract {
    function doSomething() public {
        require(msg.sender == address(0), "Only callable by address(0)");

        // Code to be executed if the requirement is fulfilled
    }
}

contract Caller {
    Proxy_Contract public contractInstance;

    constructor(address _contractAddress) {
        contractInstance = Proxy_Contract(_contractAddress);
    }

    function callDoSomething() public {
        contractInstance.doSomething();
    }
}

contract boba_etherscan_proxy_Test is BobaEtherscanCommon {
    using SafeMath for uint256;

    function setUp() public {
        super.setUp2();

        cheats.createSelectFork("ethereum", 17405912);
        // cheats.createSelectFork("ethereum", 16989340);

        // Pre-load tokens
        // writeTokenBalance(address(this), fl_token, payback_fee_amount);
    }

    function skip_test__address_zero() public {
        // Deploy Proxy_Contract
        Proxy_Contract proxy = new Proxy_Contract();
        Caller caller = new Caller(address(proxy));
        proxy.doSomething();
    }

    // ----------------------------------------------------------------------------
    // Governance
    // ----------------------------------------------------------------------------
    function skip_test__governance() public {
        /* Proxy__OVM_L1StandardBridge
        slot_data[0]: 0x0000000000000000000000006d4528d192db72e282265d6092f4b872f9dff69e => Proxy__L1CrossDomainMessenger
        slot_data[1]: 0x0000000000000000000000004200000000000000000000000000000000000010 => L2StandardBridge
        slot_data[2]: 0x
        slot_data[3]: 0x6d8d9f116b316c7b185a60eb5dcba174549340a5429b2ac30f539e63adec96dc
        slot_data[4]: 0xd610d5822dccee3df29b3f2806354fccd6819467be36ee1d393a3d1abb6b28b6
        slot_data[5]: 0x0000000000000000000000000000000000000000000000000000000001098ea7
        slot_data[6]: 0x
        slot_data[7]: 0x
        slot_data[8]: 0x
        slot_data[9]: 0x
        */
        // dumpContinuousSlotData(address(0xdc1664458d2f0B6090bEa60A8793A4E66c2F1c00), 0, 10);

        /* Proxy__L1CrossDomainMessenger
        slot_data[0]: 0x0000000000000000000000018376ac6c3f73a25dd994e0b0669ca7ee0c02f089 => Lib_AddressManager
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        slot_data[6]: 0x
        slot_data[7]: 0x
        slot_data[8]: 0x
        slot_data[9]: 0x
        */
        // dumpContinuousSlotData(address(0x6D4528d192dB72E282265D6092F4B872f9Dff69e), 0, 10);

        /* Lib_AddressManager
        slot_data[0]: 0x0000000000000000000000001f2414d0af8741bc822dbc2f88069c2b2907a840 => Owner = Proxy_Admin
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        slot_data[6]: 0x
        slot_data[7]: 0x
        slot_data[8]: 0x
        slot_data[9]: 0x
        */
        // dumpContinuousSlotData(address(0x8376ac6C3f73a25Dd994E0b0669ca7ee0C02F089), 0, 10);

        /* Proxy__L1LiquidityPool
        slot_data[0]: 0x0000000000000000000000006d4528d192db72e282265d6092f4b872f9dff69e => Proxy__OVM_L1CrossDomainMessenger
        slot_data[1]: 0x000000000000000000000001d05b8fd53614e1569cac01c6d8d41416d0a7257e => Proxy__L1CrossDomainMessengerFast
        slot_data[2]: 0x0000000000000000000000000000000000000000000000000000000000000001
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        slot_data[6]: 0x
        slot_data[7]: 0x
        slot_data[8]: 0x
        slot_data[9]: 0x
        */
        // dumpContinuousSlotData(address(0x1A26ef6575B7BBB864d984D9255C069F6c361a14), 0, 10);

        /* Proxy__L1CrossDomainMessengerFast
        slot_data[0]: 0x0000000000000000000000018376ac6c3f73a25dd994e0b0669ca7ee0c02f089 => Lib_AddressManager
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        slot_data[6]: 0x
        slot_data[7]: 0x
        slot_data[8]: 0x
        slot_data[9]: 0x        
        */
        // dumpContinuousSlotData(address(0xD05b8fD53614e1569cAC01c6D8d41416d0a7257E), 0, 10);

        /* Proxy__OVM_L1CrossDomainMessenger
        slot_data[0]: 0x0000000000000000000000018376ac6c3f73a25dd994e0b0669ca7ee0c02f089 => Lib_AddressManager
        slot_data[1]: 0x
        slot_data[2]: 0x
        slot_data[3]: 0x
        slot_data[4]: 0x
        slot_data[5]: 0x
        slot_data[6]: 0x
        slot_data[7]: 0x
        slot_data[8]: 0x
        slot_data[9]: 0x        
        */
        // dumpContinuousSlotData(address(0x6D4528d192dB72E282265D6092F4B872f9Dff69e), 0, 10);

        /* Proxy__L1StandardBridge (Rich account)
        slot_data[0]: 0x0000000000000000000000006d4528d192db72e282265d6092f4b872f9dff69e => Proxy__OVM_L1CrossDomainMessenger
        slot_data[1]: 0x0000000000000000000000004200000000000000000000000000000000000010 => L2StandardBridge
        slot_data[2]: 0x
        slot_data[3]: 0x6d8d9f116b316c7b185a60eb5dcba174549340a5429b2ac30f539e63adec96dc
        slot_data[4]: 0xd610d5822dccee3df29b3f2806354fccd6819467be36ee1d393a3d1abb6b28b6
        slot_data[5]: 0x0000000000000000000000000000000000000000000000000000000001098ea7
        slot_data[6]: 0x
        slot_data[7]: 0x
        slot_data[8]: 0x
        slot_data[9]: 0x        
        */
        // dumpContinuousSlotData(address(0xdc1664458d2f0B6090bEa60A8793A4E66c2F1c00), 0, 10);

        // proxy__L1__StandardBridge.getOwner({value: address(0)});

        // Prepare the data for the eth_call
        // bytes memory data = abi.encodeWithSelector(proxy__L1__StandardBridge.getOwner.selector);

        // Make the eth_call with "from" address set to address(0)
        // (bool success, bytes memory result) = address(proxy__L1__StandardBridge).call{from: address(0)}(data);

        // (bool success, bytes memory result) = address(proxy__L1__StandardBridge).delegatecall(
        //     // abi.encodeWithSignature("getOwner()", address(0))
        //     abi.encodeWithSelector(proxy__L1__StandardBridge.getOwner.selector)
        // );

        // According to https://etherscan.io/address/0xdc1664458d2f0B6090bEa60A8793A4E66c2F1c00?utm_source=immunefi#code
        /*
         * Makes a proxy call instead of triggering the given function when the caller is either the
         * owner or the zero address. Caller can only ever be the zero address if this function is
         * being called off-chain via eth_call, which is totally fine and can be convenient for
         * client-side tooling. Avoids situations where the proxy and implementation share a sighash
         * and the proxy function ends up being called instead of the implementation one.
         *
         * Note: msg.sender == address(0) can ONLY be triggered off-chain via eth_call. If there's a
         * way for someone to send a transaction with msg.sender == address(0) in any real context then
         * we have much bigger problems. Primary reason to include this additional allowed sender is
         * because the owner address can be changed dynamically and we do not want clients to have to
         * keep track of the current owner in order to make an eth_call that doesn't trigger the
         * proxied contract.
         */
        bytes memory data = abi.encodeWithSignature("getOwner()");
        // (bool success, bytes memory result) = address(proxy__L1__StandardBridge).call{value: 0, gas: gasleft()}(data);
        (bool success, bytes memory result) = a.delegatecall(data);
        require(success, "eth_call failed");

        // Decode the result
        address owner = abi.decode(result, (address));

        emit log_named_address("owner", owner);
    }
}
