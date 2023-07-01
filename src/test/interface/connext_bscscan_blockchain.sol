// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// https://bscscan.com/address/0xe37d4f73ef1c85def2174a394f17ac65dd3cbb81#code
interface ITokenFacet {
    error TokenFacet__addAssetId_alreadyAdded();
    error TokenFacet__addAssetId_badBurn();
    error TokenFacet__addAssetId_badMint();
    error TokenFacet__enrollAdoptedAndLocalAssets_emptyCanonical();
    error TokenFacet__removeAssetId_invalidParams();
    error TokenFacet__removeAssetId_notAdded();
    error TokenFacet__removeAssetId_remainsCustodied();
    error TokenFacet__setLiquidityCap_notCanonicalDomain();
    error TokenFacet__setupAssetWithDeployedRepresentation_invalidRepresentation();
    error TokenFacet__setupAssetWithDeployedRepresentation_onCanonicalDomain();
    error TokenFacet__setupAsset_invalidCanonicalConfiguration();
    error TokenFacet__setupAsset_representationListed();
    error TokenFacet__updateDetails_localNotFound();
    error TokenFacet__updateDetails_notApproved();
    error TokenFacet__updateDetails_onlyRemote();

    event AssetAdded(
        bytes32 indexed key,
        bytes32 indexed canonicalId,
        uint32 indexed domain,
        address adoptedAsset,
        address localAsset,
        address caller
    );
    event AssetRemoved(bytes32 indexed key, address caller);
    event LiquidityCapUpdated(
        bytes32 indexed key,
        bytes32 indexed canonicalId,
        uint32 indexed domain,
        uint256 cap,
        address caller
    );
    event StableSwapAdded(
        bytes32 indexed key,
        bytes32 indexed canonicalId,
        uint32 indexed domain,
        address swapPool,
        address caller
    );
    event TokenDeployed(
        uint32 indexed domain,
        bytes32 indexed id,
        address indexed representation
    );

    function addStableSwapPool(
        TokenId memory _canonical,
        address _stableSwapPool
    ) external;

    function adoptedToCanonical(
        address _adopted
    ) external view returns (TokenId memory);

    function adoptedToLocalExternalPools(
        TokenId memory _canonical
    ) external view returns (address);

    function adoptedToLocalExternalPools(
        bytes32 _key
    ) external view returns (address);

    function approvedAssets(bytes32 _key) external view returns (bool);

    function approvedAssets(
        TokenId memory _canonical
    ) external view returns (bool);

    function canonicalToAdopted(bytes32 _key) external view returns (address);

    function canonicalToAdopted(
        TokenId memory _canonical
    ) external view returns (address);

    function canonicalToRepresentation(
        bytes32 _key
    ) external view returns (address);

    function canonicalToRepresentation(
        TokenId memory _canonical
    ) external view returns (address);

    function getCustodiedAmount(bytes32 _key) external view returns (uint256);

    function getLocalAndAdoptedToken(
        bytes32 _id,
        uint32 _domain
    ) external view returns (address, address);

    function getTokenId(
        address _candidate
    ) external view returns (TokenId memory);

    function removeAssetId(
        TokenId memory _canonical,
        address _adoptedAssetId,
        address _representation
    ) external;

    function removeAssetId(
        bytes32 _key,
        address _adoptedAssetId,
        address _representation
    ) external;

    function representationToCanonical(
        address _representation
    ) external view returns (TokenId memory);

    function setupAsset(
        TokenId memory _canonical,
        uint8 _canonicalDecimals,
        string memory _representationName,
        string memory _representationSymbol,
        address _adoptedAssetId,
        address _stableSwapPool,
        uint256 _cap
    ) external returns (address _local);

    function setupAssetWithDeployedRepresentation(
        TokenId memory _canonical,
        address _representation,
        address _adoptedAssetId,
        address _stableSwapPool
    ) external returns (address);

    function updateDetails(
        TokenId memory _canonical,
        string memory _name,
        string memory _symbol
    ) external;

    function updateLiquidityCap(
        TokenId memory _canonical,
        uint256 _updated
    ) external;
}

struct TokenId {
    uint32 domain;
    bytes32 id;
}

interface IErrorAssetLogic {
    error AssetLogic__getConfig_notRegistered();
    error AssetLogic__getTokenIndexFromStableSwapPool_notExist();
    error AssetLogic__handleIncomingAsset_feeOnTransferNotSupported();
    error AssetLogic__handleIncomingAsset_nativeAssetNotSupported();
    error AssetLogic__handleOutgoingAsset_notNative();
}

interface IErrorBaseConnextFacet {
    error BaseConnextFacet__getAdoptedAsset_assetNotFound();
    error BaseConnextFacet__getApprovedCanonicalId_notAllowlisted();
    error BaseConnextFacet__nonReentrant_reentrantCall();
    error BaseConnextFacet__nonXCallReentrant_reentrantCall();
    error BaseConnextFacet__onlyOwnerOrAdmin_notOwnerOrAdmin();
    error BaseConnextFacet__onlyOwnerOrRouter_notOwnerOrRouter();
    error BaseConnextFacet__onlyOwnerOrWatcher_notOwnerOrWatcher();
    error BaseConnextFacet__onlyOwner_notOwner();
    error BaseConnextFacet__onlyProposed_notProposedOwner();
    error BaseConnextFacet__whenNotPaused_paused();
}

// https://bscscan.com/address/0xc41a071742a1f2ffe76d075205db90742c113608#code
interface IBridgeFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    error BridgeFacet__addRemote_invalidDomain();
    error BridgeFacet__addRemote_invalidRouter();
    error BridgeFacet__addSequencer_alreadyApproved();
    error BridgeFacet__addSequencer_invalidSequencer();
    error BridgeFacet__bumpTransfer_noRelayerVault();
    error BridgeFacet__bumpTransfer_valueIsZero();
    error BridgeFacet__excecute_insufficientGas();
    error BridgeFacet__executePortalTransfer_insufficientAmountWithdrawn();
    error BridgeFacet__execute_badFastLiquidityStatus();
    error BridgeFacet__execute_externalCallFailed();
    error BridgeFacet__execute_invalidRouterSignature();
    error BridgeFacet__execute_invalidSequencerSignature();
    error BridgeFacet__execute_maxRoutersExceeded();
    error BridgeFacet__execute_notApprovedForPortals();
    error BridgeFacet__execute_notReconciled();
    error BridgeFacet__execute_notSupportedRouter();
    error BridgeFacet__execute_notSupportedSequencer();
    error BridgeFacet__execute_unapprovedSender();
    error BridgeFacet__execute_wrongDomain();
    error BridgeFacet__forceReceiveLocal_notDestination();
    error BridgeFacet__forceUpdateSlippage_invalidSlippage();
    error BridgeFacet__forceUpdateSlippage_notDestination();
    error BridgeFacet__mustHaveRemote_destinationNotSupported();
    error BridgeFacet__onlyDelegate_notDelegate();
    error BridgeFacet__removeSequencer_notApproved();
    error BridgeFacet__setXAppConnectionManager_domainsDontMatch();
    error BridgeFacet__xcall_capReached();
    error BridgeFacet__xcall_emptyTo();
    error BridgeFacet__xcall_invalidSlippage();
    error BridgeFacet__xcall_nativeAssetNotSupported();
    error BridgeFacet_xcall__emptyLocalAsset();

    event AavePortalMintUnbacked(
        bytes32 indexed transferId,
        address indexed router,
        address asset,
        uint256 amount
    );
    event Executed(
        bytes32 indexed transferId,
        address indexed to,
        address indexed asset,
        ExecuteArgs args,
        address local,
        uint256 amount,
        address caller
    );
    event ExternalCalldataExecuted(
        bytes32 indexed transferId,
        bool success,
        bytes returnData
    );
    event ForceReceiveLocal(bytes32 indexed transferId);
    event RemoteAdded(uint32 domain, address remote, address caller);
    event SequencerAdded(address sequencer, address caller);
    event SequencerRemoved(address sequencer, address caller);
    event SlippageUpdated(bytes32 indexed transferId, uint256 slippage);
    event TransferRelayerFeesIncreased(
        bytes32 indexed transferId,
        uint256 increase,
        address asset,
        address caller
    );
    event XAppConnectionManagerSet(address updated, address caller);
    event XCalled(
        bytes32 indexed transferId,
        uint256 indexed nonce,
        bytes32 indexed messageHash,
        TransferInfo params,
        address asset,
        uint256 amount,
        address local,
        bytes messageBody
    );

    function addSequencer(address _sequencer) external;

    function approvedSequencers(
        address _sequencer
    ) external view returns (bool);

    function bumpTransfer(bytes32 _transferId) external payable;

    function bumpTransfer(
        bytes32 _transferId,
        address _relayerFeeAsset,
        uint256 _relayerFee
    ) external;

    function domain() external view returns (uint32);

    function enrollRemoteRouter(uint32 _domain, bytes32 _router) external;

    function execute(ExecuteArgs memory _args) external returns (bytes32);

    function forceReceiveLocal(TransferInfo memory _params) external;

    function forceUpdateSlippage(
        TransferInfo memory _params,
        uint256 _slippage
    ) external;

    function nonce() external view returns (uint256);

    function remote(uint32 _domain) external view returns (address);

    function removeSequencer(address _sequencer) external;

    function routedTransfers(
        bytes32 _transferId
    ) external view returns (address[] memory);

    function setXAppConnectionManager(address _xAppConnectionManager) external;

    function transferStatus(bytes32 _transferId) external view returns (uint8);

    function xAppConnectionManager() external view returns (address);

    function xcall(
        uint32 _destination,
        address _to,
        address _asset,
        address _delegate,
        uint256 _amount,
        uint256 _slippage,
        bytes memory _callData
    ) external payable returns (bytes32);

    function xcall(
        uint32 _destination,
        address _to,
        address _asset,
        address _delegate,
        uint256 _amount,
        uint256 _slippage,
        bytes memory _callData,
        uint256 _relayerFee
    ) external returns (bytes32);

    function xcallIntoLocal(
        uint32 _destination,
        address _to,
        address _asset,
        address _delegate,
        uint256 _amount,
        uint256 _slippage,
        bytes memory _callData,
        uint256 _relayerFee
    ) external returns (bytes32);

    function xcallIntoLocal(
        uint32 _destination,
        address _to,
        address _asset,
        address _delegate,
        uint256 _amount,
        uint256 _slippage,
        bytes memory _callData
    ) external payable returns (bytes32);
}

struct TransferInfo {
    uint32 originDomain;
    uint32 destinationDomain;
    uint32 canonicalDomain;
    address to;
    address delegate;
    bool receiveLocal;
    bytes callData;
    uint256 slippage;
    address originSender;
    uint256 bridgedAmt;
    uint256 normalizedIn;
    uint256 nonce;
    bytes32 canonicalId;
}

struct ExecuteArgs {
    TransferInfo params;
    address[] routers;
    bytes[] routerSignatures;
    address sequencer;
    bytes sequencerSignature;
}

// https://bscscan.com/address/0x5ccd25372a41eeb3d4e5353879bb28213df5a295#code
interface IInboxFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    error InboxFacet__handle_notTransfer();
    error InboxFacet__onlyRemoteRouter_notRemote();
    error InboxFacet__onlyReplica_notReplica();
    error InboxFacet__reconcile_alreadyReconciled();
    error InboxFacet__reconcile_noPortalRouter();
    error TypedMemView__assertType_typeAssertionFailed(
        uint256 actual,
        uint256 expected
    );
    error TypedMemView__assertValid_validityAssertionFailed();
    error TypedMemView__index_indexMoreThan32Bytes();
    error TypedMemView__index_overrun(
        uint256 loc,
        uint256 len,
        uint256 index,
        uint256 slice
    );

    event Receive(
        uint64 indexed originAndNonce,
        address indexed token,
        address indexed recipient,
        address liquidityProvider,
        uint256 amount
    );
    event Reconciled(
        bytes32 indexed transferId,
        uint32 indexed originDomain,
        address indexed local,
        address[] routers,
        uint256 amount,
        address caller
    );

    function handle(
        uint32 _origin,
        uint32 _nonce,
        bytes32 _sender,
        bytes memory _message
    ) external;
}

// https://bscscan.com/address/0x086b5a16d7bd6b2955fcc7d5f9aa2a1544b67e0d#code
interface IProposedOwnableFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    error ProposedOwnableFacet__acceptProposedOwner_noOwnershipChange();
    error ProposedOwnableFacet__assignRoleAdmin_invalidInput();
    error ProposedOwnableFacet__assignRoleRouter_invalidInput();
    error ProposedOwnableFacet__assignRoleWatcher_invalidInput();
    error ProposedOwnableFacet__delayElapsed_delayNotElapsed();
    error ProposedOwnableFacet__proposeAssetAllowlistRemoval_noOwnershipChange();
    error ProposedOwnableFacet__proposeNewOwner_invalidProposal();
    error ProposedOwnableFacet__proposeNewOwner_noOwnershipChange();
    error ProposedOwnableFacet__proposeRouterAllowlistRemoval_noOwnershipChange();
    error ProposedOwnableFacet__removeAssetAllowlist_noOwnershipChange();
    error ProposedOwnableFacet__removeAssetAllowlist_noProposal();
    error ProposedOwnableFacet__removeRouterAllowlist_noOwnershipChange();
    error ProposedOwnableFacet__removeRouterAllowlist_noProposal();
    error ProposedOwnableFacet__revokeRole_invalidInput();
    event AssignRoleAdmin(address admin);
    event AssignRoleRouter(address router);
    event AssignRoleWatcher(address watcher);
    event OwnershipProposed(address indexed proposedOwner);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Paused();
    event RevokeRole(address revokedAddress, uint8 revokedRole);
    event RouterAllowlistRemovalProposed(uint256 timestamp);
    event RouterAllowlistRemoved(bool renounced);
    event Unpaused();

    function acceptProposedOwner() external;

    function assignRoleAdmin(address _admin) external;

    function assignRoleRouterAdmin(address _router) external;

    function assignRoleWatcher(address _watcher) external;

    function delay() external view returns (uint256);

    function owner() external view returns (address);

    function pause() external;

    function paused() external view returns (bool);

    function proposeNewOwner(address newlyProposed) external;

    function proposeRouterAllowlistRemoval() external;

    function proposed() external view returns (address);

    function proposedTimestamp() external view returns (uint256);

    function queryRole(address _role) external view returns (uint8);

    function removeRouterAllowlist() external;

    function revokeRole(address _revoke) external;

    function routerAllowlistRemoved() external view returns (bool);

    function routerAllowlistTimestamp() external view returns (uint256);

    function unpause() external;
}

// https://bscscan.com/address/0x7993bb17d8d8a0676cc1527f8b4ce52a2b490352#code
interface IPortalFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    error PortalFacet__repayAavePortalFor_invalidAsset();
    error PortalFacet__repayAavePortalFor_zeroAmount();
    error PortalFacet__repayAavePortal_assetNotApproved();
    error PortalFacet__repayAavePortal_insufficientFunds();
    error PortalFacet__setAavePortalFee_invalidFee();
    event AavePoolUpdated(address updated, address caller);
    event AavePortalFeeUpdated(uint256 updated, address caller);
    event AavePortalRepayment(
        bytes32 indexed transferId,
        address asset,
        uint256 amount,
        uint256 fee,
        address caller
    );

    function aavePool() external view returns (address);

    function aavePortalFee() external view returns (uint256);

    function getAavePortalDebt(
        bytes32 _transferId
    ) external view returns (uint256);

    function getAavePortalFeeDebt(
        bytes32 _transferId
    ) external view returns (uint256);

    function repayAavePortal(
        TransferInfo memory _params,
        uint256 _backingAmount,
        uint256 _feeAmount,
        uint256 _maxIn
    ) external;

    function repayAavePortalFor(
        TransferInfo memory _params,
        address _portalAsset,
        uint256 _backingAmount,
        uint256 _feeAmount
    ) external payable;

    function setAavePool(address _aavePool) external;

    function setAavePortalFee(uint256 _aavePortalFeeNumerator) external;
}

// https://bscscan.com/address/0xccb64fdf1c0cc1aac1c39e5968e82f89c1b8c769#code
interface IRelayerFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    error RelayerFacet__addRelayer_alreadyApproved();
    error RelayerFacet__removeRelayer_notApproved();
    error RelayerFacet__setRelayerFeeVault_invalidRelayerFeeVault();
    event RelayerAdded(address relayer, address caller);
    event RelayerFeeVaultUpdated(
        address oldVault,
        address newVault,
        address caller
    );
    event RelayerRemoved(address relayer, address caller);

    function addRelayer(address _relayer) external;

    function approvedRelayers(address _relayer) external view returns (bool);

    function relayerFeeVault() external view returns (address);

    function removeRelayer(address _relayer) external;

    function setRelayerFeeVault(address _relayerFeeVault) external;
}

// https://bscscan.com/address/0xbe8d8ac9a44fba6cb7a7e02c1e6576e06c7da72d#code
interface IRoutersFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    error RoutersFacet__acceptProposedRouterOwner_badCaller();
    error RoutersFacet__acceptProposedRouterOwner_notElapsed();
    error RoutersFacet__addLiquidityForRouter_amountIsZero();
    error RoutersFacet__addLiquidityForRouter_badRouter();
    error RoutersFacet__addLiquidityForRouter_capReached();
    error RoutersFacet__addLiquidityForRouter_routerEmpty();
    error RoutersFacet__approveRouterForPortal_alreadyApproved();
    error RoutersFacet__approveRouterForPortal_notAdded();
    error RoutersFacet__approveRouter_alreadyAdded();
    error RoutersFacet__approveRouter_routerEmpty();
    error RoutersFacet__initializeRouter_configNotEmpty();
    error RoutersFacet__onlyRouterOwner_notRouterOwner();
    error RoutersFacet__proposeRouterOwner_badRouter();
    error RoutersFacet__proposeRouterOwner_notNewOwner();
    error RoutersFacet__removeRouterLiquidityFor_notOwner();
    error RoutersFacet__removeRouterLiquidity_amountIsZero();
    error RoutersFacet__removeRouterLiquidity_insufficientFunds();
    error RoutersFacet__removeRouterLiquidity_recipientEmpty();
    error RoutersFacet__setLiquidityFeeNumerator_tooLarge();
    error RoutersFacet__setLiquidityFeeNumerator_tooSmall();
    error RoutersFacet__setMaxRoutersPerTransfer_invalidMaxRoutersPerTransfer();
    error RoutersFacet__setRouterOwner_noChange();
    error RoutersFacet__setRouterRecipient_notNewRecipient();
    error RoutersFacet__unapproveRouterForPortal_notApproved();
    error RoutersFacet__unapproveRouter_notAdded();
    error RoutersFacet__unapproveRouter_routerEmpty();

    event LiquidityFeeNumeratorUpdated(
        uint256 liquidityFeeNumerator,
        address caller
    );
    event MaxRoutersPerTransferUpdated(
        uint256 maxRoutersPerTransfer,
        address caller
    );
    event RouterAdded(address indexed router, address caller);
    event RouterApprovedForPortal(address router, address caller);
    event RouterInitialized(address indexed router);
    event RouterLiquidityAdded(
        address indexed router,
        address local,
        bytes32 key,
        uint256 amount,
        address caller
    );
    event RouterLiquidityRemoved(
        address indexed router,
        address to,
        address local,
        bytes32 key,
        uint256 amount,
        address caller
    );
    event RouterOwnerAccepted(
        address indexed router,
        address indexed prevOwner,
        address indexed newOwner
    );
    event RouterOwnerProposed(
        address indexed router,
        address indexed prevProposed,
        address indexed newProposed
    );
    event RouterRecipientSet(
        address indexed router,
        address indexed prevRecipient,
        address indexed newRecipient
    );
    event RouterRemoved(address indexed router, address caller);
    event RouterUnapprovedForPortal(address router, address caller);

    function LIQUIDITY_FEE_DENOMINATOR() external pure returns (uint256);

    function LIQUIDITY_FEE_NUMERATOR() external view returns (uint256);

    function acceptProposedRouterOwner(address _router) external;

    function addRouterLiquidity(
        uint256 _amount,
        address _local
    ) external payable;

    function addRouterLiquidityFor(
        uint256 _amount,
        address _local,
        address _router
    ) external payable;

    function approveRouter(address _router) external;

    function approveRouterForPortal(address _router) external;

    function getProposedRouterOwner(
        address _router
    ) external view returns (address);

    function getProposedRouterOwnerTimestamp(
        address _router
    ) external view returns (uint256);

    function getRouterApproval(address _router) external view returns (bool);

    function getRouterApprovalForPortal(
        address _router
    ) external view returns (bool);

    function getRouterOwner(address _router) external view returns (address);

    function getRouterRecipient(
        address _router
    ) external view returns (address);

    function initializeRouter(address _owner, address _recipient) external;

    function maxRoutersPerTransfer() external view returns (uint256);

    function proposeRouterOwner(address _router, address _proposed) external;

    function removeRouterLiquidity(
        TokenId memory _canonical,
        uint256 _amount,
        address _to
    ) external;

    function removeRouterLiquidityFor(
        TokenId memory _canonical,
        uint256 _amount,
        address _to,
        address _router
    ) external;

    function routerBalances(
        address _router,
        address _asset
    ) external view returns (uint256);

    function setLiquidityFeeNumerator(uint256 _numerator) external;

    function setMaxRoutersPerTransfer(uint256 _newMaxRouters) external;

    function setRouterRecipient(address _router, address _recipient) external;

    function unapproveRouter(address _router) external;

    function unapproveRouterForPortal(address _router) external;
}

// https://bscscan.com/address/0x9ab5f562dc2acccd1b80d6564b770786e38f0686#code
interface IStableSwapFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    error StableSwapFacet__deadlineCheck_deadlineNotMet();
    error StableSwapFacet__getSwapTokenBalance_indexOutOfRange();
    error StableSwapFacet__getSwapTokenIndex_notExist();
    error StableSwapFacet__getSwapToken_outOfRange();

    event AddLiquidity(
        bytes32 indexed key,
        address indexed provider,
        uint256[] tokenAmounts,
        uint256[] fees,
        uint256 invariant,
        uint256 lpTokenSupply
    );
    event NewAdminFee(bytes32 indexed key, uint256 newAdminFee);
    event NewSwapFee(bytes32 indexed key, uint256 newSwapFee);
    event RemoveLiquidity(
        bytes32 indexed key,
        address indexed provider,
        uint256[] tokenAmounts,
        uint256 lpTokenSupply
    );
    event RemoveLiquidityImbalance(
        bytes32 indexed key,
        address indexed provider,
        uint256[] tokenAmounts,
        uint256[] fees,
        uint256 invariant,
        uint256 lpTokenSupply
    );
    event RemoveLiquidityOne(
        bytes32 indexed key,
        address indexed provider,
        uint256 lpTokenAmount,
        uint256 lpTokenSupply,
        uint256 boughtId,
        uint256 tokensBought
    );
    event TokenSwap(
        bytes32 indexed key,
        address indexed buyer,
        uint256 tokensSold,
        uint256 tokensBought,
        uint128 soldId,
        uint128 boughtId
    );

    function addSwapLiquidity(
        bytes32 key,
        uint256[] memory amounts,
        uint256 minToMint,
        uint256 deadline
    ) external returns (uint256);

    function calculateRemoveSwapLiquidity(
        bytes32 key,
        uint256 amount
    ) external view returns (uint256[] memory);

    function calculateRemoveSwapLiquidityOneToken(
        bytes32 key,
        uint256 tokenAmount,
        uint8 tokenIndex
    ) external view returns (uint256 availableTokenAmount);

    function calculateSwap(
        bytes32 key,
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx
    ) external view returns (uint256);

    function calculateSwapTokenAmount(
        bytes32 key,
        uint256[] memory amounts,
        bool deposit
    ) external view returns (uint256);

    function getSwapA(bytes32 key) external view returns (uint256);

    function getSwapAPrecise(bytes32 key) external view returns (uint256);

    function getSwapAdminBalance(
        bytes32 key,
        uint256 index
    ) external view returns (uint256);

    function getSwapLPToken(bytes32 key) external view returns (address);

    function getSwapStorage(
        bytes32 key
    ) external view returns (SwapUtils.Swap memory);

    function getSwapToken(
        bytes32 key,
        uint8 index
    ) external view returns (address);

    function getSwapTokenBalance(
        bytes32 key,
        uint8 index
    ) external view returns (uint256);

    function getSwapTokenIndex(
        bytes32 key,
        address tokenAddress
    ) external view returns (uint8);

    function getSwapVirtualPrice(bytes32 key) external view returns (uint256);

    function removeSwapLiquidity(
        bytes32 key,
        uint256 amount,
        uint256[] memory minAmounts,
        uint256 deadline
    ) external returns (uint256[] memory);

    function removeSwapLiquidityImbalance(
        bytes32 key,
        uint256[] memory amounts,
        uint256 maxBurnAmount,
        uint256 deadline
    ) external returns (uint256);

    function removeSwapLiquidityOneToken(
        bytes32 key,
        uint256 tokenAmount,
        uint8 tokenIndex,
        uint256 minAmount,
        uint256 deadline
    ) external returns (uint256);

    function swap(
        bytes32 key,
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx,
        uint256 minDy,
        uint256 deadline
    ) external returns (uint256);

    function swapExact(
        bytes32 key,
        uint256 amountIn,
        address assetIn,
        address assetOut,
        uint256 minAmountOut,
        uint256 deadline
    ) external returns (uint256);

    function swapExactOut(
        bytes32 key,
        uint256 amountOut,
        address assetIn,
        address assetOut,
        uint256 maxAmountIn,
        uint256 deadline
    ) external returns (uint256);
}

interface SwapUtils {
    struct Swap {
        bytes32 key;
        uint256 initialA;
        uint256 futureA;
        uint256 initialATime;
        uint256 futureATime;
        uint256 swapFee;
        uint256 adminFee;
        address lpToken;
        address[] pooledTokens;
        uint256[] tokenPrecisionMultipliers;
        uint256[] balances;
        uint256[] adminFees;
        bool disabled;
        uint256 removeTime;
    }
}

// https://bscscan.com/address/0x6369f971fd1f1f230b8584151ed7747ff710cc68#code
interface ISwapAdminFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    error SwapAdminFacet__disableSwap_alreadyDisabled();
    error SwapAdminFacet__disableSwap_notInitialized();
    error SwapAdminFacet__initializeSwap_aExceedMax();
    error SwapAdminFacet__initializeSwap_adminFeeExceedMax();
    error SwapAdminFacet__initializeSwap_alreadyInitialized();
    error SwapAdminFacet__initializeSwap_decimalsMismatch();
    error SwapAdminFacet__initializeSwap_duplicateTokens();
    error SwapAdminFacet__initializeSwap_failedInitLpTokenClone();
    error SwapAdminFacet__initializeSwap_feeExceedMax();
    error SwapAdminFacet__initializeSwap_invalidPooledTokens();
    error SwapAdminFacet__initializeSwap_tokenDecimalsExceedMax();
    error SwapAdminFacet__initializeSwap_zeroTokenAddress();
    error SwapAdminFacet__removeSwap_delayNotElapsed();
    error SwapAdminFacet__removeSwap_notDisabledPool();
    error SwapAdminFacet__removeSwap_notInitialized();
    error SwapAdminFacet__updateLpTokenTarget_invalidNewAddress();

    event AdminFeesSet(
        bytes32 indexed key,
        uint256 newAdminFee,
        address caller
    );
    event AdminFeesWithdrawn(bytes32 indexed key, address caller);
    event LPTokenTargetUpdated(
        address oldAddress,
        address newAddress,
        address caller
    );
    event RampAStarted(
        bytes32 indexed key,
        uint256 futureA,
        uint256 futureTime,
        address caller
    );
    event RampAStopped(bytes32 indexed key, address caller);
    event SwapDisabled(bytes32 indexed key, address caller);
    event SwapFeesSet(bytes32 indexed key, uint256 newSwapFee, address caller);
    event SwapInitialized(
        bytes32 indexed key,
        SwapUtils.Swap swap,
        address caller
    );
    event SwapRemoved(bytes32 indexed key, address caller);

    function disableSwap(bytes32 _key) external;

    function initializeSwap(
        bytes32 _key,
        address[] memory _pooledTokens,
        uint8[] memory decimals,
        string memory lpTokenName,
        string memory lpTokenSymbol,
        uint256 _a,
        uint256 _fee,
        uint256 _adminFee
    ) external;

    function isDisabled(bytes32 key) external view returns (bool);

    function lpTokenTargetAddress() external view returns (address);

    function rampA(bytes32 key, uint256 futureA, uint256 futureTime) external;

    function removeSwap(bytes32 _key) external;

    function setSwapAdminFee(bytes32 key, uint256 newAdminFee) external;

    function setSwapFee(bytes32 key, uint256 newSwapFee) external;

    function stopRampA(bytes32 key) external;

    function updateLpTokenTarget(address newAddress) external;

    function withdrawSwapAdminFees(bytes32 key) external;
}

// https://bscscan.com/address/0x324c5834cd3bd19c4991f4fc5b3a0ff5257a692b#code
interface IDiamondCutFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    event DiamondCut(
        IDiamondCut.FacetCut[] _diamondCut,
        address _init,
        bytes _calldata
    );
    event DiamondCutProposed(
        IDiamondCut.FacetCut[] _diamondCut,
        address _init,
        bytes _calldata,
        uint256 deadline
    );
    event DiamondCutRescinded(
        IDiamondCut.FacetCut[] _diamondCut,
        address _init,
        bytes _calldata
    );

    function diamondCut(
        IDiamondCut.FacetCut[] memory _diamondCut,
        address _init,
        bytes memory _calldata
    ) external;

    function getAcceptanceTime(
        IDiamondCut.FacetCut[] memory _diamondCut,
        address _init,
        bytes memory _calldata
    ) external view returns (uint256);

    function proposeDiamondCut(
        IDiamondCut.FacetCut[] memory _diamondCut,
        address _init,
        bytes memory _calldata
    ) external;

    function rescindDiamondCut(
        IDiamondCut.FacetCut[] memory _diamondCut,
        address _init,
        bytes memory _calldata
    ) external;
}

interface IDiamondCut {
    struct FacetCut {
        address facetAddress;
        uint8 action;
        bytes4[] functionSelectors;
    }
}

// https://bscscan.com/address/0x44e799f47a5599f5c9158d1f2457e30a6d77adb4#code
interface IDiamondInit is IErrorAssetLogic, IErrorBaseConnextFacet {
    error DiamondInit__init_alreadyInitialized();
    error DiamondInit__init_domainsDontMatch();

    function init(
        uint32 _domain,
        address _xAppConnectionManager,
        uint256 _acceptanceDelay,
        address _lpTokenTargetAddress
    ) external;
}

// https://bscscan.com/address/0x3bcf4185443a339517ad4e580067f178d1b68e1d#code
interface IDiamondLoupeFacet is IErrorAssetLogic, IErrorBaseConnextFacet {
    function facetAddress(
        bytes4 _functionSelector
    ) external view returns (address facetAddress_);

    function facetAddresses()
        external
        view
        returns (address[] memory facetAddresses_);

    function facetFunctionSelectors(
        address _facet
    ) external view returns (bytes4[] memory facetFunctionSelectors_);

    function facets()
        external
        view
        returns (IDiamondLoupe.Facet[] memory facets_);

    function supportsInterface(
        bytes4 _interfaceId
    ) external view returns (bool);
}

interface IDiamondLoupe {
    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }
}

interface IConnextDiamond_Proxy is
    ITokenFacet,
    IBridgeFacet,
    IInboxFacet,
    IProposedOwnableFacet,
    IPortalFacet,
    IRelayerFacet,
    IRoutersFacet,
    IStableSwapFacet,
    ISwapAdminFacet,
    IDiamondCutFacet,
    IDiamondInit,
    IDiamondLoupeFacet
{
    fallback() external payable;

    receive() external payable;
}

// The following structure is built-in interface
interface IConnextDiamond {
    struct Initialization {
        address initContract;
        bytes initData;
    }
}

interface IReceiver {
    event AmarokRouterSet(address indexed router);
    event ExecutorSet(address indexed executor);
    event LiFiTransferCompleted(
        bytes32 indexed transactionId,
        address receivingAssetId,
        address receiver,
        uint256 amount,
        uint256 timestamp
    );
    event LiFiTransferRecovered(
        bytes32 indexed transactionId,
        address receivingAssetId,
        address receiver,
        uint256 amount,
        uint256 timestamp
    );
    event LiFiTransferStarted(ILiFi.BridgeData bridgeData);
    event OwnershipTransferRequested(
        address indexed _from,
        address indexed _to
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event RecoverGasSet(uint256 indexed recoverGas);
    event StargateRouterSet(address indexed router);

    function amarokRouter() external view returns (address);

    function cancelOwnershipTransfer() external;

    function confirmOwnershipTransfer() external;

    function executor() external view returns (address);

    function owner() external view returns (address);

    function pendingOwner() external view returns (address);

    function pullToken(
        address assetId,
        address receiver,
        uint256 amount
    ) external;

    function recoverGas() external view returns (uint256);

    function setAmarokRouter(address _amarokRouter) external;

    function setExecutor(address _executor) external;

    function setRecoverGas(uint256 _recoverGas) external;

    function setStargateRouter(address _sgRouter) external;

    function sgReceive(
        uint16,
        bytes memory,
        uint256,
        address _token,
        uint256 _amountLD,
        bytes memory _payload
    ) external;

    function sgRouter() external view returns (address);

    function swapAndCompleteBridgeTokens(
        bytes32 _transactionId,
        LibSwap.SwapData[] memory _swapData,
        address assetId,
        address receiver
    ) external payable;

    function transferOwnership(address _newOwner) external;

    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address,
        uint32,
        bytes memory _callData
    ) external;

    receive() external payable;
}

interface ILiFi {
    struct BridgeData {
        bytes32 transactionId;
        string bridge;
        string integrator;
        address referrer;
        address sendingAssetId;
        address receiver;
        uint256 minAmount;
        uint256 destinationChainId;
        bool hasSourceSwaps;
        bool hasDestinationCall;
    }
}

interface LibSwap {
    struct SwapData {
        address callTo;
        address approveTo;
        address sendingAssetId;
        address receivingAssetId;
        uint256 fromAmount;
        bytes callData;
        bool requiresDeposit;
    }
}

interface IExecutor {
    event ERC20ProxySet(address indexed proxy);
    event LiFiTransferCompleted(
        bytes32 indexed transactionId,
        address receivingAssetId,
        address receiver,
        uint256 amount,
        uint256 timestamp
    );
    event LiFiTransferStarted(ILiFi.BridgeData bridgeData);
    event OwnershipTransferRequested(
        address indexed _from,
        address indexed _to
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function cancelOwnershipTransfer() external;

    function confirmOwnershipTransfer() external;

    function erc20Proxy() external view returns (address);

    function owner() external view returns (address);

    function pendingOwner() external view returns (address);

    function setERC20Proxy(address _erc20Proxy) external;

    function swapAndCompleteBridgeTokens(
        bytes32 _transactionId,
        LibSwap.SwapData[] memory _swapData,
        address _transferredAssetId,
        address _receiver
    ) external payable;

    function swapAndExecute(
        bytes32 _transactionId,
        LibSwap.SwapData[] memory _swapData,
        address _transferredAssetId,
        address _receiver,
        uint256 _amount
    ) external payable;

    function transferOwnership(address _newOwner) external;

    receive() external payable;
}
