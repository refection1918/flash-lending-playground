## This repository is inspired by: [DeFiHackLabs](https://github.com/SunWeb3Sec/DeFiHackLabs)

## Getting Started

-   Follow the [instructions](https://book.getfoundry.sh/getting-started/installation.html) to install [Foundry](https://github.com/foundry-rs/foundry).

-   Update Foundry

```sh
foundryup
```

-   Clone and install dependencies:

```sh
git submodule update --init --recursive
```

Sample Sanity Run

```sh
forge test --contracts ./src/test/template/cronos_vvs.sol -vv
forge test --contracts ./src/test/template/dodo_bsc.sol -vv
```

### (Optional) Steps during Initial Bring Up

```sh
git submodule add https://github.com/brockelmore/forge-std lib/forge-std
git submodule add https://github.com/OpenZeppelin/openzeppelin-contracts lib/openzeppelin/contracts
```

### (Optional) Steps to remove git submodule directories

```sh
git submodule deinit --all -f
```
