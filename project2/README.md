# Decentralized Star Notary
<img src="../assets/undraw/project2.svg" width="200"/>

## Submission Information
1) Your ERC-721 Token Name: `Star Token`
2) Your ERC-721 Token Symbol: `STK`
3) Version of the Truffle and OpenZeppelin used: `Truffle v5.1.44 (core: 5.1.44)` | `OpenZeppelin version 2.1.2`
4) The deployed smart contract address on rinkeby test network: `0x1209562a12bB99fE01BFb0154C2A588Ed078aA3a`

## Summary
The purpose of this project is to develop familiarity with building a decentralized app (dApp) on Ethereum.  In the course, we created `v1` of the Star Notary app which used the `ERC721` interface to declare a non-fungible token.  Previously, we added functions in our `StarNotary.sol` contract to (i) create a star, (ii) put a star up for sale, and (iii) buy a star.

In this project, we extended the functionality of the dApp by adding a name and symbol to our token and adding additional functionality including:

- looking up the given name of a star given its token id
- exchanging two stars between two owners
- transfering a star from one user to another user

## Testing The dApp
We added unit tests in `test/TestStarNotary.js` to test the added functionality.  The testing framework we used is called `chai`, which allows us to write simple assertions for smart contracts.  To run the tests in truffle, simply run `truffle test` from the root directory (i.e. location of the `truffle-config.js` file).  The test output from our suite of tests is pasted below:

```
galen$ truffle test
Using network 'development'.


Compiling your contracts...
===========================
> Compiling ./contracts/StarNotary.sol
> Artifacts written to /var/folders/xv/t0hbf7w152v_bfzh_8b3y3nw0000gn/T/test--75178-70n9QAKw3J8j
> Compiled successfully using:
   - solc: 0.5.16+commit.9c3226ce.Emscripten.clang



  ✓ can Create a Star (113ms)
  ✓ lets user1 put up their star for sale (178ms)
  ✓ lets user1 get the funds after the sale (192ms)
  ✓ lets user2 buy a star, if it is put up for sale (215ms)
  ✓ lets user2 buy a star and decreases its balance in ether (283ms)
  ✓ can add the star name and star symbol properly (125ms)
  ✓ lets 2 users exchange stars (285ms)
  ✓ lets a user transfer a star (159ms)
  ✓ lookUptokenIdToStarInfo test (148ms)

  9 passing (2s)
```

###  Deploying to Rinkeby
On the Rinkeby test network, you can get free test coins from a faucet and run smart contracts on a test instance of the Ethereum network without incurring any costs.  Truffle makes deploying (i.e. migrating) our tested contracts straightforward.  The first step to prepare the migration is to edit the `networks` section of the `truffle-config.js` file.  We used a configuration provided by infura for our `HDWalletProvider`.  Infura provides blockchain infrastructure to connect to Ethereum nodes (in this case, nodes connected to the Rinkeby test network).  This configuration requires a wallet with an Ethereum balance (test coins), which we provided as follows:
```javascript
const HDWalletProvider = require('truffle-hdwallet-provider');
const infuraKey = "1f959ba5e1fc4d839375c97d5e27ffef";

const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim(); // gitignore
```
The `.secret` file contains the mnemonic to spend the test coins needed to run our deployment.  The network configuration is given below:
```javascript
    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${infuraKey}`),
        network_id: 4,       // rinkeby's id
        gas: 5500000,        // rinkeby has a lower block limit than mainnet
        confirmations: 2,
        timeoutBlocks: 200,
        skipDryRun: true,
    },
```
To perform the migration, simply run `truffle migrate --reset --network rinkeby`.  The output from this command yields our contract address and other details about the migration on Rinkeby:
```
2_deploy_contracts.js
=====================

   Deploying 'StarNotary'
   ----------------------
   > transaction hash:    0x59c5d6a49bee0db7bae94b14216ce47af9797beb2c19f2556f4d82e38a2d7a33
   > Blocks: 1            Seconds: 12
   > contract address:    0x1209562a12bB99fE01BFb0154C2A588Ed078aA3a
   > block number:        7434766
   > block timestamp:     1603679091
   > account:             0x627306090abaB3A6e1400e9345bC60c78a8BEf57
   > balance:             0.912979932
   > gas used:            1834757 (0x1bff05)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.03669514 ETH
```

## Modifying the app frontend
Lastly to give users of the dApp the ability to interact with the contract, we modified the existing Star Notary frontend to enable calling the Star Name given the token id.  This code is included in the `app/src/index.js` file.