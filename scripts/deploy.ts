const hre = require("hardhat");

async function main() {
  const MetaCourseContract = await hre.ethers.getContractFactory("MetaCourse");
  const MetaCourseContractInstace = await MetaCourseContract.deploy();

  await MetaCourseContractInstace.deployed();

  console.log("MetaCourse deployed to :", MetaCourseContractInstace.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
