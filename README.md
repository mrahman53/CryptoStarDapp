# CryptoStar Dapp On Ethereum

This is a decentralized application on an Ethereum test network. This Dapp allows you to register and look up a star.

## Getting Started

Following instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites
The following packages are required:
```
node.js
npm
web3
http-server
openzeppelin-solidity
truffle-hdwallet-provider
```

### Running the tests
You can clone this repo and install all required packages by running 

``npm install``

#### For starting the development console, run:

``truffle develop``

#### For compiling the contract, inside the development console, run:

``compile``

#### For migrating the contract to the locally running Ethereum network, inside the development console, run:

``migrate --reset``

#### For running unit tests the contract, inside the development console, run:

``test``

#### In another terminal tab, run the truffle test:

``cd app``
``npm run dev``


