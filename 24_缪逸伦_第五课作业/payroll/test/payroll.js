var payroll = artifacts.require("./payroll.sol");

contract('payroll', function(accounts) {

  it("...should add and remove employees correctly.", function() {
    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(account[1], 1);
    }).then(function() {
      return payrollInstance.removeEmployee.(account[1]);
    }).then(function() {
      return payrollInstance.addEmployee(account[1], 2);
    }).then(function()) {
        assert(true, "sweet!");
    })
  });

  it("...should have the correct msg sender.", function() {
      return payroll.deployed.then(function(instance) {
          payrollInstance = instance;

          return payrollInstance.addEmployee(account[1], 1, {from: account[5]});
      }).catch(function(error)) {
            assert(error.toString().includes('revert'), "wrong caller");
      });
  });

  it("...should have the correct msg sender.", function() {
      return payroll.deployed.then(function(instance) {
          payrollInstance = instance;

          return payrollInstance.addEmployee(account[1], 1);
      }).then(function() {
          return payrollInstance.removeEmployee(account[1], {from: account[5]});
      }).catch(function(error)) {
            assert(error.toString().includes('revert'), "wrong caller");
      });
  });

  it("...should avoid adding duplicate employee.", function() {
      return payroll.deployed.then(function(instance) {
            payrollInstance = instance;

            return payrollInstance.addEmployee(account[1], 1);
      }).then(function() {
          return payrollInstance.addEmployee(account[1], 2);
      }).catch(function(error) {
            assert(error.toString().includes('invalid'), "duplicate employee");
      });
  });

  it("...should avoid removing none-exit employee.", function() {
      return payroll.deployed.then(function(instance) {
          payrollInstance = instance;

          return payrollInstance.removeEmployee(account[4]);
      }).catch(function(error) {
          assert(error.toString().includes('invalid'), "employee no exist");
      });
  });

});