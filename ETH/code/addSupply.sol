pragma solidity ^0.4.20;

import './erc20.sol';
import './owner.sol';

contract addSupply is erc20,owner {
    
    event ChangeSupply(uint mount);
    event IsFrozenAccount(address target,bool isFrozen);
    event Burn(address target,uint amount);
    mapping(address=>bool)public frozenAccount;
    
    constructor(string _name) erc20(_name) public {
        
    }
    
    function min(address target ,uint mount )public onlyOwner {
        totalSupply+=mount;
        balanceOf[target]+=mount;
        
        emit ChangeSupply(mount);
        emit Transfer(0,target,mount);
        
    }
    
    function frozenAccount(address target,bool isFrozen)public onlyOwner{
        frozenAccount[target]=isFrozen;
        emit IsFrozenAccount(target,isFrozen);
    }
    
    function transfer(address _to, uint256 _value)public returns (bool success){
        require(_to !=address(0));
        require(!frozenAccount[msg.sender]);
        require(balanceOf[msg.sender]>=_value);
        require(balanceOf[_to]+_value>=balanceOf[_to]);
        
        balanceOf[msg.sender]-=_value;
        balanceOf[_to]+=_value;
        
        emit Transfer(msg.sender,_to,_value);
        return true;
        
    }

    function transferFrom(address _from, address _to, uint256 _value)public returns (bool success){
        require(_to!=address(0));
        require(!frozenAccount[_from]);
        require(allowed[_from][msg.sender]>=_value);
        require(balanceOf[msg.sender]>=_value);
        require(balanceOf[_to]+_value>=balanceOf[_to]);
        
        allowed[msg.sender][_from]-=_value;
        balanceOf[msg.sender]-=_value;
        balanceOf[_to]+=_value;
        return true;
    }
    
    function burn(uint256 _value) public returns(bool success){
        require(balanceOf[msg.sender]>=_value);
        totalSupply-=_value;
        balanceOf[msg.sender]-=_value;
        
        emit Burn(msg.sender,_value);
        return true;
    }
    
    function burnFrom(address _from,uint256 _value)public returns(bool success){
        require(balanceOf[_from]>=_value);
        require(allowed[_from][msg.sender]>=_value);
        totalSupply-=_value;
        balanceOf[msg.sender]-=_value;
        allowed[_from][msg.sender]-=_value;
        
        emit Burn(msg.sender,_value);
        return true;
    }
}