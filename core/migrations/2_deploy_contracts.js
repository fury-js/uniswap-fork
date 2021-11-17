const Factory = artifacts.require("UniswapV2Factory.sol");
const Pair = artifacts.require("UniswapV2Pair.sol")
const Token1 = artifacts.require("Token1.sol");
const Token2 = artifacts.require("Token2.sol");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(Factory, accounts[0]);
  await deployer.deploy(Pair);
  
  const factory = await Factory.deployed();
  const pair = await Pair.deployed();


    let token1Address;
    let token2Address;

  if(network === "mainet") {
      token1Address = ""
      token2Address = ""
    } else {
        await deployer.deploy(Token1);
        await deployer.deploy(Token2);

        const token1 = Token1.deployed();
        const token2 = Token2.deployed();

        token1Address = Token1.address;
        token2Address = Token2.address;
    }

    await factory.createPair(token1Address, token2Address);

};
