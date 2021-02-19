// migrating the appropriate contracts
var Verifier = artifacts.require("./Verifier.sol");
//var ERC721MintableComplete = artifacts.require("./ERC721MintableComplete.sol");
var SolnSquareVerifier = artifacts.require("./SolnSquareVerifier.sol");

module.exports = async (deployer) => {
  await deployer.deploy(Verifier);
  //await deployer.deploy(ERC721MintableComplete, "SS_ERC721MintableToken", "SS_721M");
  await deployer.deploy(SolnSquareVerifier, Verifier.address, "SS_ERC721MintableToken", "SS_721M");
};
