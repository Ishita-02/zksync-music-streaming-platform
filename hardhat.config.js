/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    "zksync_sepolia": {
      "url": "https://zksync-sepolia.g.alchemy.com/v2/20gKKYO3bnUx5QPEpz80cOFLtmSTxO2L",
      "accounts": ["2d3193ac4c94e9babbc4333f68aaf69cc41ff3fbbbd50e3a2d83409bbc1952b1"]
    }
  }
};
