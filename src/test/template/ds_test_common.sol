// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/StdStorage.sol";
import "openzeppelin-contracts/utils/math/SafeMath.sol";

import "interface/cheat_codes.sol";
import "interface/etherscan_blockchain.sol";
import "helper/helper_library.sol";

contract DSCommon is DSTest {
    // Foundry
    CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    // https://docs.connext.network/resources/supported-chains
    // Mainnet Domains
    uint32 Ethereum_Mainnet_Domain_ID = 6648936;
    uint32 Optimism_Domain_ID = 1869640809;
    uint32 Polygon_Domain_ID = 1886350457;
    uint32 Arbitrum_Domain_ID = 1634886255;
    uint32 Gnosis_Domain_ID = 6778479;
    uint32 BNB_Domain_ID = 6450786;

    // https://mirror.xyz/brocke.eth/PnX7oAcU4LJCxcoICiaDhq_MUUu9euaM8Y5r465Rd2U
    using stdStorage for StdStorage;
    StdStorage stdstore;

    function writeTokenBalance(
        address owner,
        address token,
        uint256 amount
    ) internal {
        stdstore
            .target(token)
            .sig(IERC20(token).balanceOf.selector)
            .with_key(owner)
            .checked_write(amount);
    }

    function dumpBytes(
        string memory content_name,
        bytes32 content,
        bool skip_zero_extcode
    ) internal {
        if (content != 0) {
            // Convert bytes32 to address
            address addr = address(uint160(uint256(content)));

            // Determine if the slot content is a smart contract
            if (ContractHelper.isContract(addr)) {
                string memory contract_with_extcode = StringHelper
                    .concatenateStringWithoutContractName(
                        cheats.toString(addr)
                    );

                emit log_named_string(content_name, contract_with_extcode);
            } else {
                if (skip_zero_extcode == false) {
                    emit log_named_bytes32(content_name, content);
                }
            }
        } else {
            if (skip_zero_extcode == false) {
                emit log_named_string(content_name, "0x");
            }
        }
    }

    function dumpContinuousSlotData(
        address target,
        uint256 startIndex,
        uint256 totalIndices,
        bool skip_zero_extcode
    ) internal {
        string memory slot_data_name;
        bytes32 slot_content;

        for (uint256 i = startIndex; i < startIndex + totalIndices; i++) {
            slot_data_name = StringHelper.concatenateStringsWithIndex(
                "slot_data",
                cheats.toString(i)
            );

            slot_content = cheats.load(target, bytes32(uint256(i)));
            dumpBytes(slot_data_name, slot_content, skip_zero_extcode);
        }
    }

    function setUp1() public virtual {
        // Assign label to current contract
        cheats.label(address(this), "Attacker_Smart_Contract");
    }
}
