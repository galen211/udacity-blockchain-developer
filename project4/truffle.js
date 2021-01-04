module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: '*'
    },
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  mocha: {
    parallel: false,
    reporter: 'eth-gas-reporter',
    reporterOptions : { 
      currency: 'USD',
      excludeContracts: ['Migrations'],
      outputFile: 'fs-gas-report.rst',
      rst: true,
      rstTitle: 'Flight Surety Gas Consumption',
      noColors: true
    }
  },
  compilers: {
    solc: {
      version: "^0.4.26"
    }
  }
};