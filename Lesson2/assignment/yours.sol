// 第二课作业
pragma solidity ^0.4.14;
contract Payroll {
    // 定义一个类型
    struct Employee {
         address id;
         uint salary;
         uint lastPayday;
    }
    uint constant payDuration = 10 seconds;

    // Employee类型的数组{**牢记和struct的组合**}
    Employee[] employees;
    // 上次时间
    uint lastPayday;
    address owner;
    uint totalSalary = 0 ether;

    //构造函数
    function Payroll() {
        owner = msg.sender;
    }

    //通用的验证函数
    function _partialPaid(Employee employee) private {
         //上个地址是否支付,未支付则支付
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration ;
        // 发工资
        employee.id.transfer(payment);
    }

    //查询
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    // 添加
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        require(employee.id == 0x0);
        // 优化totalSalary
        totalSalary += salary * 1 ether;
        employees.push(Employee(employeeId, salary, now));
    }

    // 删除
    function removeEmployee(address employeeId) {
        require(msg.sender == employeeId);
        var (employee, index) = _findEmployee(employeeId);
        require(employee.id != 0x0);
        _partialPaid(employee);
        // 优化totalSalary
        totalSalary -= employees[index].salary * 1 ether;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
        
    }
    // 更新
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        require(employee.id != 0x0);
        _partialPaid(employees[index]);
        employees[index].salary = salary;
        employees[index].lastPayday = now;
        totalSalary += salary * 1 ether;
        totalSalary -= employees[index].salary * 1 ether;

    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function get() returns (uint)  {
        return this.balance;
    }

     // 支付次数
    function colculateRunway() returns (uint) {
        // uint totalSalary = 0;
        // var (employee, index) = _findEmployee(employeeId);
        // for (uint i = 0; i < employees.length; i++) {
        //     totalSalary += employees[i].salary;
        // }
        //将计算次数分摊到增删改查当中.
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return colculateRunway() > 0;
    }

    // 付钱
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        require(employee.id != 0x0);
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now); 
        employee.lastPayday = nextPayDay;
        employees[index].id.transfer(employee.salary);
    }

}
