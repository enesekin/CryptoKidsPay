//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

contract CryptoKids{

    address owner;

    event LogKidFundingReceived(address addr, uint amount, uint contractBalance);
    constructor(){
        owner= msg.sender;
    }

    struct Kid{
        address payable walletAddress;
        string fullName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    modifier onlyOwner(){
       require(msg.sender == owner, "Only the owner can add kids");
       _; // Onlyowner olarak eklediğimiz fonksiyon bunun devamı şeklinde çalışacak
    }

    Kid[] public kids;

    function addKids(address payable walletAddress, string memory fullName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner{
        kids.push(Kid(
            walletAddress,
            fullName,
            lastName,
            releaseTime,
            amount,
            canWithdraw
        ));

    }

    function balanceOf() public view returns(uint){
        return address(this).balance;
    }

    function deposit(address walletAddress) payable public{
        addToKidsBalance(walletAddress);
    }

    function addToKidsBalance(address walletAddress) private{
        for(uint i = 0 ; i < kids.length ; i++){
            if(kids[i].walletAddress == walletAddress){
                kids[i].amount += msg.value;
                emit LogKidFundingReceived(walletAddress, msg.value, balanceOf());
            }
        }
    }

    function getIndex(address walletAddress) view private returns(uint){
        for(uint i = 0; i < kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                return i;
            }
        }
        return 999;

    }

    function availableToWithDraw(address walletAddress) public returns(bool){
        uint i = getIndex(walletAddress);
        require(block.timestamp > kids[i].releaseTime, "You cannot withdraw yet");
        if(block.timestamp > kids[i].releaseTime){
        kids[i].canWithdraw = true;
        return kids[i].canWithdraw;
    }else{
        return false;
    }
    }


    function withdraw(address walletAddress) payable public{
        uint i = getIndex(walletAddress);
        require(msg.sender == kids[i].walletAddress, "You must be the kid to withdraw");
        require(kids[i].canWithdraw == true, "You are not able to withdraw at this time");
        kids[i].walletAddress.transfer(kids[i].amount);
    }
}