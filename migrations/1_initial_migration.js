// const Migrations = artifacts.require("Migrations");
const GameLogic = artifacts.require("GameLogicAs_ERC721");
const Lands = artifacts.require("LandFactoryAsERC721");

module.exports = function (deployer) {
  deployer.deploy(GameLogic);
  deployer.deploy(Lands);
};
