// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "interface/ethereum_blockchain.sol";

interface IFiatTokenV2_1 is IERC20 {
    event AuthorizationCanceled(
        address indexed authorizer,
        bytes32 indexed nonce
    );
    event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
    event Blacklisted(address indexed _account);
    event BlacklisterChanged(address indexed newBlacklister);
    event Burn(address indexed burner, uint256 amount);
    event MasterMinterChanged(address indexed newMasterMinter);
    event Mint(address indexed minter, address indexed to, uint256 amount);
    event MinterConfigured(address indexed minter, uint256 minterAllowedAmount);
    event MinterRemoved(address indexed oldMinter);
    event OwnershipTransferred(address previousOwner, address newOwner);
    event Pause();
    event PauserChanged(address indexed newAddress);
    event RescuerChanged(address indexed newRescuer);
    event UnBlacklisted(address indexed _account);
    event Unpause();

    function CANCEL_AUTHORIZATION_TYPEHASH() external view returns (bytes32);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external view returns (bytes32);

    function RECEIVE_WITH_AUTHORIZATION_TYPEHASH()
        external
        view
        returns (bytes32);

    function TRANSFER_WITH_AUTHORIZATION_TYPEHASH()
        external
        view
        returns (bytes32);

    function authorizationState(address authorizer, bytes32 nonce)
        external
        view
        returns (bool);

    function blacklist(address _account) external;

    function blacklister() external view returns (address);

    function burn(uint256 _amount) external;

    function cancelAuthorization(
        address authorizer,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function configureMinter(address minter, uint256 minterAllowedAmount)
        external
        returns (bool);

    function currency() external view returns (string memory);

    function decreaseAllowance(address spender, uint256 decrement)
        external
        returns (bool);

    function increaseAllowance(address spender, uint256 increment)
        external
        returns (bool);

    function initialize(
        string memory tokenName,
        string memory tokenSymbol,
        string memory tokenCurrency,
        uint8 tokenDecimals,
        address newMasterMinter,
        address newPauser,
        address newBlacklister,
        address newOwner
    ) external;

    function initializeV2(string memory newName) external;

    function initializeV2_1(address lostAndFound) external;

    function isBlacklisted(address _account) external view returns (bool);

    function isMinter(address account) external view returns (bool);

    function masterMinter() external view returns (address);

    function mint(address _to, uint256 _amount) external returns (bool);

    function minterAllowance(address minter) external view returns (uint256);

    function nonces(address owner) external view returns (uint256);

    function pause() external;

    function paused() external view returns (bool);

    function pauser() external view returns (address);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function receiveWithAuthorization(
        address from,
        address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function removeMinter(address minter) external returns (bool);

    function rescueERC20(
        address tokenContract,
        address to,
        uint256 amount
    ) external;

    function rescuer() external view returns (address);

    function transferOwnership(address newOwner) external;

    function transferWithAuthorization(
        address from,
        address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function unBlacklist(address _account) external;

    function unpause() external;

    function updateBlacklister(address _newBlacklister) external;

    function updateMasterMinter(address _newMasterMinter) external;

    function updatePauser(address _newPauser) external;

    function updateRescuer(address newRescuer) external;

    function version() external view returns (string memory);
}


interface ITetherToken is IERC20 {
    function deprecate(address _upgradedAddress) external;

    function deprecated() external view returns (bool);

    function addBlackList(address _evilUser) external;

    function upgradedAddress() external view returns (address);

    function balances(address) external view returns (uint256);

    function maximumFee() external view returns (uint256);

    function _totalSupply() external view returns (uint256);

    function unpause() external;

    function getBlackListStatus(address _maker) external view returns (bool);

    function allowed(address, address) external view returns (uint256);

    function paused() external view returns (bool);

    function pause() external;

    function getOwner() external view returns (address);

    function setParams(uint256 newBasisPoints, uint256 newMaxFee) external;

    function issue(uint256 amount) external;

    function redeem(uint256 amount) external;

    function basisPointsRate() external view returns (uint256);

    function isBlackListed(address) external view returns (bool);

    function removeBlackList(address _clearedUser) external;

    function MAX_UINT() external view returns (uint256);

    function transferOwnership(address newOwner) external;

    function destroyBlackFunds(address _blackListedUser) external;

    event Issue(uint256 amount);
    event Redeem(uint256 amount);
    event Deprecate(address newAddress);
    event Params(uint256 feeBasisPoints, uint256 maxFee);
    event DestroyedBlackFunds(address _blackListedUser, uint256 _balance);
    event AddedBlackList(address _user);
    event RemovedBlackList(address _user);
    event Pause();
    event Unpause();
}


interface IWBTC is IERC20 {
    event Pause();
    event Unpause();
    event Burn(address indexed burner, uint256 value);
    event Mint(address indexed to, uint256 amount);
    event MintFinished();
    event OwnershipRenounced(address indexed previousOwner);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function mintingFinished() external view returns (bool);

    function reclaimToken(address _token) external;

    function unpause() external;

    function mint(address _to, uint256 _amount) external returns (bool);

    function burn(uint256 value) external;

    function claimOwnership() external;

    function paused() external view returns (bool);

    function decreaseApproval(address _spender, uint256 _subtractedValue)
        external
        returns (bool success);

    function renounceOwnership() external;

    function finishMinting() external returns (bool);

    function pause() external;

    function increaseApproval(address _spender, uint256 _addedValue)
        external
        returns (bool success);

    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256);

    function pendingOwner() external view returns (address);

    function transferOwnership(address newOwner) external;
}


interface IDAI is IERC20 {
    event LogNote(
        bytes4 indexed sig,
        address indexed usr,
        bytes32 indexed arg1,
        bytes32 indexed arg2,
        bytes data
    ) anonymous;

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external view returns (bytes32);

    function burn(address usr, uint256 wad) external;

    function deny(address guy) external;

    function mint(address usr, uint256 wad) external;

    function move(
        address src,
        address dst,
        uint256 wad
    ) external;

    function nonces(address) external view returns (uint256);

    function permit(
        address holder,
        address spender,
        uint256 nonce,
        uint256 expiry,
        bool allowed,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function pull(address usr, uint256 wad) external;

    function push(address usr, uint256 wad) external;

    function rely(address guy) external;

    function version() external view returns (string memory);

    function wards(address) external view returns (uint256);
}
