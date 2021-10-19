// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface CandlesInterface {
    function send(address from, address to, uint _id) external;
    function approveStaking(uint _id) external;
}

contract Staking {
    
    address member1 = 0x1002CA2d139962cA9bA0B560C7A703b4A149F6e0;
    uint monthlyReward = 800000;
    uint supply = 3250;
    
    uint stacksCounter;
    mapping (uint => uint) candleToStack;
    
    struct Stack {
        address owner;
        uint duration;
        uint id;
        uint unlockBlock;
    }
    Stack[] public stacks;
    
    CandlesInterface public candles = CandlesInterface(0xb91E3fDe5B9d96D0cCbC437dFB31d4088848b990);
    
    function setMonthlyReward(uint _amount) public onlyMember1 {
        monthlyReward = _amount;
    }
    
    function setSupply(uint _amount) public onlyMember1 {
        supply = _amount;
    }
    
    //Stake for 1 minute
    function stake0(uint _id) public {
        candles.send(msg.sender, address(this), _id);
        stacks.push(Stack(msg.sender, 0, _id, block.number+5));
        candleToStack[_id] = stacksCounter;
        stacksCounter++;
    }
    
    //Stake for 1 day
    function stake1(uint _id) public {
        candles.send(msg.sender, address(this), _id);
        stacks.push(Stack(msg.sender, 1, _id, block.number+6520));
        candleToStack[_id] = stacksCounter;
        stacksCounter++;
    }
    
    //Stake for 3 days
    function stake2(uint _id) public {
        candles.send(msg.sender, address(this), _id);
        stacks.push(Stack(msg.sender, 2, _id, block.number+19560));
        candleToStack[_id] = stacksCounter;
        stacksCounter++;
    }
    
    //Stake for 1 week
    function stake3(uint _id) public {
        candles.send(msg.sender, address(this), _id);
        stacks.push(Stack(msg.sender, 3, _id, block.number+45640));
        candleToStack[_id] = stacksCounter;
        stacksCounter++;
    }
    
    //Stake for 2 weeks
    function stake4(uint _id) public {
        candles.send(msg.sender, address(this), _id);
        stacks.push(Stack(msg.sender, 4, _id, block.number+91280));
        candleToStack[_id] = stacksCounter;
        stacksCounter++;
    }
    
    //Stake for 1 month
    function stake5(uint _id) public {
        candles.send(msg.sender, address(this), _id);
        stacks.push(Stack(msg.sender, 5, _id, block.number+198860));
        candleToStack[_id] = stacksCounter;
        stacksCounter++;
    }

    function unstake(uint _id) public {
        require(msg.sender == stacks[candleToStack[_id]].owner);
        require(block.number >= stacks[candleToStack[_id]].unlockBlock);
        
        candles.send(address(this), msg.sender, _id);
        
        if (stacks[candleToStack[_id]].duration == 1) {
            payable(msg.sender).transfer((monthlyReward*10/400)/supply);
            
        } else if (stacks[candleToStack[_id]].duration == 2) {
            payable(msg.sender).transfer((monthlyReward*10/120)/supply);
            
        } else if (stacks[candleToStack[_id]].duration == 3) {
            payable(msg.sender).transfer((monthlyReward*10/48)/supply);
            
        } else if (stacks[candleToStack[_id]].duration == 4) {
            payable(msg.sender).transfer((monthlyReward*10/22)/supply);
            
        } else if (stacks[candleToStack[_id]].duration == 5) {
            payable(msg.sender).transfer((monthlyReward*125/10)/supply);
            
        }
    }
    
    function getAPR(uint floorPrice, uint duration) public view returns(uint) {
        if (duration == 1) {
            uint result = (monthlyReward*3650/400)/supply;
            return 100*result/floorPrice;
            
        } else if (duration == 2) {
            uint result = (monthlyReward*1220/120)/supply;
            return 100*result/floorPrice;
            
        } else if (duration == 3) {
            uint result = (monthlyReward*520/48)/supply;
            return 100*result/floorPrice;
            
        } else if (duration == 4) {
            uint result = (monthlyReward*260/22)/supply;
            return 100*result/floorPrice;
            
        } else { //duration = 5
            uint result = (monthlyReward*125/10)/supply;
            return 100*result/floorPrice;
        }
    }
    
    //MODIFIER
    modifier onlyMember1 {
        require(msg.sender == member1);
    _;
    }
}
