![GitHub](https://img.shields.io/github/license/galen211/udacity-blockchain-developer?style=flat-square)

# Udacity Blockchain Development Nanodegree

## About Me
I'm a former bond trader and consultant who has been involved in fintech for over 10 years.  I'm interested in Blockchain use cases that enhance existing legal regimes to enable individuals and organizations to contract more ubiquitously and frictionlessly.

## Nanodegree Projects

- [x] [Project 1: Create Your Own Private Blockchain](#project-1)
- [x] [Project 2: Build CryptoStar Dapp on Ethereum](#project-2)
- [ ] [Project 3: Ethereum Dapp for Tracking Items through Supply Chain](#project-3)
- [ ] [Project 4: FlightSurety](#project-4)
- [ ] [Project 5: Real Estate Marketplace Capstone](#project-5)

## Github Repo Structure
This repo is a [multi-root workspace](https://code.visualstudio.com/docs/editor/multi-root-workspaces) configured in [Visual Studio Code](https://code.visualstudio.com/).  To open the workspace in VS Code, open the `blockchain.code-workspace` file.  Each root is a project folder containing a project submission to the Blockchain Developer Nanodegree.  To make it easy to maintain and debug my code, I've containerized each project and configured VS Code [tasks](https://code.visualstudio.com/docs/editor/tasks) and [launch](https://code.visualstudio.com/docs/editor/debugging#_launch-configurations) configurations.

### Launching Projects
To run the code for any given project, you can simply navigate to the Run dialog (View > Run), select the project to run and then click run.  This will build the project's docker image and kick-off the application code as shown in the screenshots below.  Tasks are also available via the VS Code [command palette](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette).

Each project contains a `README.md` file with further instructions to interact with project code.

## Project 1
### Create Your Own Private Blockchain
In this project, I created a private blockchain to record ownership of stars.  Built as an `express.js` app, I implemented the code in `src/block.js` and `src/blockchain.js` that provides the functionality of validating a block on the blockchain, decoding the block, and constructing a chain of blocks that can be signed with an Electrum wallet.  The project also exposes endpoints to search for blocks by block height, block hash, and by the address of the wallet that signed the block.

More information about this project is available in the [project folder](/project1/)

## Project 2
### Build CryptoStar Dapp on Ethereum
The purpose of this project is to develop familiarity with building a decentralized app (dApp) on Ethereum.  In the course, I created `v1` of the Star Notary app which used the `ERC721` interface to declare a non-fungible token.  In this project, I extended the functionality of the Star Notary dApp by adding a name and symbol to our token and additional functionality including: (i) looking up the given name of a star given its token id, (ii) exchanging two stars between two owners, and (iii) transfering a star from one user to another user.

More information about this project is available in the [project folder](/project2/)

## Project 3
### Ethereum Dapp for Tracking Items through Supply Chain
In this project, I created a dApp supply chain solution on Ethereum using smart contracts with role-based permissions to track and verify a product's authenticity.  The purprose of the project is to get experience building an application end-to-end including planning, drafting and testing smart contracts, deploying the smart contracts, and creating a frontend interface with web3 functions to allow a client to interact with the smart contracts.

More information about this project is available in the [project folder](/project3/)

## Project 4 - **not started**
### FlightSurety
//TODO: complete project and summarize

More information about this project is available in the [project folder](/project4/)

## Project 5 - **not started**
### Capstone: Real Estate Marketplace
//TODO: complete project and summarize

More information about this project is available in the [project folder](/project5/)
