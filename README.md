# Working with Brownie within FundMe contract

## Table of contents

- [General info](#general-info)
- [Learned experience during the project](#learned-experience-during-the-project)
  - [Brownie vs Web3](#brownie-vs-web3)
  - [FundMe contract](#fundme-contract)
    - [Keywords](#keywords)
    - [msg.sender | msg.value](#msgsender--msgvalue)
    - [Withdraw money from the contract](#withdraw-money-from-the-contract)
    - [Withdraw money from the contract as an admin](#withdraw-money-from-the-contract-as-an-admin)
    - [interface](#interface)
    - [Getting external data with Chainlink](#getting-external-data-with-chainlink)
    - [Decimals in Solidity](#decimals-in-solidity)
    - [Integer Overflow - SafeMath](#integer-overflow---safemath)
- [Setup](#setup)
  - [Additional file for environment variables](#additional-file-for-environment-variables)
  - [Installing dependencies](#installing-dependencies)
  - [Available commands for the project](#available-commands-for-the-project)

## General info

The project is about making the first steps into Brownie, one of the most popular smart contract development platforms build based on Python. It's my approach to understand basic aspects of it using the FundMe contract as an example. Previously I worked with Web3.py, which gave me experience on some of the aspects that brownie does under the hood.

## Learned experience during the project

### Brownie vs Web3

- In Web3.py we needed to write our code compiler. If we wanted to interact with one of the contracts that we deployed in the past, we'd have to keep track of all those addresses and manually update our address features.
- Within Brownie, we don't need to deploy a new contract every single time. We could work with a contract that we've already deployed. It's much easier to work with a whole bunch of different chains. We can quite easily work with Rinkeby TestNet or Mainnet (fork) on our local network.
- Brownie also makes a great testing environment.

All in all, it was crucial to work with Web3.py, to experience the low-level stuff that Brownie does for us.

### FundMe contract

This contract was designed to be able to accept some type of payment -> specifically, payable with ETH.

#### Keywords:

- **payable**

  When we define function as **payable**, we're saying this function can be used to pay for things. In this case, returning all the money on the contract to its creator.

  ```js
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

- **require()**

  When a _function call_ (i.e. _transaction_) reaches a **require** statement, it'll check the truthiness of whatever requires you've asked.

  The line with the **require** statement says that if they didn't send us enough ether, then we're going to stop executing. We're going to do what's called a **revert** (simply **revert** the _transaction_). We can also add a **revert error message**.

  This means that the user is going to get their money back as well as any unspent gas.

  ```js
  mapping(address => uint256) public addressToAmountFunded;

  function fund() public payable {
          // 50$
          uint256 minimumUSD = 50 * 10 ** 18;
          require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");

          addressToAmountFunded[msg.sender] += msg.value;
          // what the ETH -> USD conversion rate
  }
  ```

- **constructor**

  At the top of our smart contract we're typically gonna see a **constructor** and this is a function that gets called the instant that our contract gets deployed.

  Whatever we add in here will be immediately executed whenever we deploy this contract.

  We could have a function, but what happens if somebody calls this function right after we deploy it? Well, then we wouldn't be the owner anymore.

  ```js
  address public owner;

  constructor() public {
          owner = msg.sender; // person who deploys the contract
  }

  function withdraw() payable public {
          // only want the contract admin/owner
          require(msg.sender == owner);
          msg.sender.transfer(address(this).balance);
  }
  ```

- **modifier**

  We can use a **modifier** to write in the additional definition for our function. A **modifier** is used to change the behavior of a function in a declarative way.

  Add some parameter that allows it to only be called by our admin contract creator (do **require** statement first). Then whenever **underscore** is in the **modifier**, run the rest of the code from certain function (in this case **withdraw()**).

  **modifier** is going to be executed before we run **withdraw()** function.

  ```js
  modifier onlyOwner {
          require(msg.sender == owner, "You are not the owner of the contract!");
          _;
  }

  function withdraw() payable onlyOwner public {
          // only want the contract admin/owner
          msg.sender.transfer(address(this).balance);
  }
  ```

#### msg.sender | msg.value

These are keywords in every _contract call_ and every _transaction_.

- **msg.sender** is the sender of the _function call_ i.e. _transaction_

- **msg.value** is how much they sent

So whenever we call _fund()_, somebody can send some value, because it's **payable** and we're going to save everything in this _addressToAmountFunded_ mapping.

```js
mapping(address => uint256) public addressToAmountFunded;
function fund() public payable {
        addressToAmountFunded[msg.sender] += msg.value;
    }
```

#### Withdraw money from the contract

Discussed keywords:

- transfer()
- this
- balance

Is a function that we can call on any address to send eth from one address to another. This **transfer()** function sends some amount of ether to whoever it's being called on.

In this case, we're transferring ether to _msg.sender_, so all we need to do is define how much we want to send. We're going to send all the money that's been funded.

Whenever you refer to **this**, you're talking about the contract that you're currently in. When we add **address(this)**, we're saying we want the address of the contract that we're currently in.

Whenever you call an address and then the **.balance** attribute, you can see the balance in the ether of a contract so with that line, we're saying whoever called the **withdraw** function because whoever calls the function is going to be **msg.sender** (will get transfer all of our money from the contract).

```js
function withdraw() payable public {
        msg.sender.transfer(address(this).balance);
}
```

#### Withdraw money from the contract as an admin

We want to set it up in a way that only the contract owner (creator) can withdraw funds. With help of the **require()** keyword, which can stop contracts from executing unless certain parameters are met.

The only thing we're missing is when we withdraw from this contract. We're not updating our balances of people who funded this. So even after we withdraw, this is always going to be the same. So we have to go through all the **funders** and reset their balances to zero.

```js
mapping(address => uint256) public addressToAmountFunded;
address[] public funders;
address public owner;

modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner of the contract!");
        _;
}

function withdraw() payable onlyOwner public {
        // only want the contract admin/owner
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
}
```

#### interface

These contracts don't start with the _contract_ keyword, but with the **interface** keyword. They have some similarities, but the main difference is that their functions aren't completed.

They just have the function name and its return type.

```bash
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);
  ...
}
```

**interfaces** don't have full function implementations.

**interfaces** compile down to an **ABI** - Application Binary Interface

- The **ABI** tells Solidity and other programming languages how it can interact with another contract.
- Anytime you want to interact with an already deployed smart contract you'll need an **ABI**.

#### Getting external data with Chainlink

Chainlink uses _oracles_, which deliver data to the _Layer 1_ blockchain. They're distributed in a decentralized way, where we get data from different sources.

In the case of the price we measure it like:

- The sum of the price from different channels divide by the number of

We have to work on _TestNet_ with Chainlink because there are no chainlink nodes on simulated JavaScript VMs (like in Remix IDE).

#### Decimals in Solidity

- Decimals don't work in Solidity, so we have to return a value that's multiplied by 10 to some number.

#### Integer Overflow - SafeMath

Integers can wrap around once you reach their maximum capacity. They reset. This is something we need to watch out for when working with Solidity.

We must especially be careful when doing multiplication on really big numbers (we can accidentally pass this cap).

```js
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6 <0.9.0;

contract Overflow {

    function overflow() public view returns(uint8) {
        uint8 big = 255 + uint8(50);
        return big; // 49
    }
}
```

As a version **0.8** of Solidity, it checks for overflow and it defaults to check for overflow to increase the readability of code even if that comes a slight increase of the gas cost.

If you're using anything less than **0.8** you're going to want to use some type of **SafeMath**, just to check for your **overflows**. It'll use **SafeMathChainlink** for all of our **uint256**. It doesn't allow for that **overflow** to occur.

```java
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;

    ...
}
```

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

# Install ganache-cli
$ npm install -g ganache-cli

# Install dependencies
$ npm install
```

Brownie installation might give you a little headache but I will give you a whole recipe to go through this process stressless. I found this [thread](https://stackoverflow.com/questions/69679343/pipx-failed-to-build-packages) very helpful. 

```bash
$ pip install cython

$ pip install eth-brownie
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
