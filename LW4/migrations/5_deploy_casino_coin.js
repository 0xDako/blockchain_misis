var CasinoCoin = artifacts.require("CasinoCoin");
var RouletteCC = artifacts.require("RouletteCC");
module.exports = async function (deployer) {
    await deployer.deploy(CasinoCoin);
    const token = await CasinoCoin.deployed();
    await deployer.deploy(RouletteCC, token.address);
};
