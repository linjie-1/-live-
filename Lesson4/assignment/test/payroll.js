var payroll = artifacts.require("./Payroll.sol");

contract('payroll', function(accounts) {

  
  //添加一个新员工
  it("添加一个新员...should add a new employee.", function() {
    let employeeId = accounts[1];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(function() {
      return payrollInstance.employees.call(employeeId);
    }).then(function(employee) {
        assert(true);
        assert.equal(employee[0], employeeId, "check employee address");
        // assert.equal(employee[2].valueOf(), web3.toWei(salary, 'ether'), "check salary");
    });
  });

  // 1.1 should not add a new employee by non-owner person   新加的员工不能是自己
  it("...should not add a new employee by non-owner person.", function() {
    let employeeId = accounts[1];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      // employee tries to add self -> it is an error!
      return payrollInstance.addEmployee(employeeId, salary, {from: employeeId});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        }, 'Exception');
    });
  });


  // 1.2 should not add an existed employee  新加的员工不能是已经已经过的员工
  it("...should not add an exisetd employee.", function() {
    let employeeId = accounts[1];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;
      // add record of employeeId -> then he/she becomes an employee
      payrollInstance.employees[employeeId] = {id: employeeId, salary: salary};
      // add the same employee again -> it is an error!
      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        }, 'Exception');
    });
  });




  // 2.0 remove employee with expected behavior: add employee first and then remove  已经添加过的员工 才能删除
  it("...should remove the target employee.", function() {
    let employeeId = accounts[3];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(function() {
         //then remove this employee
      return payrollInstance.removeEmployee(employeeId, {from: owner});
    }).then(function() {
        // access record of this removed employee
        return payrollInstance.employees.call(employeeId);
      }).then(function(employee) {
          // non-existed employee: address should be default value "0x0"
          assert.equal(employee[0], '0x0000000000000000000000000000000000000000', "non-existed employee");
          assert(true);
      });
  });

  // 2.1 remove employee by non-owner person 删除 不能是自己拥有者这个角色的用户 
  it("...should not remove employee by non-owner person.", function() {
    let employeeId = accounts[1];
    let salary = 1;  
    let owner = accounts[0];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addEmployee(employeeId, salary, {from: owner});
    }).then(function() {
      // let employee to remove self is an error!
      return payrollInstance.removeEmployee(employeeId, {from: employeeId});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        }, 'Exception');
    });
  });

  // 2.2 remove non-existed employee  不存在的用户不能删除
  it("...should not remove non-existed employee.", function() {
    let owner = accounts[0];
    // accounts[2] has never been added as employee, try to remove him/her is an error!
    let employee = accounts[2];

    return payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.removeEmployee(employee, {from: owner});
    }).catch(function(error) {
        assert.throws(function() {
            throw error;
        }, 'Exception');
    });
  });

});
