const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const banking = await hre.ethers.deployContract("Banking");

    console.log("ABSA app address:", await banking.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });