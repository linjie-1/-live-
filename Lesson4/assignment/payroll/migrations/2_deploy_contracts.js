var Payroll = artifacts.require("./Payroll.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol")

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);
  deployer.deploy(Ownable, SafeMath, Payroll);
  deployer.deploy(Payroll);
};
