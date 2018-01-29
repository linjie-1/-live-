<<<<<<< HEAD
pragma solidity ^0.4.14;

=======
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
//因为每次都要循环遍历的缘故，没加一次雇员，需要更多的gas，所以我把totalSalary的运算放在其他会改动totalSalary的函数，以降低gas的消耗
>>>>>>> 076e71b01aac7c084a0c31ab12daf43d1cf839ec
contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
<<<<<<< HEAD

    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    uint totalSalary = 0;
=======
    
    uint constant payDuration = 10 seconds;
    uint totalSalary;

    address owner;
    Employee[] employees;
>>>>>>> 076e71b01aac7c084a0c31ab12daf43d1cf839ec

    function Payroll() {
        owner = msg.sender;
    }
<<<<<<< HEAD

    function _partialPaid(Employee employee) private {
      uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
      employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee ,uint) {
      for (uint i = 0; i < employees.length; i++) {
        if (employees[i].id == employeeId) {
          return (employees[i], i);
        }
      }
    }

    function addEmployee(address employeeId, uint salary) {
      require(msg.sender == owner);
      var (employee, index) = _findEmployee(employeeId);
      assert(employee.id == 0x00);

      employees.push(Employee(employeeId, salary * 1 ether, now));
      totalSalary += employees[index].salary;
    }

    function removeEmployee(address employeeId) {
      require(msg.sender == owner);
      var (employee, index) = _findEmployee(employeeId);
      assert(employee.id != 0x00);

      if (employees[index].id == employeeId) {
        _partialPaid(employees[index]);
        totalSalary -= employees[index].salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
      }
    }

    function updateEmployee(address employeeId, uint salary) {
      require(msg.sender == owner);
      var (employee, index) = _findEmployee(employeeId);
      assert(employee.id != 0x00);

      if (employees[index].id == employeeId) {
        _partialPaid(employees[index]);
        totalSalary -= employees[index].salary;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        totalSalary += employees[index].salary;
      }
    }

    function addFund() payable returns (uint) {
      return this.balance;
    }

    function calculateRunway() returns (uint) {
      /* 优化前
      for (uint i = 0; i < employees.length; i++) {
        totalSalary += employees[i].salary;
      }
      */
      return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
      return calculateRunway() > 0;
    }

    function getPaid() {
      var (employee, index) = _findEmployee(msg.sender);
      assert(employee.id != 0x00);

      uint nextPayday = employees[index].lastPayday + payDuration;
      assert(nextPayday < now);

      employees[index].lastPayday = nextPayday;
      employees[index].id.transfer(employees[index].salary);
=======
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        totalSalary = totalSalary + salary;
        employees.push(Employee(employeeId, salary, now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        totalSalary = totalSalary - employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;
        
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);       
        _partialPaid(employee);
        totalSalary = totalSalary + salary - employee.salary;
        employee.salary = salary;
        employee.lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
>>>>>>> 076e71b01aac7c084a0c31ab12daf43d1cf839ec
    }
}
