# Ethereum Dapp for Tracking Items through Supply Chain

## Submission Information
- [ ] [UML Diagrams](#UML-Diagrams)
- [ ] [Libraries Write-up](#Libraries-Write-up)
- [ ] [IPFS Write-up](#IPFS-Write-up)
- [ ] [General Write-up](#General-Write-up)

The Rinkeby contract address for this project is: `ADDRESS`

## Summary
The purpose of this project is to learn lower level components of establishing a sound web service architecture using Blockchain.  In this project, I created a dApp supply chain solution on Ethereum using smart contracts with role-based permissions to track and verify a product's authenticity.  To do this, I built the dApp in five parts:

- **Part 1 - Plan the project:** I made UML diagrams and described the libraries that I chose to use and why I chose to use them
- **Part 2 - Write smart contracts:** Based on the drafted specifications, I defined the required interfaces for the smart contracts and added the specific logic to each of the contracts: (i) `AccessControl` (ii) `Base` (iii) `Core`
- **Part 3 - Test smart contract code coverage:** I drafted tests to cover every function in the sequence diagram from `Part 1` and ensured that all tests were passing.
- **Part 4 - Deploy smart contracts on Rinkeby:** I used the Truffle framework and Infura to deploy my smart contracts onto the Rinkeby test network.
- **Part 5 - Build the frontend:** I created a frontend interface that allows users to interact with the smart contracts from the web.

## Testing The dApp
Below is the output from my tests in the `test` folder.  To run the tests, simply execute `truffle test` at the command line.
```
PASTE
```

## Running the dApp
Screenshots etc

### UML Diagrams

#### Activity

#### Sequence

#### State

#### Classes (Data Model)

### Libraries Write-up
If libraries are used, the project write-up discusses why these libraries were adopted.

"dependencies": {
    "truffle-hdwallet-provider": "^1.0.17"
  }

- "truffle-hdwallet-provider": "^1.0.17"
solidity-docgen

### IPFS Write-up
If IPFS is used, the project write-up discusses how IPFS is used in this project.

### General Write-up
A general write up exists to items like steps and contracts address.
The Rinkeby contract address for this project is: `ADDRESS`

Generate documentation 
`npx solidity-docgen --help`