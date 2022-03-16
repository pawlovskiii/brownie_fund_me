# Working with Brownie within FundMe contract

## Table of contents

- [General info](#general-info)
- [Learned experience during the project](#learned-experience-during-the-project)
- [Setup](#setup)

### General info

I wanted to work with Brownie, one of the most popular smart contract development platform built based on Python. Previously I worked with Web3.py, which gave me experience on all the aspects that brownie does under the hood.

### Learned experience during the project

#### 1. Brownie vs Web3.py

- In Web3.py we needed to write our own compile code. If we wanted to interact with one of the contracts that we deployed in the past, we'd have to keep track of all those addresses and manually update our address features.
- Within Brownie we don't need to deploy a new contract every single time. We could work with a contract that we've already deployed. It's much easier to work with a whole bunch of different chains. We can quite easily work with Rinkeby TestNet and Mainnet (fork) on our own local network.
- Brownie also makes great testing environment.
  All in all it was crucial to work with Web3.py, to experience low-level stuff that Brownie does for us.

#### 2. FundMe contract

This contract was designed to be able to accept some type of payment -> specifically, payable with ETH.

### Setup

There's three different ways of working with this project and each way require different approach with certain things like changing public/private keys.

1. Using [Ganache](https://trufflesuite.com/ganache/index.html)
2. Using [ganache-cli](https://www.npmjs.com/package/ganache-cli)
3. Using TestNet (e.g Rinkeby)

Ganache and ganache-cli are quite similar. The difference is that in ganache-cli you're using command line instead of desktop app.

#### Additional file for environment variables

You must create file named **.env** in order to put there your environment variables (no matter, which way above you choose).

1. Also if you prefer working with TestNet I suggest to use [MetaMask](https://metamask.io/), after creating wallet, go straight to the account and export private key. It has to be in hexadecimal version, so we put **0x** at the beginning (only when you use TestNet, in ganache is right away, so check it carefully).

```
export PRIVATE_KEY=0x...
```

2. Firstly you need an account on [Infura](https://infura.io/). After that you create new project and type it's ID.

```
export WEB3_INFURA_PROJECT_ID=...
```

3. Make an account on [Etherscan](https://etherscan.io/). Next go to **API Keys** and add new one.

```
export ETHERSCAN_TOKEN=...
```

#### Suggested commands to work with this project

```bash
$ brownie run .\scripts\fund_and_withdraw.py --network ganache-local

$ brownie run .\scripts\deploy.py --network mainnet-fork-dev

$ brownie test -k test_only_owner_can_withdraw --network rinkeby

$ brownie test -k test_only_owner_can_withdraw --network development

$ brownie test --network mainnet-fork-dev
```

#### Other useful Brownie commands

```bash
# to create a sample folder with everything we need with Brownie
$ brownie init

$ brownie compile

$ brownie networks list

$ brownie console

$ brownie test

$ brownie pm list
```
