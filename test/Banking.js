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
    const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    const ONE_GWEI = 1_000_000_000;

    const lockedAmount = ONE_GWEI;
    const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Banking = await ethers.getContractFactory("Banking");
    const banking = await Banking.deploy(unlockTime);

    return { banking, owner, otherAccount };
  }

  it("Store first account details", async function () {
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
        500,
        "0x4bdA3a7F53453d0B2B1070D856D4D7Ba248F98b8",
        "1848395939393"
      )
    );
  });

  it("Store second account details", async function () {
    const { banking } = await loadFixture(deployBankingFixture);
  
    expect(
      await banking.storeData(
        "Team Fortrix Genesis",
        "genesisx@gmail.com",
        "+2348102433987",
        "Nigeria",
        "23 Weststreet",
        "NGN",
        3000,
        "0xbF85887b87d3f90Bf535C225f9c24C62a211Fb29",
        "1848395939583"
      )
    );
  });

  it("Get account number's address",async function(){
    const {banking} = await loadFixture(deployBankingFixture);

    expect(await banking.getAccountAddress('1848395939393')).to.be.properAddress;
  })

  it("Get account number's balance",async function(){
    const {banking} = await loadFixture(deployBankingFixture);

    expect(banking.getAccountBalance('1848395939393'));
  })

  it("Withdraw from account",async function(){
    const {banking} = await loadFixture(deployBankingFixture);

    expect(banking.withdraw('1848395939393',100));
  })

  it("Withdraw from account with less balance",async function(){
    const {banking} = await loadFixture(deployBankingFixture);

    expect(banking.withdraw('1848395939393',5900));
  })
  it("Deposit into account",async function(){
    const {banking} = await loadFixture(deployBankingFixture);

    expect(banking.deposit('1848395939583',100));
  })

});
