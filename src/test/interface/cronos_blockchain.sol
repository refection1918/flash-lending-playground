// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "interface/ethereum_blockchain.sol";

interface ITONIC is IERC20 {
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

    function DELEGATION_TYPEHASH() external view returns (bytes32);

    function DOMAIN_TYPEHASH() external view returns (bytes32);

    function checkpoints(
        address,
        uint32
    ) external view returns (uint32 fromBlock, uint128 votes);

    function delegate(address delegatee) external;

    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function delegates(address) external view returns (address);

    function getCurrentVotes(address account) external view returns (uint128);

    function getPriorVotes(
        address account,
        uint256 blockNumber
    ) external view returns (uint128);

    function nonces(address) external view returns (uint256);

    function numCheckpoints(address) external view returns (uint32);
}

interface IVVSRouter {
    function WETH() external view returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function factory() external view returns (address);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountsIn(
        uint256 amountOut,
        address[] memory path
    ) external view returns (uint256[] memory amounts);

    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) external view returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] memory path,
        address to,
        uint256 deadline
    ) external;

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] memory path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    receive() external payable;
}

interface IVVSFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function INIT_CODE_PAIR_HASH() external view returns (bytes32);

    function allPairs(uint256) external view returns (address);

    function allPairsLength() external view returns (uint256);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address, address) external view returns (address);

    function setFeeTo(address _feeTo) external;

    function setFeeToSetter(address _feeToSetter) external;
}

interface IVVSPair is IERC20 {
    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

// Generated from ABI of https://cronoscan.com/token/0xc21223249ca28397b4b6541dffaecc539bff0c59#code
interface ICronosCRC20 is IERC20 {
    event Burn(address indexed guy, uint256 wad);
    event LogSetAuthority(address indexed authority);
    event LogSetOwner(address indexed owner);
    event Mint(address indexed guy, uint256 wad);
    event Start();
    event Stop();
    event __CronosSendToEthereum(
        address recipient,
        uint256 amount,
        uint256 bridge_fee
    );
    event __CronosSendToIbc(address sender, string recipient, uint256 amount);

    function approve(address guy) external returns (bool);

    function authority() external view returns (address);

    function burn(uint256 wad) external;

    function burn(address guy, uint256 wad) external;

    function burn_by_cronos_module(address addr, uint256 amount) external;

    function mint(address guy, uint256 wad) external;

    function mint(uint256 wad) external;

    function mint_by_cronos_module(address addr, uint256 amount) external;

    function move(address src, address dst, uint256 wad) external;

    function native_denom() external view returns (string memory);

    function pull(address src, uint256 wad) external;

    function push(address dst, uint256 wad) external;

    function send_to_ethereum(
        address recipient,
        uint256 amount,
        uint256 bridge_fee
    ) external;

    function send_to_ibc(string memory recipient, uint256 amount) external;

    function setAuthority(address authority_) external;

    function setName(string memory name_) external;

    function setOwner(address owner_) external;

    function start() external;

    function stop() external;

    function stopped() external view returns (bool);
}

interface IVVS is IERC20 {
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event SupplyDistributed(uint256 amount);

    function BLOCK_TIME() external view returns (uint256);

    function SUPPLY_PER_BLOCK() external view returns (uint256);

    function SUPPLY_PER_YEAR() external view returns (uint256);

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) external returns (bool);

    function distributeSupply(
        address[] memory _teamAddresses,
        uint256[] memory _teamAmounts
    ) external;

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) external returns (bool);

    function mint(address _to, uint256 _amount) external;

    function nextDistributionTimestamp() external view returns (uint256);

    function nextDistributionWindow() external view returns (uint256);

    function renounceOwnership() external;

    function transferOwnership(address newOwner) external;
}

interface IWorkbench is IERC20 {
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function burn(address _from, uint256 _amount) external;

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) external returns (bool);

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) external returns (bool);

    function mint(address _to, uint256 _amount) external;

    function renounceOwnership() external;

    function safeVVSTransfer(address _to, uint256 _amount) external;

    function transferOwnership(address newOwner) external;

    function vvs() external view returns (address);
}

interface ICraftsman {
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(
        address indexed user,
        uint256 indexed pid,
        uint256 amount
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event UpdatedVVSStakingRatio(uint256 newRatio);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);

    function BONUS_MULTIPLIER() external view returns (uint256);

    function add(
        uint256 _allocPoint,
        address _lpToken,
        bool _withUpdate
    ) external;

    function bench() external view returns (address);

    function deposit(uint256 _pid, uint256 _amount) external;

    function dev(address _devaddr) external;

    function devaddr() external view returns (address);

    function distributeSupply(
        address[] memory _teamAddresses,
        uint256[] memory _teamAmounts
    ) external;

    function emergencyWithdraw(uint256 _pid) external;

    function enterStaking(uint256 _amount) external;

    function getMultiplier(
        uint256 _from,
        uint256 _to
    ) external view returns (uint256);

    function leaveStaking(uint256 _amount) external;

    function massUpdatePools() external;

    function migrate(uint256 _pid) external;

    function migrator() external view returns (address);

    function owner() external view returns (address);

    function pendingVVS(
        uint256 _pid,
        address _user
    ) external view returns (uint256);

    function poolInfo(
        uint256
    )
        external
        view
        returns (
            address lpToken,
            uint256 allocPoint,
            uint256 lastRewardBlock,
            uint256 accVVSPerShare
        );

    function poolLength() external view returns (uint256);

    function renounceOwnership() external;

    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external;

    function setMigrator(address _migrator) external;

    function startBlock() external view returns (uint256);

    function totalAllocPoint() external view returns (uint256);

    function transferOwnership(address newOwner) external;

    function updateMultiplier(uint256 multiplierNumber) external;

    function updatePool(uint256 _pid) external;

    function updateStakingRatio(uint256 _ratio) external;

    function userInfo(
        uint256,
        address
    ) external view returns (uint256 amount, uint256 rewardDebt);

    function vvs() external view returns (address);

    function vvsPerBlock() external view returns (uint256);

    function vvsStakingRatio() external view returns (uint256);

    function withdraw(uint256 _pid, uint256 _amount) external;
}

interface IRewarder {
    event AddPool(uint256 indexed pid, uint256 allocPoint);
    event EmergencyRewardWithdraw(address indexed user, uint256 amount);
    event OnVVSReward(
        uint256 indexed pid,
        address indexed user,
        uint256 amount,
        uint256 pending
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event SetPool(uint256 indexed pid, uint256 allocPoint);
    event SetRewardEndTimestamp(uint256 rewardEndTimestamp);
    event SetRewardPerSecond(uint256 rewardPerSecond);
    event SetRewardStartTimestamp(uint256 rewardStartTimestamp);

    function ACC_TOKEN_PRECISION() external view returns (uint256);

    function add(uint256 _allocPoint, uint256 _pid, bool _withUpdate) external;

    function craftsman() external view returns (address);

    function craftsmanV2() external view returns (address);

    function emergencyRewardWithdraw(uint256 _amount) external;

    function massUpdatePools() external;

    function onVVSReward(
        uint256 _pid,
        address _user,
        uint256 _currentAmount
    ) external;

    function owner() external view returns (address);

    function pendingToken(
        uint256 _pid,
        address _user
    ) external view returns (address, uint256);

    function poolIds(uint256) external view returns (uint256);

    function poolInfo(
        uint256
    )
        external
        view
        returns (
            uint256 allocPoint,
            uint256 lastRewardTime,
            uint256 accRewardPerShare
        );

    function poolLength() external view returns (uint256 pools);

    function renounceOwnership() external;

    function rewardEndTimestamp() external view returns (uint256);

    function rewardPerSecond() external view returns (uint256);

    function rewardStartTimestamp() external view returns (uint256);

    function rewardToken() external view returns (address);

    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external;

    function setRewardEndTimestamp(uint256 _rewardEndTimestamp) external;

    function setRewardPerSecond(uint256 _rewardPerSecond) external;

    function setRewardStartTimestamp(uint256 _rewardStartTimestamp) external;

    function totalAllocPoint() external view returns (uint256);

    function transferOwnership(address newOwner) external;

    function updatePool(uint256 _pid) external;

    function userInfo(
        uint256,
        address
    ) external view returns (uint256 rewardDebt);
}

interface IVVSBoost {
    event AddPool(
        uint256 indexed poolId,
        uint256 multiplier,
        uint256 lockPeriod
    );
    event AdminChanged(address previousAdmin, address newAdmin);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event BeaconUpgraded(address indexed beacon);
    event BoostsAnyFarmFailed(
        address indexed farmBoost,
        address indexed user,
        bool indexed noContract
    );
    event Deposit(
        address indexed user,
        uint256 indexed pid,
        uint256 indexed stakeId,
        uint256 amount,
        uint256 weightedAmount,
        uint256 unlockTimestamp
    );
    event FarmBoostUpdated(address indexed farmBoost);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event SetPool(
        uint256 indexed poolId,
        uint256 multiplier,
        uint256 lockPeriod
    );
    event Transfer(address indexed from, address indexed to, uint256 value);
    event UpdateSharesFailed(address indexed farmBoost, address indexed user);
    event Upgrade(
        address indexed user,
        uint256 indexed stakeId,
        uint256 indexed newPid,
        uint256 newWeightedAmount,
        uint256 newUnlockTimestamp
    );
    event Upgraded(address indexed implementation);
    event Withdraw(
        address indexed user,
        uint256 indexed stakeId,
        uint256 amount,
        uint256 weightedAmount
    );

    function PRECISION() external view returns (uint256);

    function accTokenPerShare() external view returns (uint256);

    function activePoolMap(uint256, uint256) external view returns (uint256);

    function add(uint256 _multiplier, uint256 _lockPeriod) external;

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function batchUpgrade(
        uint256[] memory _stakeIds,
        uint256[] memory _newPids
    ) external;

    function batchWithdraw(uint256[] memory _stakeIds) external;

    function craftsman() external view returns (address);

    function decimals() external view returns (uint8);

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) external returns (bool);

    function deposit(uint256 _pid, uint256 _amount) external;

    function depositCraftsman() external;

    function depositToken() external view returns (address);

    function depositTokenPid() external view returns (uint256);

    function farmBoost() external view returns (address);

    function getUserInfo(
        address _user
    ) external view returns (uint256, uint256, VVSBoost.Stake[] memory);

    function getUserStake(
        address _user,
        uint256 _stakeId
    ) external view returns (VVSBoost.Stake memory);

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) external returns (bool);

    function initialize(
        address _craftsman,
        address _vvs,
        address _xvvs,
        address _depositToken,
        uint256 _depositTokenPid
    ) external;

    function lastRewardBlock() external view returns (uint256);

    function lastVVSBalance() external view returns (uint256);

    function name() external view returns (string memory);

    function owner() external view returns (address);

    function pendingVVS(address _user) external view returns (uint256);

    function poolInfo(
        uint256
    )
        external
        view
        returns (uint256 multiplier, uint256 lockPeriod, uint256 totalStaked);

    function poolLength() external view returns (uint256);

    function proxiableUUID() external view returns (bytes32);

    function renounceOwnership() external;

    function set(
        uint256 _pid,
        uint256 _multiplier,
        uint256 _lockPeriod
    ) external;

    function setFarmBoost(address _farmBoost) external;

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function transferOwnership(address newOwner) external;

    function upgrade(uint256 _stakeId, uint256 _newPid) external;

    function upgradeTo(address newImplementation) external;

    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) external payable;

    function userInfo(
        address
    ) external view returns (uint256 weightedAmount, uint256 rewardDebt);

    function vvs() external view returns (address);

    function withdraw(uint256 _stakeId) external;

    function xvvs() external view returns (address);
}

interface VVSBoost {
    struct Stake {
        uint256 amount;
        uint256 poolId;
        uint256 weightedAmount;
        uint256 stakeTimestamp;
        uint256 unlockTimestamp;
        bool active;
    }
}

interface IVVSVault {
    event Deposit(
        address indexed sender,
        uint256 amount,
        uint256 shares,
        uint256 lastDepositedTime
    );
    event Harvest(
        address indexed sender,
        uint256 performanceFee,
        uint256 callFee
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Pause();
    event Paused(address account);
    event SetAdmin(address admin);
    event SetCallFee(uint256 callFee);
    event SetPerformanceFee(uint256 performanceFee);
    event SetTreasury(address treasury);
    event SetWithdrawFee(uint256 withdrawFee);
    event SetWithdrawFeePeriod(uint256 withdrawFeePeriod);
    event Unpause();
    event Unpaused(address account);
    event Withdraw(address indexed sender, uint256 amount, uint256 shares);

    function MAX_CALL_FEE() external view returns (uint256);

    function MAX_PERFORMANCE_FEE() external view returns (uint256);

    function MAX_WITHDRAW_FEE() external view returns (uint256);

    function MAX_WITHDRAW_FEE_PERIOD() external view returns (uint256);

    function admin() external view returns (address);

    function available() external view returns (uint256);

    function balanceOf() external view returns (uint256);

    function calculateHarvestVVSRewards() external view returns (uint256);

    function calculateTotalPendingVVSRewards() external view returns (uint256);

    function callFee() external view returns (uint256);

    function craftsman() external view returns (address);

    function deposit(uint256 _amount) external;

    function emergencyWithdraw() external;

    function getPricePerFullShare() external view returns (uint256);

    function harvest() external;

    function inCaseTokensGetStuck(address _token) external;

    function lastHarvestedTime() external view returns (uint256);

    function owner() external view returns (address);

    function pause() external;

    function paused() external view returns (bool);

    function performanceFee() external view returns (uint256);

    function receiptToken() external view returns (address);

    function renounceOwnership() external;

    function setAdmin(address _admin) external;

    function setCallFee(uint256 _callFee) external;

    function setPerformanceFee(uint256 _performanceFee) external;

    function setTreasury(address _treasury) external;

    function setWithdrawFee(uint256 _withdrawFee) external;

    function setWithdrawFeePeriod(uint256 _withdrawFeePeriod) external;

    function token() external view returns (address);

    function totalShares() external view returns (uint256);

    function transferOwnership(address newOwner) external;

    function treasury() external view returns (address);

    function unpause() external;

    function userInfo(
        address
    )
        external
        view
        returns (
            uint256 shares,
            uint256 lastDepositedTime,
            uint256 vvsAtLastUserAction,
            uint256 lastUserActionTime
        );

    function withdraw(uint256 _shares) external;

    function withdrawAll() external;

    function withdrawFee() external view returns (uint256);

    function withdrawFeePeriod() external view returns (uint256);
}

interface IVVSZap {
    event AddIntermediateToken(address indexed intermediateToken);
    event AddLiquidityPool(address indexed liquidityPool, bool isFromFactory);
    event AddToken(address indexed token, bool isFromFactory);
    event FetchLiquidityPoolsFromFactory(
        uint256 startFromPairIndex,
        uint256 endAtPairIndex
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event RemoveIntermediateToken(address indexed intermediateToken);
    event RemoveLiquidityPool(address indexed liquidityPool);
    event RemovePresetPath(address indexed fromToken, address indexed toToken);
    event RemoveToken(address indexed token);
    event SetPresetPath(
        address indexed fromToken,
        address indexed toToken,
        address[] paths,
        bool isAutoGenerated
    );
    event SwapExactTokensForTokens(address[] paths, uint256[] amounts);
    event ZapIn(address indexed to, uint256 amount, uint256 outputAmount);
    event ZapInToken(
        address indexed from,
        address indexed to,
        uint256 amount,
        uint256 outputAmount
    );
    event ZapOut(
        address indexed from,
        address indexed to,
        uint256 amount,
        uint256 outputAmount
    );

    function FACTORY() external view returns (address);

    function ROUTER() external view returns (address);

    function WCRO() external view returns (address);

    function addIntermediateToken(address _tokenAddress) external;

    function addLiquidityPool(address _lpAddress) external;

    function addToken(address _tokenAddress) external;

    function fetchLiquidityPoolsFromFactory() external;

    function fetchLiquidityPoolsFromFactoryWithIndex(
        uint256 _startFromPairIndex,
        uint256 _interval
    ) external;

    function getAutoCalculatedPathWithIntermediateTokenForTokenToToken(
        address _fromToken,
        address _toToken
    ) external view returns (address[] memory);

    function getIntermediateToken(uint256 _i) external view returns (address);

    function getIntermediateTokenListLength() external view returns (uint256);

    function getLiquidityPoolAddress(
        address _tokenA,
        address _tokenB
    ) external view returns (address);

    function getPathForTokenToToken(
        address _fromToken,
        address _toToken
    ) external view returns (address[] memory);

    function getPresetPath(
        address _tokenA,
        address _tokenB
    ) external view returns (address[] memory);

    function getSuitableIntermediateTokenForTokenToLP(
        address _fromToken,
        address _toLP
    ) external view returns (address);

    function getToken(uint256 i) external view returns (address);

    function getTokenListLength() external view returns (uint256);

    function intermediateTokenList(uint256) external view returns (address);

    function intermediateTokens(address) external view returns (uint256);

    function isLP(address _address) external view returns (bool);

    function isLiquidityPoolExistInFactory(
        address _tokenA,
        address _tokenB
    ) external view returns (bool);

    function isToken(address _address) external view returns (bool);

    function lastFetchedPairIndex() external view returns (uint256);

    function liquidityPools(address) external view returns (bool);

    function owner() external view returns (address);

    function presetPaths(
        address,
        address,
        uint256
    ) external view returns (address);

    function removeIntermediateToken(
        address _intermediateTokenAddress
    ) external;

    function removeLiquidityPool(address _lpAddress) external;

    function removePresetPath(address tokenA, address tokenB) external;

    function removeToken(address _tokenAddress) external;

    function renounceOwnership() external;

    function setPresetPath(
        address _tokenA,
        address _tokenB,
        address[] memory _path
    ) external;

    function setPresetPathByAutoCalculation(
        address _tokenA,
        address _tokenB
    ) external;

    function tokenList(uint256) external view returns (address);

    function tokens(address) external view returns (uint256);

    function transferOwnership(address newOwner) external;

    function withdrawBalance(address _token, uint256 _amount) external payable;

    function zapIn(
        address _toTokenOrLp,
        uint256 _outputAmountMin
    ) external payable returns (uint256);

    function zapInToken(
        address _fromToken,
        uint256 _inputAmount,
        address _toTokenOrLp,
        uint256 _outputAmountMin
    ) external returns (uint256);

    function zapOut(
        address _fromLp,
        uint256 _inputAmount,
        address _toTokenOrLp,
        uint256 _outputAmountMin
    ) external payable returns (uint256);

    receive() external payable;
}
