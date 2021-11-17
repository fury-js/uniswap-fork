const LiquidityMigrator = artifacts.require("LiquidityMigrator.sol");
const BonusToken = artifacts.require("BonusToken.sol");

module.exports = function (deployer) {
  await deployer.deploy(BonusToken);
  const bonusToken = BonusToken.deployed()

  const routerAddress = ""
  const pairAddress = ""
  const routerForkAddress = "0x94Fc23dE7791C7571d21Cd4215AECF02fFBfa0de"
  const pairForkAddress = ""

  await deployer.deploy(LiquidityMigrator, routerAddress, pairAddress, routerForkAddress, pairForkAddress, BonusToken.address );
  const liquidityMigrator = await LiquidityMigrator.deployed();

  await bonusToken.setLiquidator(LiquidityMigrator.address);

};

