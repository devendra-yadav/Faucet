
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Faucet{

    address payable public owner;
    mapping(address => uint256) timeLastReceived;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can execute this function");
        _;
    }

    event EtherReceived(address indexed from, uint256 amount);
    event FaucetCreated(address addr, uint256 initialBalance);

    constructor() payable{
        owner = payable(msg.sender);
        emit FaucetCreated(address(this), msg.value);
    }


    function withdraw(uint256 amount) public {
        require(amount <= 0.1 ether,"Cant ask for more than 0.1 ether");

        require((block.timestamp - timeLastReceived[msg.sender]) > 24*60*60, "Cant withdraw within 24 hours"  );
        timeLastReceived[msg.sender] = block.timestamp;
        payable(msg.sender).transfer(amount);
     
    }

    function lastWithdrawnTime(address input) external view returns(uint256){
        return timeLastReceived[input];
    }

    fallback() external payable {
        emit EtherReceived(msg.sender, msg.value);
    }

    receive() external payable{
        emit EtherReceived(msg.sender, msg.value);
    }

    function getFaucetBalance() external view returns(uint256){
        return address(this).balance;
    }

    function destroyFaucet() external onlyOwner{
        selfdestruct(owner);
    }

}
