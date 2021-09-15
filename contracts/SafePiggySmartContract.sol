// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import './SpUsdToken.sol';
import './SafePiggyToken.sol';


contract  SafePiggySmartContract {
    
    string public name = "Safe Piggy Dapp";
    address public owner;
    
    SpUsdToken public spUsdToken;
    SafePiggyToken public safePiggyToken;
    
    address[] public savers;
    address[] public lockers;
    
    uint public totalSavedSpUsd;
    uint public totalLockedSpUsd;
    uint public totalDistributedSpt;
    uint public withdrawnEarnedToken;
    uint public avaliableSpt;
    
    
    struct AccountBalance{
        uint spUsdSaved;
        uint timeStamp;
        LockedBalance lockedBalance;
        uint sptEarned;
    }
    
    struct LockedBalance{
        uint spUsdLocked;
        uint timeStamp;
    }
    
    mapping(address => AccountBalance) public savedBalance;
    mapping(address => uint) public lockedBalance;
    mapping(address => bool) public userHasSaved;
    mapping(address => bool) public userIsSaving;
    mapping(address => bool) public userHasLocked;
    mapping(address => bool) public userIsLocking;
    
    
    enum LockingPlan { COPPER, BRONZE, SILVER, GOLD, DIAMOND, PLATINUM }    
    
    
    
    constructor( SpUsdToken  _spUsdToken , SafePiggyToken _safePiggyToken) {
        spUsdToken = _spUsdToken;
        safePiggyToken = _safePiggyToken;
        owner = msg.sender;
        
    }
    
     modifier isOwner {
      require(msg.sender == owner, "Only the owner is allowed to call this function");
      _;
     }
    
    // Check if the user has enough SpUsdToken to save
    modifier hasEnoughSpUsd(address _address, uint _amount){
        require(_amount > 0 &&  spUsdToken.balanceOf(_address) >= _amount, "Not enough SpUsdToken to save");
        _;
    }
    
    
    //Calculate Interest to be awarded a user for the amount saved
    function calculateInterest(uint _spUsdTokenSaved ) public returns (uint) {
        
        
    }
    
    // Save SpUsdToken tokens
    function saveSpUsdToken(uint _amount) public  hasEnoughSpUsd(msg.sender, _amount) {
        
      /*
        Create user account struct
        Transfer money from user account to contract address (User must approve this)
        Add user account struct to saved balance mapping
        Increase totalSavedSpUsd by amount saved by user
        Add user address to savers array
      */
    
     spUsdToken.transferFromAddress(owner, msg.sender, address(this), _amount);
      
      uint newSavedUsdToken = getUserSavedUsd(msg.sender) + _amount;
      savedBalance[msg.sender] = AccountBalance(newSavedUsdToken, block.timestamp, savedBalance[msg.sender].lockedBalance, savedBalance[msg.sender].sptEarned);
      totalSavedSpUsd += _amount;
      
      if(!userHasSaved[msg.sender]){
        userHasSaved[msg.sender] = true;
        userIsSaving[msg.sender] = true;
        savers.push(msg.sender);
      }
     
    }
    
    
    //Withdraw saved SpUsdTokens
    function withdrawSavedToken(uint _amount) public {
        
        uint userSavedUsd = getUserSavedUsd(msg.sender);
        
        require (userSavedUsd >= _amount, "Insufficient balance");
        
        spUsdToken.transfer(msg.sender, userSavedUsd);
        
        savedBalance[msg.sender].spUsdSaved -= _amount;
         
        totalSavedSpUsd -= _amount;
         
        if(getUserSavedUsd(msg.sender) <= 0){
             userIsSaving[msg.sender] = false;
         }
    
    }
    
    
    
    //User Stakes some of part of their saved coins
    function stakeUsdToken(uint _amount) public  {
        
        uint userSavedUsd = getUserSavedUsd(msg.sender);
        
        require(userSavedUsd >= _amount, "Insufficient balance");
        
        savedBalance[msg.sender].spUsdSaved -= _amount;
        savedBalance[msg.sender].lockedBalance.spUsdLocked += _amount;
        userHasLocked[msg.sender] = true;
        userIsLocking[msg.sender] = true;
        lockers.push(msg.sender);
        
    }
    
    
    
    address public myAddress = address(this);
    
    
    
    function unStakeUsdToken(uint _amount) public {
        
        uint userLockedUsd = getUserLockedUsd(msg.sender);
        
        require(userLockedUsd >= _amount, "Insufficient balance");
        
        savedBalance[msg.sender].spUsdSaved += _amount;
        savedBalance[msg.sender].lockedBalance.spUsdLocked -= _amount;
        
        userHasLocked[msg.sender] = false;
        userIsLocking[msg.sender] = false;
        
    }
    
    
    function withdrawEarnedToken() public {
        
    //TODO (Require time staked, plan and time to withdraw)
     
     uint earnedSptToken = getUserEarnedSpt(msg.sender);
    
     require(earnedSptToken > 10000, "You don't have enough tokens");
    
     safePiggyToken.transfer(msg.sender, earnedSptToken);
    
     withdrawnEarnedToken += earnedSptToken;
        
    }
    
    
    function getUserSavedUsd(address _address) public view returns (uint){
       return savedBalance[_address].spUsdSaved;
    }
    
    function getUserLockedUsd(address _address) public view returns (uint){
       return savedBalance[_address].lockedBalance.spUsdLocked;
    }
    
    function getUserEarnedSpt(address _address) public view returns (uint){
       return savedBalance[_address].sptEarned;
    }
    
    function getUserUsdBalance() public view returns (uint){
       return spUsdToken.balanceOf(msg.sender);
    }
    
    
    function transferSpUsd(address _account, uint amount) public returns (bool) {
        return  spUsdToken.transferAddress(owner, _account, amount);
    }
    
    function approveSpusd(address spender, uint256 amount) public returns (bool) {
        return spUsdToken.approveAddress(msg.sender,spender, amount );
    }
  
    
    
    
}