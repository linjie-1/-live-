pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
     }

     uint constant payDuration = 10 seconds;
     uint totalSalary = 0;  //for new calculateRunway function
     address owner;
     Employee[] employees;

     function Payroll() {
         owner = msg.sender;
     }

     function _partialPaid(Employee employee) private {
         uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
         employee.id.transfer(payment);
     }

     function _findEmployee(address employeeId) private returns (Employee, uint) {
         for (uint i=0; i< employees.length; i++){
             if (employees[i].id == employeeId)
                 return (employees[i], i);
         }
     }

     function addEmployee(address employeeId, uint salary) {
         require(msg.sender == owner);
         var (employee, index) = _findEmployee(employeeId);
         assert(employee.id == 0x0);
         uint salaryInWei = salary * 1 ether;
         employees.push(Employee(employeeId, salaryInWei, now));
        totalSalary += salaryInWei;
     }

     function removeEmployee(address employeeId) {
         var (employee, index) = _findEmployee(employeeId);
         assert(employee.id != 0x0);
         _partialPaid(employee);
         totalSalary -= employee.salary;
         delete employees[index];
         employees[index] = employees[employees.length - 1];
         employees.length -= 1;
     }

     function updateEmployee(address employeeId, uint salary) {
         require(msg.sender == owner);
         var (employee, index) = _findEmployee(employeeId);
         totalSalary -= employee.salary;
         assert(employee.id != 0x0);
         _partialPaid(employee);
        uint salaryInWei = salary * 1 ether;
        employees[index].id = employeeId;
         employees[index].salary = salaryInWei;
         totalSalary += salaryInWei;

     }

     function addFund() payable returns (uint){
         return this.balance;
     }

     function calculateRunway() returns (uint) {
         uint _totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
             _totalSalary += employees[i].salary;
         }
         return this.balance / _totalSalary;
     }

    function calculateRunwayNew() returns (uint) {
         return this.balance / totalSalary;
     }

    function hasEnoughFund() returns (bool){
         return calculateRunway() > 0;
     }

     function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
         assert(employee.id != 0x0);

         uint nextPayday = employee.lastPayday + payDuration;
         if (nextPayday > now)
             revert();
         employees[index].lastPayday = nextPayday;
         employee.id.transfer(employee.salary);
         }

     }
}
