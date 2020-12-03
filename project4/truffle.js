var HDWalletProvider = require("@truffle/hdwallet-provider");
var mnemonic = "summer wolf absurd truck hire say exit impact below marriage exclude liberty";

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      // provider: function() {
      //   return new HDWalletProvider(mnemonic, "http://127.0.0.1:8545/", 0, 50);
      // },
      network_id: '*',
      gas: 9999999
    },
    rinkeby: {
      provider: function () {
        var wallet = new HDWalletProvider(MNEMONIC, ENDPOINT)
        var nonceTracker = new NonceTrackerSubprovider()
        wallet.engine._providers.unshift(nonceTracker)
        nonceTracker.setEngine(wallet.engine)
        return wallet
      },
      network_id: 4,
      // gas: 2000000,   // <--- Twice as much
      // gasPrice: 10000000000,
    }
  },
  compilers: {
    solc: {
      version: "^0.4.25"
    }
  }
};