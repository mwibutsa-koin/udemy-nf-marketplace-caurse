const { assert } = require("chai");

const kryptoBird = artifacts.require("./KryptoBird");

// check for chai

require("chai").use(require("chai-as-promised")).should();

contract("KryptoBird", async (accounts) => {
  let kbird;

  before(async () => {
    kbird = await kryptoBird.deployed();
  });

  // testing container - describe
  describe("deployment", async () => {
    // test samples with writing it.
    it("deploys successfully", async () => {
      const address = kbird.address;
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.notEqual(address, 0x0);
    });

    it("has a name", async () => {
      const name = await kbird.name();
      assert.equal(name, "KryptoBird");
    });

    it("has a symbol", async () => {
      const name = await kbird.symbol();
      assert.equal(name, "KBIRDZ");
    });
  });

  describe("minting", async () => {
    // kbird = await kryptoBird.deployed();
    it("Creates a new token", async () => {
      const result = await kbird.mint("https...1");
      const totalSupply = await kbird.totalSupply();
      assert.equal(totalSupply, 1);
      const event = result.logs[0].args;

      assert.equal(event._from, kbird.address);
      assert.equal(event._to, accounts[0]);

      // failure
      await kbird.mint("https...1").should.be.rejected;
    });
  });

  describe("indexing", async () => {
    it("lists KryptoBirds", async () => {
      await kbird.mint("https...2");
      await kbird.mint("https...3");
      await kbird.mint("https...4");

      const totalSupply = await kbird.totalSupply();

      let result = [];
      let KryptoBird;

      for (let i = 1; i <= totalSupply; i++) {
        KryptoBird = await kbird.kryptoBirdz(i - 1);
        result.push(KryptoBird);
      }
      assert.equal(result.length, 4);
      assert.equal(result.includes("https...2"), true);
    });
  });
});
