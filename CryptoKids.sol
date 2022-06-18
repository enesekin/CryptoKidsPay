//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

contract CryptoKids{

    address owner;

    constructor(){
        owner= msg.sender;
    }

    struct Kid{
        address walletAddress;
        string fullName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    Kid[] public kids;
    function addKids(address walletAddress, string memory fullName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public {
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
            }
        }
    }

    function getIndex(address walletAddress) view public returns(uint){
        for(uint i = 0 ; i < kids.length ; i++){
            if(kids[i].walletAddress == walletAddress){
                return i;
            }
            return 999;
        }
    }

    function availableToWithDraw(address walletAddress) public returns(bool){

    }
}