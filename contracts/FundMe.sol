// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import '@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol';
import '@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol';

contract FundMe {
	using SafeMathChainlink for uint256;

	mapping(address => uint256) public addressToAmountFunded;
	address[] public funders;
	address public owner;
	AggregatorV3Interface public priceFeed;

	constructor(address _priceFeed) public {
		priceFeed = AggregatorV3Interface(_priceFeed);
		// person who deploys the contract
		owner = msg.sender;
	}

	function fund() public payable {
		// Setting a minimum deposit value of 50$
		uint256 minimumUSD = 50 * 10**18; // price in WEI
		require(
			getConversionRate(msg.value) >= minimumUSD,
			'You need to spend more ETH!'
		);

		addressToAmountFunded[msg.sender] += msg.value;
		// what the ETH -> USD conversion rate
		funders.push(msg.sender);
	}

	function getVersion() public view returns (uint256) {
		return priceFeed.version();
	}

	function getPrice() public view returns (uint256) {
		(, int256 price, , , ) = priceFeed.latestRoundData();
		return uint256(price * 10**10);
	}

	function getConversionRate(uint256 ethAmount) public view returns (uint256) {
		uint256 ethPrice = getPrice();
		uint256 ethAmountInUsd = (ethPrice * ethAmount) / 10**18;
		return ethAmountInUsd;
		// 0.000003196910000000 - 1 gwei in USD
	}

	function getEntranceFee() public view returns (uint256) {
		// minimumUSD
		uint256 minimumUSD = 50 * 10**18;
		uint256 price = getPrice();
		uint256 precision = 1 * 10**18;
		return (minimumUSD * precision) / price;
	}

	modifier onlyOwner() {
		require(msg.sender == owner, 'You are not the owner of the contract!');
		_;
	}

	function withdraw() public payable onlyOwner {
		// only want the contract admin/owner
		msg.sender.transfer(address(this).balance);
		for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
			address funder = funders[funderIndex];
			addressToAmountFunded[funder] = 0;
		}
		funders = new address[](0);
	}
}
