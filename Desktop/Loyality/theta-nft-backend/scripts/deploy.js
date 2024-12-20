const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const ThetaCollectibles = await hre.ethers.getContractFactory("ThetaCollectibles");
  const contract = await ThetaCollectibles.deploy();
  console.log("ThetaCollectibles contract deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
