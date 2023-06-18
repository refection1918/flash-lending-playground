// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "interface/etherscan_blockchain.sol";

interface IBOBA is IERC20 {
    event DelegateChanged(
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate
    );
    event DelegateVotesChanged(
        address indexed delegate,
        uint256 previousBalance,
        uint256 newBalance
    );

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;

    function checkpoints(address account, uint32 pos)
        external
        view
        returns (ERC20Votes.Checkpoint memory);

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool);

    function delegate(address delegatee) external;

    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function delegates(address account) external view returns (address);

    function getCurrentVotes(address account) external view returns (uint96);

    function getPastTotalSupply(uint256 blockNumber)
        external
        view
        returns (uint256);

    function getPastVotes(address account, uint256 blockNumber)
        external
        view
        returns (uint256);

    function getPriorVotes(address account, uint256 blockNumber)
        external
        view
        returns (uint96);

    function getVotes(address account) external view returns (uint256);

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool);

    function maxSupply() external view returns (uint224);

    function nonces(address owner) external view returns (uint256);

    function numCheckpoints(address account) external view returns (uint32);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

}

interface ERC20Votes {
    struct Checkpoint {
        uint32 fromBlock;
        uint224 votes;
    }
}


interface IOMGToken is IERC20 {
    event Mint(address indexed to, uint256 value);
    event MintFinished();
    event Pause();
    event Unpause();

    function mintingFinished() external view returns (bool);

    function unpause() external returns (bool);

    function mint(address _to, uint256 _amount) external returns (bool);

    function paused() external view returns (bool);

    function finishMinting() external returns (bool);

    function pause() external returns (bool);

    function mintTimelocked(
        address _to,
        uint256 _amount,
        uint256 _releaseTime
    ) external returns (address);

    function transferOwnership(address newOwner) external;
}


interface IL1StandardBridge {
    event ERC20DepositInitiated(
        address indexed _l1Token,
        address indexed _l2Token,
        address indexed _from,
        address _to,
        uint256 _amount,
        bytes _data
    );
    event ERC20WithdrawalFinalized(
        address indexed _l1Token,
        address indexed _l2Token,
        address indexed _from,
        address _to,
        uint256 _amount,
        bytes _data
    );
    event ETHDepositInitiated(
        address indexed _from,
        address indexed _to,
        uint256 _amount,
        bytes _data
    );
    event ETHWithdrawalFinalized(
        address indexed _from,
        address indexed _to,
        uint256 _amount,
        bytes _data
    );

    function currentDepositInfoHash() external view returns (bytes32);

    function depositERC20(
        address _l1Token,
        address _l2Token,
        uint256 _amount,
        uint32 _l2Gas,
        bytes memory _data
    ) external;

    function depositERC20To(
        address _l1Token,
        address _l2Token,
        address _to,
        uint256 _amount,
        uint32 _l2Gas,
        bytes memory _data
    ) external;

    function depositETH(uint32 _l2Gas, bytes memory _data) external payable;

    function depositETHTo(
        address _to,
        uint32 _l2Gas,
        bytes memory _data
    ) external payable;

    function deposits(address, address) external view returns (uint256);

    function donateETH() external payable;

    function finalizeERC20Withdrawal(
        address _l1Token,
        address _l2Token,
        address _from,
        address _to,
        uint256 _amount,
        bytes memory _data
    ) external;

    function finalizeETHWithdrawal(
        address _from,
        address _to,
        uint256 _amount,
        bytes memory _data
    ) external;

    function initialize(address _l1messenger, address _l2TokenBridge) external;

    function l2TokenBridge() external view returns (address);

    function lastHashUpdateBlock() external view returns (uint256);

    function messenger() external view returns (address);

    function priorDepositInfoHash() external view returns (bytes32);

    receive() external payable;
}


interface IL1MultiMessageRelayer {
    function batchRelayMessages(
        L1MultiMessageRelayer.L2ToL1Message[] memory _messages
    ) external;

    function libAddressManager() external view returns (address);

    function resolve(string memory _name) external view returns (address);
}

interface L1MultiMessageRelayer {
    struct L2ToL1Message {
        address target;
        address sender;
        bytes message;
        uint256 messageNonce;
        IL1CrossDomainMessenger.L2MessageInclusionProof proof;
    }
}

interface IL1CrossDomainMessenger {
    struct L2MessageInclusionProof {
        bytes32 stateRoot;
        Lib_OVMCodec.ChainBatchHeader stateRootBatchHeader;
        Lib_OVMCodec.ChainInclusionProof stateRootProof;
        bytes stateTrieWitness;
        bytes storageTrieWitness;
    }
}

interface Lib_OVMCodec {
    struct ChainBatchHeader {
        uint256 batchIndex;
        bytes32 batchRoot;
        uint256 batchSize;
        uint256 prevTotalElements;
        bytes extraData;
    }

    struct ChainInclusionProof {
        uint256 index;
        bytes32[] siblings;
    }
}

interface IL1ChugSplashProxy is IL1StandardBridge {
    fallback() external payable;

    function getImplementation() external returns (address);

    function getOwner() external returns (address);

    function setCode(bytes memory _code) external;

    function setOwner(address _owner) external;

    function setStorage(bytes32 _key, bytes32 _value) external;
}