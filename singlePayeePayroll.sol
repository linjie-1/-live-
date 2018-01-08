pragma solidity ^0.4.14;

contract SinglePayeePayroll {
    struct Payee{
        address payeeAddress;
        string payeeName;
    }
    uint salary = 0;
    uint constant payDuration = 30 days;
    uint lastPayday = now;
    Payee payee;

    function setPayee(string name, address addr) {
        payee.payeeName = name;
        payee.payeeAddress = addr;
    }
    
    function setPayeeName(string name) {
        payee.payeeName = name;
    }
    
    function setPayeeAddress(address addr) {
        payee.payeeAddress = addr;        
    }
    
    function getPayeeAddress() returns (address){
        return payee.payeeAddress;
    }
    
    function getPayeeName() returns (string){
        return payee.payeeName;
    }
    
    function setSalary(uint sal) {
        salary = sal;
    }
    
    function getSalary() returns (uint) {
        return salary;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function getPaid() {
        if(msg.sender != payee.payeeAddress) {
            revert();
        }
        uint nextPayday =lastPayday + payDuration;
        if (nextPayday > now) {
            revert();            
        }
        lastPayday = nextPayday;
        payee.payeeAddress.transfer(salary);
    }
    
// tests    
    function testGetPayeeName() returns (bool) {
        setPayeeName("Frank");
        return keccak256(getPayeeName()) == keccak256("Frank");
    }
    
    function testGetPayee() returns(bool){
        setPayee("Frank", 0xca35b7d915458ef540ade6068dfe2f44e8fa733c);
        return keccak256(getPayeeName()) == keccak256("Frank") && getPayeeAddress() == 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    }
    
    function testGetSalary() returns (bool) {
        setSalary(10000);
        return getSalary() == 10000;
    }

    
    function test() returns (bool) {
        return 1 wei == 1;
    }
    

}