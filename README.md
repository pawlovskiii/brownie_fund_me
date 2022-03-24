# Working with Brownie within FundMe contract

## Table of contents

- [General info](#general-info)
- [Learned experience during the project](#learned-experience-during-the-project)
- [Setup](#setup)
  - [Additional file for environment variables](#additional-file-for-environment-variables)
  - [Installing dependencies](#installing-dependencies)
  - [Available commands for the project](#available-commands-for-the-project)

## General info

The project is about making the first steps into Brownie, one of the most popular smart contract development platforms build based on Python. It's my approach to understand basic aspects of it using the FundMe contract as an example. Previously I worked with Web3.py, which gave me experience on some of the aspects that brownie does under the hood.

## Learned experience during the project

### Brownie vs Web3.py

- In Web3.py we needed to write our code compiler. If we wanted to interact with one of the contracts that we deployed in the past, we'd have to keep track of all those addresses and manually update our address features.
- Within Brownie, we don't need to deploy a new contract every single time. We could work with a contract that we've already deployed. It's much easier to work with a whole bunch of different chains. We can quite easily work with Rinkeby TestNet or Mainnet (fork) on our local network.
- Brownie also makes a great testing environment.

All in all, it was crucial to work with Web3.py, to experience the low-level stuff that Brownie does for us.

### FundMe contract

This contract was designed to be able to accept some type of payment -> specifically, payable with ETH.

#### Keywords:

- **msg.sender**

- **payable**

  When we define function as **payable**, we're saying this function can be used to pay for things. In this case, returning all the money on the contract to its creator.

  ```bash
  function withdraw() public payable onlyOwner {
  	// only want the contract admin/owner
  	msg.sender.transfer(address(this).balance);
  	for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
  		address funder = funders[funderIndex];
  		addressToAmountFunded[funder] = 0;
  	}
  	funders = new address[](0);
  }
  ```

- **msg.value**

- **constructor**

- **modifier**

#### interfaces

#### Decimals in Solidity

#### Getting external data with Chainlink

- **oracles**

#### Math in Solidity

## Setup

There are three different ways of working with this project and each way requires a different approach with certain things like changing public/private keys.

1. Using [Ganache](https://trufflesuite.com/ganache/index.html)
2. Using [ganache-cli](https://www.npmjs.com/package/ganache-cli)
3. Using TestNet (e.g Rinkeby)

Ganache and ganache-cli are quite similar. The difference is that in ganache-cli you're using a command-line instead of the desktop app.

### Additional file for environment variables

You must create a file named **.env** to put there your environment variables (no matter, which way above you choose).

1. Also if you prefer working with TestNet I suggest using [MetaMask](https://metamask.io/), after creating the wallet, go straight to the account and export the private key. It has to be in hexadecimal version, so we put **0x** at the beginning (only when you use TestNet, in ganache is right away, so check it carefully).

```
export PRIVATE_KEY=0x...
```

2. Firstly you need an account on [Infura](https://infura.io/). After that, you create a new project and type its ID.

```
export WEB3_INFURA_PROJECT_ID=...
```

3. Make an account on [Etherscan](https://etherscan.io/). Next, go to **API Keys** and add a new one.

```
export ETHERSCAN_TOKEN=...
```

### Installing dependencies

To clone and run this application, you'll need [Git](https://git-scm.com) and [Node.js](https://nodejs.org/en/download/) (which comes with [npm](http://npmjs.com)) installed on your computer. In this case, Node.js is only needed for installing a prettier-plugin for Solidity. Furthermore, you'll have to download [Python](https://www.python.org/downloads/) 3.6+ version to install all the required packages via pip. From your command line:

```bash
# Clone this repository
$ git clone https://github.com/pawlovskiii/brownie_fund_me

# Go into the repository
$ cd brownie_fund_me

# Install brownie

# Install ganache-cli
$ npm install -g ganache-cli

# Install dependencies
$ npm install
```

### Available commands for the project

```bash
$ brownie run .\scripts\fund_and_withdraw.py --network ganache-local

$ brownie run .\scripts\deploy.py --network mainnet-fork-dev

$ brownie test -k test_only_owner_can_withdraw --network rinkeby

$ brownie test -k test_only_owner_can_withdraw --network development

$ brownie test --network mainnet-fork-dev
```

### Other useful Brownie commands

```bash
# to create a sample folder with everything we need with Brownie
$ brownie init

$ brownie compile

$ brownie networks list

$ brownie console

$ brownie test

$ brownie pm list
```
