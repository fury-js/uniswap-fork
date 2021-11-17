const Router = artifacts.require("UniswapV2Router02.sol");
const WETH = artifacts.require("WETH.sol");

module.exports = async function (deployer, network, accounts) {
    let weth;
    const FACTORY_ADDRESS = "0x37920e90F4E4Ed0d845498c5e38F5BB5eD7b2131";
    if(network === "mainnet") {
        weth = WETH.at("0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2");
    } else {
        await deployer.deploy(WETH);
        weth = await WETH.deployed();

    }

    await deployer.deploy(Router, FACTORY_ADDRESS, WETH.address);
};