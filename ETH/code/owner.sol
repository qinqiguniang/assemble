pragma solidity ^0.4.20;

contract owner{
    
    address public owner ;
    
    constructor() public{
        owner=msg.sender;
    }
    
    modifier onlyOwner{
        require(msg.sender==owner );
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner{
        owner =newOwner;
    }
    
}