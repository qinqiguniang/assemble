contract ERC20Interface {

    string public  name ;

    string public symbol;

    uint8 public  decimals;  
   
    uint public  totalSupply;

    function allowance(address _owner, address _spender) view returns (uint256 remaining);

    function approve(address _spender, uint256 _value) returns (bool success);

   function transfer(address _to, uint256 _value) returns (bool success);

   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);


   event Transfer(address indexed _from, address indexed _to, uint256 _value);

   event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}