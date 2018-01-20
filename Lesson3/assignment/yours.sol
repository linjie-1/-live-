/*作业请提交在这个目录下*/
<<<<<<< HEAD
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
=======

//q1

pragma solidity ^0.4.14;

contract payRoll{
>>>>>>> 386acd70d7ec918077b747268eab94fabc7f55f6
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
<<<<<<< HEAD

    uint totalSalary ;
    address owner;
    mapping(address => Employee) public employees;
  

    function Payroll() payable {
        owner = msg.sender;
    }
   
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
=======
    
    address owner;
    uint totalSalary;
    mapping(address => Employee) employees;
    
    function Payroll(){
        owner = msg.sender;
    }
    
>>>>>>> 386acd70d7ec918077b747268eab94fabc7f55f6
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
<<<<<<< HEAD
   
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary = totalSalary.add(salary * 1 ether);
        employees[employeeId] = (Employee(employeeId,salary * 1 ether,now));
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary * 1 ether);
        delete employees[employeeId]; 
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary * 1 ether);
        totalSalary = totalSalary.add(salary * 1 ether);
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund()  returns (uint) {
=======
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeId] = (Employee(employeeId, salary * 1 ether, now));
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        
        var employee = employees[employeeId];
        
        assert(employee.id == 0x0);
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
        
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var employee = employees[employeeId];
        
        assert(employee.id == 0x0);
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
        totalSalary += employees[employeeId].salary;
        
    }
    
    function addFund() returns (uint) {
>>>>>>> 386acd70d7ec918077b747268eab94fabc7f55f6
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
<<<<<<< HEAD
        return calculateRunway() > 0 ;
    }

    function checkEmployee(address employeeId)returns (uint salary,uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;

    }

    function changePaymentAddress(address employeeId,address newEmployeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        var newEmployee = Employee(newEmployeeId,employee.salary,employee.lastPayday);
        delete employees[employeeId];
        employees[newEmployeeId] = newEmployee;
    }
    
    function getPaid() employeeExist(msg.sender){
        
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
=======
        return calculateRunway() > 0;
    }
    
    function checckEmployee(address employeeId) returns (uint salary, uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function getPaid() {
        var employee = employees[msg.sender];
        assert(employee.id == 0x0);
        
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
}


/// q2
function changePaymentAddress(address employeeId, address newEmployeeId) onlyOwner employeeExist(employeeId) {
  var employee = employees[employeeId];
  
  _partialPaid(employee);
  employees[employeeId].id = newEmployeeId;
  employees[newEmployeeId].lastPayday = now;
>>>>>>> 386acd70d7ec918077b747268eab94fabc7f55f6
}
