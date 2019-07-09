var starNotary = artifacts.require("./starNotary.sol");

module.exports = function(deployer, network, accounts) {
  if (network == "rinkeby") {
    deployer.deploy(starNotary, {from: accounts[0]});
  } else if (network == "development") {
    deployer.deploy(starNotary, {from: accounts[0]});
  }
};
