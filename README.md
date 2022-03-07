# FundMe contract with Brownie 
I wanted to work with Brownie, one of the most popular smart contract development platform built based on Python. Previously I worked with Web3.py, which gave me experience on all the aspects that brownie does under the hood.

## Brownie vs Web3.py
- In Web3.py we needed to write our own compile code. If we wanted to interact with one of the contracts that we deployed in the past, we'd have to keep track of all those addresses and manually update our address features. 
- Within Brownie we don't need to deploy a new contract every single time. We could work with a contract that we've already deployed. It's much easier to work with a whole bunch of different chains. We can quite easily work with Rinkeby TestNet and Mainnet (fork) on our own local network.
- Brownie also makes great testing environment.
All in all it was crucial to work with Web3.py, to experience low-level stuff that Brownie does for us.

## FundMe 
This contract was designed to be able to accept some type of payment -> specifically, payable with ETH.

### Missing .env file
In this file I created three environment variables:
1. PRIVATE_KEY - just go to your MetaMask account and export private key 
2. WEB3_INFURA_PROJECT_ID - create project on infura.io
3. ETHERSCAN_TOKEN - create app on etherscan.io 

### Suggested commands to work with this project
1. brownie run .\scripts\fund_and_withdraw.py --network ganache-local
2. brownie run .\scripts\deploy.py --network mainnet-fork-dev
3. brownie test -k test_only_owner_can_withdraw --network rinkeby
4. brownie test -k test_only_owner_can_withdraw --network development
5. brownie test --network mainnet-fork-dev

### Other useful Brownie commands
1. brownie init - to create a sample folder with everything we need with Brownie
2. brownie compile - 
3. brownie networks list - 
4. brownie console - 
5. brownie test - 
6. brownie pm list - 