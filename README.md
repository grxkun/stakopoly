# stakopoly
Monad Stake dApp - Backend Smart Contracts
This folder contains the Solidity smart contracts and Hardhat development environment for the Monad Stake dApp.

Project Structure
/contracts: Contains the Solidity source code.

StakingPool.sol: The core contract that handles all logic for a single staking pool.

StakingPoolFactory.sol: The factory contract used to deploy new StakingPool instances.

/scripts: Contains deployment scripts.

deploy.js: Deploys the StakingPoolFactory to the configured network.

/hardhat.config.js: Hardhat configuration file (network, solidity version, etc.).

package.json: Project dependencies.

Setup & Deployment
Follow these steps to deploy the smart contracts to the Monad Testnet.

1. Install Dependencies
First, navigate to this directory in your terminal and install the required Node.js packages.

npm install

2. Set Up Environment Variables
The project requires environment variables to store your wallet's private key and the Monad Testnet RPC URL.

Create a new file named .env in the root of this backend directory. You can do this by copying the example file:

cp .env.example .env

Open the .env file and replace the placeholder values:

PRIVATE_KEY: Your wallet's private key. IMPORTANT: Use a wallet that is for development purposes only and does not hold significant funds. Never commit your .env file to a public repository.

MONAD_TESTNET_RPC_URL: The official RPC endpoint for the Monad Testnet. You will find this in the Monad developer documentation when the testnet is live.

3. Compile the Smart Contracts
Compile the contracts to make sure everything is set up correctly.

npx hardhat compile

This will create an /artifacts directory containing the compiled contract ABIs and bytecode.

4. Deploy to Monad Testnet
Run the deployment script. Make sure your wallet has some Monad testnet ETH to pay for the gas fees.

npx hardhat run scripts/deploy.js --network monad_testnet

If the deployment is successful, the script will print the address of your newly deployed StakingPoolFactory contract to the console.

5. Using the Deployed Contracts
After deployment, you will have the StakingPoolFactory address. This is the main contract your frontend will interact with.

To create a new pool: Your dApp will call the createPool() function on the factory contract.

To find existing pools: Your dApp should listen for the PoolCreated event from the factory contract to get the addresses of all StakingPool instances. You can then interact with each pool contract directly to get its details, stake, unstake, and claim rewards.