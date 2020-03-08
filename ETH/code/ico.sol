pragma solidity ^0.4.20;

import './owner.sol';
//===========
//转账接口
//==========
interface token{
   function transfer(address _to,uint amount) external ;
}
//=====================================================
//ico合约，继承token的owner，另外定义一个账本保存信息和两个事件输出显示众筹实现输出信息
//=====================================================
contract ico is owner{
    uint public fundingGoal;
    uint public  deadline ;
    uint public price;
    uint public fundAmount;
    token public tokenReward;
    address public beneficiary;
    mapping(address=>uint )public balanceOf;
    event FundingTransfer(address backer ,uint amount);
    event CheckGoal(bool success);
    //===========================================================================
    //构造函数，定义了众筹的目标，截止时间，每个代币的价格，还有就是投资人的收益哦
	//===========================================================================
	
    constructor(uint fundingGoalInEthers,uint durationInMinutes,uint costOfEachToken,address addressOfToken){
        fundingGoal=fundingGoalInEthers*1 ether;
        deadline=now + durationInMinutes* 1 minutes;
        price=costOfEachToken* 1 ether;
        tokenReward=token(addressOfToken);
        beneficiary=msg.sender;
        
    }
    //============================
	//代币所有者拥有设定价格的权限
	//============================
	
    function setPrice(uint costOfEachToken )public onlyOwner{
         price=costOfEachToken* 1 ether;
    }
    //===========================
	//实现代币和以太币的自动兑换
	//===========================
    function() public payable{
        require(now<deadline);
        uint amount=msg.value;
        balanceOf[msg.sender]+=amount;
        fundAmount+=amount;
        uint tokenAmount=0;
        if(amount==0){
            tokenAmount=10;
        }else{
            tokenAmount=amount/price;
        }
        
        tokenReward.transfer(msg.sender,tokenAmount);
        emit FundingTransfer(msg.sender,amount);
    }
    
    //======
	//构造器
	//======
    modifier afterDeadline(){
         require(now >=deadline);
         _;
    }
    //============================
	//达到目标值输出事件，成功true
	//============================
	
    function checkGoalReached()public afterDeadline{
         if(fundAmount>=fundingGoal){
             emit CheckGoal(true);
         }   
    }
    //====================================================
	//到达预定时间没有达到目标筹集值，将筹集到的金额返回
	//====================================================
    function withdramal()public afterDeadline{
       
        if(fundAmount>=fundingGoal){
            if(beneficiary==msg.sender){
                 beneficiary.transfer(fundAmount);
            }
           
        }else{
            uint amount=balanceOf[msg.sender];
            if(amount>0){
                msg.sender.transfer(amount);
                balanceOf[msg.sender]=0;
            }
        }
    }
}