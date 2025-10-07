require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    monad_testnet: {
      url: "https://monad-testnet.drpc.org",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 10143,
    },
  },
  etherscan: {
    // You will need an API key for the block explorer to verify contracts
    // apiKey: process.env.ETHERSCAN_API_KEY
  }
};
