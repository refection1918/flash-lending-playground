// https://bscscan.com/address/0xd9CAc3D964327e47399aebd8e1e6dCC4c251DaAE#code
interface IDPPFactory {
    event NewDPP(
        address baseToken,
        address quoteToken,
        address creator,
        address dpp
    );
    event OwnershipTransferPrepared(
        address indexed previousOwner,
        address indexed newOwner
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event RemoveDPP(address dpp);
    event addAdmin(address admin);
    event removeAdmin(address admin);

    function _CLONE_FACTORY_() external view returns (address);

    function _DEFAULT_MAINTAINER_() external view returns (address);

    function _DEFAULT_MT_FEE_RATE_MODEL_() external view returns (address);

    function _DODO_APPROVE_PROXY_() external view returns (address);

    function _DPP_ADMIN_TEMPLATE_() external view returns (address);

    function _DPP_TEMPLATE_() external view returns (address);

    function _NEW_OWNER_() external view returns (address);

    function _OWNER_() external view returns (address);

    function _REGISTRY_(
        address,
        address,
        uint256
    ) external view returns (address);

    function _USER_REGISTRY_(address, uint256) external view returns (address);

    function addAdminList(address contractAddr) external;

    function addPoolByAdmin(
        address creator,
        address baseToken,
        address quoteToken,
        address pool
    ) external;

    function batchAddPoolByAdmin(
        address[] memory creators,
        address[] memory baseTokens,
        address[] memory quoteTokens,
        address[] memory pools
    ) external;

    function claimOwnership() external;

    function createDODOPrivatePool() external returns (address newPrivatePool);

    function getDODOPool(
        address baseToken,
        address quoteToken
    ) external view returns (address[] memory pools);

    function getDODOPoolBidirection(
        address token0,
        address token1
    )
        external
        view
        returns (
            address[] memory baseToken0Pool,
            address[] memory baseToken1Pool
        );

    function getDODOPoolByUser(
        address user
    ) external view returns (address[] memory pools);

    function initDODOPrivatePool(
        address dppAddress,
        address creator,
        address baseToken,
        address quoteToken,
        uint256 lpFeeRate,
        uint256 k,
        uint256 i,
        bool isOpenTwap
    ) external;

    function initOwner(address newOwner) external;

    function isAdminListed(address) external view returns (bool);

    function removeAdminList(address contractAddr) external;

    function removePoolByAdmin(
        address creator,
        address baseToken,
        address quoteToken,
        address pool
    ) external;

    function transferOwnership(address newOwner) external;

    function updateAdminTemplate(address _newDPPAdminTemplate) external;

    function updateDefaultMaintainer(address _newMaintainer) external;

    function updateDppTemplate(address _newDPPTemplate) external;
}

// https://bscscan.com/address/0x790B4A80Fb1094589A3c0eFC8740aA9b0C1733fB#code
interface IDVMFactory {
    event NewDVM(
        address baseToken,
        address quoteToken,
        address creator,
        address dvm
    );
    event OwnershipTransferPrepared(
        address indexed previousOwner,
        address indexed newOwner
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event RemoveDVM(address dvm);

    function _CLONE_FACTORY_() external view returns (address);

    function _DEFAULT_MAINTAINER_() external view returns (address);

    function _DEFAULT_MT_FEE_RATE_MODEL_() external view returns (address);

    function _DVM_TEMPLATE_() external view returns (address);

    function _NEW_OWNER_() external view returns (address);

    function _OWNER_() external view returns (address);

    function _REGISTRY_(
        address,
        address,
        uint256
    ) external view returns (address);

    function _USER_REGISTRY_(address, uint256) external view returns (address);

    function addPoolByAdmin(
        address creator,
        address baseToken,
        address quoteToken,
        address pool
    ) external;

    function claimOwnership() external;

    function createDODOVendingMachine(
        address baseToken,
        address quoteToken,
        uint256 lpFeeRate,
        uint256 i,
        uint256 k,
        bool isOpenTWAP
    ) external returns (address newVendingMachine);

    function getDODOPool(
        address baseToken,
        address quoteToken
    ) external view returns (address[] memory machines);

    function getDODOPoolBidirection(
        address token0,
        address token1
    )
        external
        view
        returns (
            address[] memory baseToken0Machines,
            address[] memory baseToken1Machines
        );

    function getDODOPoolByUser(
        address user
    ) external view returns (address[] memory machines);

    function initOwner(address newOwner) external;

    function removePoolByAdmin(
        address creator,
        address baseToken,
        address quoteToken,
        address pool
    ) external;

    function transferOwnership(address newOwner) external;

    function updateDvmTemplate(address _newDVMTemplate) external;
}

interface DVM {
    function flashLoan(
        uint256 baseAmount,
        uint256 quoteAmount,
        address assetTo,
        bytes calldata data
    ) external;

    function init(
        address maintainer,
        address baseTokenAddress,
        address quoteTokenAddress,
        uint256 lpFeeRate,
        address mtFeeRateModel,
        uint256 i,
        uint256 k,
        bool isOpenTWAP
    ) external;

    function _BASE_TOKEN_() external returns (address);

    function _QUOTE_TOKEN_() external returns (address);
}
