# Stakopoly

A decentralized NFT staking platform built on the Monad blockchain. Users can create staking pools for their NFT collections and earn token rewards.

## Features

- **NFT Staking**: Stake NFTs from supported collections to earn rewards
- **Pool Creation**: Create custom staking pools with configurable parameters
- **Real-time Rewards**: Earn tokens based on staking duration and pool emission rates
- **Web3 Integration**: Connect with MetaMask and interact with the Monad testnet

## Project Structure

```
stakopoly/
├── frontend/
│   └── index.html          # Main dApp interface
├── backend/
│   ├── contracts/
│   │   ├── StakingPool.sol       # Core staking logic
│   │   └── StakingPoolFactory.sol # Factory for deploying pools
│   ├── scripts/
│   │   └── deploy.js             # Deployment script
│   ├── hardhat.config.js         # Hardhat configuration
│   ├── package.json              # Backend dependencies
│   └── .env                      # Environment variables
└── vercel.json                   # Vercel deployment config
```

## Backend Setup

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn

### Installation
```bash
cd backend
npm install
```

### Environment Setup
Create a `.env` file in the `backend` directory:
```
PRIVATE_KEY=your_private_key_here
MONAD_TESTNET_RPC_URL=https://monad-testnet.drpc.org
```

### Compilation
```bash
npm run compile
```

### Deployment
```bash
npm run deploy
```

## Frontend Setup

The frontend is a static HTML/CSS/JS application that interacts with the deployed smart contracts.

### Deployment
The project is configured for Vercel deployment. Connect the GitHub repository to Vercel for automatic deployments.

## Smart Contracts

### StakingPool
- Manages staking logic for a single NFT collection
- Handles reward distribution based on emission rates
- Supports staking/unstaking and reward claiming

### StakingPoolFactory
- Deploys new StakingPool instances
- Maintains a registry of all created pools

## Network Information

- **Network**: Monad Testnet
- **Chain ID**: 10143 (0x279f)
- **RPC URL**: https://monad-testnet.drpc.org
- **Block Explorer**: https://testnet.monad.xyz
- **Currency**: MON

## Development

### Local Development
1. Start Hardhat node: `npx hardhat node`
2. Deploy contracts: `npx hardhat run scripts/deploy.js --network localhost`
3. Serve frontend locally: Use a local server (e.g., `python -m http.server`)

### Testing
```bash
cd backend
npx hardhat test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License

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