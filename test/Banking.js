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
    const banking = await Banking.deploy(unlockTime, owner, 900000000000);

    return { banking, owner, otherAccount };
  }

  it("getContract balance", async function () {
    const { banking, owner } = await loadFixture(deployBankingFixture);
    expect(await banking.balanceOf(owner));
  });

  it("Deposit to other account", async function () {
    const { banking,owner, otherAccount } = await loadFixture(deployBankingFixture);
    expect(await banking.makeTransfer(owner,otherAccount.address, 3000)).to.emit(
      banking,
      "Transferred"
    );
  });

  it("transfer to address", async function () {
    const { banking, owner, otherAccount } = await loadFixture(
      deployBankingFixture
    );
    expect(
      await banking.makeTransfer(owner, otherAccount.address, 100)
    ).to.emit(banking, "Transferred");
  });

  it("check balance of address minted to", async function () {
    const { banking, otherAccount } = await loadFixture(deployBankingFixture);
    expect(await banking.balanceOf(otherAccount.address));
  });

  it("transfer more than account balance", async function () {
    const { banking, owner, otherAccount } = await loadFixture(
      deployBankingFixture
    );
    expect(
      await banking.makeTransfer(otherAccount.address,owner, 100)
    ).to.emit(banking, "LowBalance");
  });
  

  
});
