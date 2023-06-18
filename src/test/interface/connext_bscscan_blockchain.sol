// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IDiamondLoupeFacet {
    function facetAddress(bytes4 _functionSelector)
        external
        view
        returns (address facetAddress_);

    function facetAddresses()
        external
        view
        returns (address[] memory facetAddresses_);

    function facetFunctionSelectors(address _facet)
        external
        view
        returns (bytes4[] memory facetFunctionSelectors_);

    function facets()
        external
        view
        returns (IDiamondLoupe.Facet[] memory facets_);

    function supportsInterface(bytes4 _interfaceId)
        external
        view
        returns (bool);
}

interface IDiamondLoupe {
    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }
}

interface IDiamondCut {
    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }
    // Add=0, Replace=1, Remove=2

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    /// @notice Propose to add/replace/remove any number of functions and optionally execute
    ///         a function with delegatecall
    /// @param _diamondCut Contains the facet addresses and function selectors
    /// @param _init The address of the contract or facet to execute _calldata
    /// @param _calldata A function call, including function selector and arguments
    ///                  _calldata is executed with delegatecall on _init
    function proposeDiamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;

    event DiamondCutProposed(FacetCut[] _diamondCut, address _init, bytes _calldata, uint256 deadline);

    /// @notice Add/replace/remove any number of functions and optionally execute
    ///         a function with delegatecall
    /// @param _diamondCut Contains the facet addresses and function selectors
    /// @param _init The address of the contract or facet to execute _calldata
    /// @param _calldata A function call, including function selector and arguments
    ///                  _calldata is executed with delegatecall on _init
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;

    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);

    /// @notice Propose to add/replace/remove any number of functions and optionally execute
    ///         a function with delegatecall
    /// @param _diamondCut Contains the facet addresses and function selectors
    /// @param _init The address of the contract or facet to execute _calldata
    /// @param _calldata A function call, including function selector and arguments
    ///                  _calldata is executed with delegatecall on _init
    function rescindDiamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;

    /**
    * @notice Returns the acceptance time for a given proposal
    * @param _diamondCut Contains the facet addresses and function selectors
    * @param _init The address of the contract or facet to execute _calldata
    * @param _calldata A function call, including function selector and arguments _calldata is
    * executed with delegatecall on _init
    */
    function getAcceptanceTime(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external returns (uint256);

    event DiamondCutRescinded(FacetCut[] _diamondCut, address _init, bytes _calldata);
}

interface IBridgeFacet {
    error AssetLogic__getConfig_notRegistered();
    error AssetLogic__getTokenIndexFromStableSwapPool_notExist();
    error AssetLogic__handleIncomingAsset_feeOnTransferNotSupported();
    error AssetLogic__handleIncomingAsset_nativeAssetNotSupported();
    error AssetLogic__handleOutgoingAsset_notNative();
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

    function approvedSequencers(address _sequencer)
        external
        view
        returns (bool);

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

    function forceUpdateSlippage(TransferInfo memory _params, uint256 _slippage)
        external;

    function nonce() external view returns (uint256);

    function remote(uint32 _domain) external view returns (address);

    function removeSequencer(address _sequencer) external;

    function routedTransfers(bytes32 _transferId)
        external
        view
        returns (address[] memory);

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


interface IConnextDiamond_Proxy is IDiamondLoupeFacet, IBridgeFacet, IDiamondCut {
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


interface IStableSwapFacet {
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

    function calculateRemoveSwapLiquidity(bytes32 key, uint256 amount)
        external
        view
        returns (uint256[] memory);

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

    function getSwapAdminBalance(bytes32 key, uint256 index)
        external
        view
        returns (uint256);

    function getSwapLPToken(bytes32 key) external view returns (address);

    function getSwapStorage(bytes32 key)
        external
        view
        returns (SwapUtils.Swap memory);

    function getSwapToken(bytes32 key, uint8 index)
        external
        view
        returns (address);

    function getSwapTokenBalance(bytes32 key, uint8 index)
        external
        view
        returns (uint256);

    function getSwapTokenIndex(bytes32 key, address tokenAddress)
        external
        view
        returns (uint8);

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
