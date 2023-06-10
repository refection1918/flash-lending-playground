// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "interface/etherscan_blockchain.sol";

interface IBridge {
    event DelayPeriodUpdated(uint256 period);
    event DelayThresholdUpdated(address token, uint256 threshold);
    event DelayedTransferAdded(bytes32 id);
    event DelayedTransferExecuted(
        bytes32 id,
        address receiver,
        address token,
        uint256 amount
    );
    event EpochLengthUpdated(uint256 length);
    event EpochVolumeUpdated(address token, uint256 cap);
    event GovernorAdded(address account);
    event GovernorRemoved(address account);
    event LiquidityAdded(
        uint64 seqnum,
        address provider,
        address token,
        uint256 amount
    );
    event MaxSendUpdated(address token, uint256 amount);
    event MinAddUpdated(address token, uint256 amount);
    event MinSendUpdated(address token, uint256 amount);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Paused(address account);
    event PauserAdded(address account);
    event PauserRemoved(address account);
    event Relay(
        bytes32 transferId,
        address sender,
        address receiver,
        address token,
        uint256 amount,
        uint64 srcChainId,
        bytes32 srcTransferId
    );
    event ResetNotification(uint256 resetTime);
    event Send(
        bytes32 transferId,
        address sender,
        address receiver,
        address token,
        uint256 amount,
        uint64 dstChainId,
        uint64 nonce,
        uint32 maxSlippage
    );
    event SignersUpdated(address[] _signers, uint256[] _powers);
    event Unpaused(address account);
    event WithdrawDone(
        bytes32 withdrawId,
        uint64 seqnum,
        address receiver,
        address token,
        uint256 amount,
        bytes32 refid
    );

    function addGovernor(address _account) external;

    function addLiquidity(address _token, uint256 _amount) external;

    function addNativeLiquidity(uint256 _amount) external payable;

    function addPauser(address account) external;

    function addseq() external view returns (uint64);

    function delayPeriod() external view returns (uint256);

    function delayThresholds(address) external view returns (uint256);

    function delayedTransfers(bytes32)
        external
        view
        returns (
            address receiver,
            address token,
            uint256 amount,
            uint256 timestamp
        );

    function epochLength() external view returns (uint256);

    function epochVolumeCaps(address) external view returns (uint256);

    function epochVolumes(address) external view returns (uint256);

    function executeDelayedTransfer(bytes32 id) external;

    function governors(address) external view returns (bool);

    function increaseNoticePeriod(uint256 period) external;

    function isGovernor(address _account) external view returns (bool);

    function isPauser(address account) external view returns (bool);

    function lastOpTimestamps(address) external view returns (uint256);

    function maxSend(address) external view returns (uint256);

    function minAdd(address) external view returns (uint256);

    function minSend(address) external view returns (uint256);

    function minimalMaxSlippage() external view returns (uint32);

    function nativeWrap() external view returns (address);

    function noticePeriod() external view returns (uint256);

    function notifyResetSigners() external;

    function owner() external view returns (address);

    function pause() external;

    function paused() external view returns (bool);

    function pausers(address) external view returns (bool);

    function relay(
        bytes memory _relayRequest,
        bytes[] memory _sigs,
        address[] memory _signers,
        uint256[] memory _powers
    ) external;

    function removeGovernor(address _account) external;

    function removePauser(address account) external;

    function renounceGovernor() external;

    function renounceOwnership() external;

    function renouncePauser() external;

    function resetSigners(address[] memory _signers, uint256[] memory _powers)
        external;

    function resetTime() external view returns (uint256);

    function send(
        address _receiver,
        address _token,
        uint256 _amount,
        uint64 _dstChainId,
        uint64 _nonce,
        uint32 _maxSlippage
    ) external;

    function sendNative(
        address _receiver,
        uint256 _amount,
        uint64 _dstChainId,
        uint64 _nonce,
        uint32 _maxSlippage
    ) external payable;

    function setDelayPeriod(uint256 _period) external;

    function setDelayThresholds(
        address[] memory _tokens,
        uint256[] memory _thresholds
    ) external;

    function setEpochLength(uint256 _length) external;

    function setEpochVolumeCaps(
        address[] memory _tokens,
        uint256[] memory _caps
    ) external;

    function setMaxSend(address[] memory _tokens, uint256[] memory _amounts)
        external;

    function setMinAdd(address[] memory _tokens, uint256[] memory _amounts)
        external;

    function setMinSend(address[] memory _tokens, uint256[] memory _amounts)
        external;

    function setMinimalMaxSlippage(uint32 _minimalMaxSlippage) external;

    function setWrap(address _weth) external;

    function ssHash() external view returns (bytes32);

    function transferOwnership(address newOwner) external;

    function transfers(bytes32) external view returns (bool);

    function triggerTime() external view returns (uint256);

    function unpause() external;

    function updateSigners(
        uint256 _triggerTime,
        address[] memory _newSigners,
        uint256[] memory _newPowers,
        bytes[] memory _sigs,
        address[] memory _curSigners,
        uint256[] memory _curPowers
    ) external;

    function verifySigs(
        bytes memory _msg,
        bytes[] memory _sigs,
        address[] memory _signers,
        uint256[] memory _powers
    ) external view;

    function withdraw(
        bytes memory _wdmsg,
        bytes[] memory _sigs,
        address[] memory _signers,
        uint256[] memory _powers
    ) external;

    function withdraws(bytes32) external view returns (bool);

    receive() external payable;
}

interface IStaking {
    event DelegationUpdate(
        address indexed valAddr,
        address indexed delAddr,
        uint256 valTokens,
        uint256 delShares,
        int256 tokenDiff
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Paused(address account);
    event PauserAdded(address account);
    event PauserRemoved(address account);
    event Slash(address indexed valAddr, uint64 nonce, uint256 slashAmt);
    event SlashAmtCollected(address indexed recipient, uint256 amount);
    event Undelegated(
        address indexed valAddr,
        address indexed delAddr,
        uint256 amount
    );
    event Unpaused(address account);
    event ValidatorNotice(
        address indexed valAddr,
        string key,
        bytes data,
        address from
    );
    event ValidatorStatusUpdate(address indexed valAddr, uint8 indexed status);
    event WhitelistedAdded(address account);
    event WhitelistedRemoved(address account);

    function CELER_TOKEN() external view returns (address);

    function addPauser(address account) external;

    function addWhitelisted(address account) external;

    function bondValidator() external;

    function bondedTokens() external view returns (uint256);

    function bondedValAddrs(uint256) external view returns (address);

    function collectForfeiture() external;

    function completeUndelegate(address _valAddr) external;

    function confirmUnbondedValidator(address _valAddr) external;

    function delegate(address _valAddr, uint256 _tokens) external;

    function drainToken(uint256 _amount) external;

    function forfeiture() external view returns (uint256);

    function getBondedValidatorNum() external view returns (uint256);

    function getBondedValidatorsTokens()
        external
        view
        returns (DataTypes.ValidatorTokens[] memory);

    function getDelegatorInfo(address _valAddr, address _delAddr)
        external
        view
        returns (DataTypes.DelegatorInfo memory);

    function getParamValue(uint8 _name) external view returns (uint256);

    function getQuorumTokens() external view returns (uint256);

    function getValidatorNum() external view returns (uint256);

    function getValidatorStatus(address _valAddr) external view returns (uint8);

    function getValidatorTokens(address _valAddr)
        external
        view
        returns (uint256);

    function govContract() external view returns (address);

    function hasMinRequiredTokens(address _valAddr, bool _checkSelfDelegation)
        external
        view
        returns (bool);

    function initializeValidator(
        address _signer,
        uint256 _minSelfDelegation,
        uint64 _commissionRate
    ) external;

    function isBondedValidator(address _addr) external view returns (bool);

    function isPauser(address account) external view returns (bool);

    function isWhitelisted(address account) external view returns (bool);

    function nextBondBlock() external view returns (uint256);

    function owner() external view returns (address);

    function params(uint8) external view returns (uint256);

    function pause() external;

    function paused() external view returns (bool);

    function pausers(address) external view returns (bool);

    function removePauser(address account) external;

    function removeWhitelisted(address account) external;

    function renounceOwnership() external;

    function renouncePauser() external;

    function rewardContract() external view returns (address);

    function setGovContract(address _addr) external;

    function setMaxSlashFactor(uint256 _maxSlashFactor) external;

    function setParamValue(uint8 _name, uint256 _value) external;

    function setRewardContract(address _addr) external;

    function setWhitelistEnabled(bool _whitelistEnabled) external;

    function signerVals(address) external view returns (address);

    function slash(bytes memory _slashRequest, bytes[] memory _sigs) external;

    function slashNonces(uint256) external view returns (bool);

    function transferOwnership(address newOwner) external;

    function undelegateShares(address _valAddr, uint256 _shares) external;

    function undelegateTokens(address _valAddr, uint256 _tokens) external;

    function unpause() external;

    function updateCommissionRate(uint64 _newRate) external;

    function updateMinSelfDelegation(uint256 _minSelfDelegation) external;

    function updateValidatorSigner(address _signer) external;

    function valAddrs(uint256) external view returns (address);

    function validatorNotice(
        address _valAddr,
        string memory _key,
        bytes memory _data
    ) external;

    function validators(address)
        external
        view
        returns (
            uint8 status,
            address signer,
            uint256 tokens,
            uint256 shares,
            uint256 undelegationTokens,
            uint256 undelegationShares,
            uint256 minSelfDelegation,
            uint64 bondBlock,
            uint64 unbondBlock,
            uint64 commissionRate
        );

    function verifySignatures(bytes memory _msg, bytes[] memory _sigs)
        external
        view
        returns (bool);

    function verifySigs(
        bytes memory _msg,
        bytes[] memory _sigs,
        address[] memory,
        uint256[] memory
    ) external view;

    function whitelist(address) external view returns (bool);

    function whitelistEnabled() external view returns (bool);

    receive() external payable;
}

interface DataTypes {
    struct ValidatorTokens {
        address valAddr;
        uint256 tokens;
    }

    struct DelegatorInfo {
        address valAddr;
        uint256 tokens;
        uint256 shares;
        Undelegation[] undelegations;
        uint256 undelegationTokens;
        uint256 withdrawableUndelegationTokens;
    }

    struct Undelegation {
        uint256 shares;
        uint256 creationBlock;
    }
}


interface IStakingReward {
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Paused(address account);
    event PauserAdded(address account);
    event PauserRemoved(address account);
    event StakingRewardClaimed(address indexed recipient, uint256 reward);
    event StakingRewardContributed(
        address indexed contributor,
        uint256 contribution
    );
    event Unpaused(address account);

    function addPauser(address account) external;

    function claimReward(bytes memory _rewardRequest, bytes[] memory _sigs)
        external;

    function claimedRewardAmounts(address) external view returns (uint256);

    function contributeToRewardPool(uint256 _amount) external;

    function drainToken(uint256 _amount) external;

    function isPauser(address account) external view returns (bool);

    function owner() external view returns (address);

    function pause() external;

    function paused() external view returns (bool);

    function pausers(address) external view returns (bool);

    function removePauser(address account) external;

    function renounceOwnership() external;

    function renouncePauser() external;

    function staking() external view returns (address);

    function transferOwnership(address newOwner) external;

    function unpause() external;
}

interface IMaskToken is IERC20 {
    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool);

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool);
}


interface IWETH9 is IERC20 {
    fallback() external payable;

    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);
}