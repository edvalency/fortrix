const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
// const Web3 = require("web3");

describe("Banking", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployBankingFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Banking = await ethers.getContractFactory("Banking");
    const banking = await Banking.deploy();

    return { banking, owner, otherAccount };
  }

  // it("Add Organisation", async function () {
  //   const { donate } = await loadFixture(deployDonateFixture);
  //   console.log(
  //     await donate.addOrganisation(
  //       "EricaOrg",
  //       "0xbF85887b87d3f90Bf535C225f9c24C62a211Fb29"
  //     )
  //   );
  // });

  it("Generate address and store account details", async function () {
    const { banking } = await loadFixture(deployBankingFixture);
    // const address = await ethers.

    expect(
      await banking.storeData(
        "Team Fortrix",
        "tfortrix@yahoo.com",
        "0553798229",
        "Ghana",
        "14 Chad Street",
        "GHS",
        300,
        "0x4bdA3a7F53453d0B2B1070D856D4D7Ba248F98b8",
        "1848395939393"
      )
    );
  });

  it("Get account number's address",async function(){
    const {banking} = await loadFixture(deployBankingFixture);

    expect(await banking.getAccountAddress('1848395939393')).to.be.properAddress;
  })
});
