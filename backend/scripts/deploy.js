const hre = require("hardhat");

async function main() {
  const StakingPoolFactory = await hre.ethers.getContractFactory("StakingPoolFactory");
  const stakingPoolFactory = await StakingPoolFactory.deploy();

  await stakingPoolFactory.deployed();

  console.log(
    `StakingPoolFactory deployed to: ${stakingPoolFactory.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
