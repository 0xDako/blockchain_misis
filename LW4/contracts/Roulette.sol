// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

    // truffle(development)> let test = await Roulette.deployed()
    // undefined
    // truffle(development)> test.addToContract({value: web3.utils.toWei('2', 'ether'), from: accounts[0]})
    // test.Red({value: web3.utils.toWei('0.5', 'ether'), from: accounts[1]})

contract Roulette {
    
    address payable public owner_address;
    address payable public last_player_address;
    address payable public contract_address;
    uint256 public last_win_num;

    uint16[] public red_number = [0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1];

    event PlayTheGame(address player_address, uint256 value, string game, bool results);
    event Withdraw(uint256 value);
    event UpdateAdminAdress(address new_admin_address);

    modifier owner_only() 
    { 
      require(msg.sender == owner_address, "error-only-owner");
      _;
    }

    modifier balance_check(uint16 multiplier)
    {
        require(contract_address.balance > msg.value*multiplier, "not-enough-eth");
        _;
    }

    constructor() {
        contract_address = payable(address(this));
        owner_address = payable(msg.sender);
    }

    function transfer_to(address payable to, uint256 value) private 
    {
        to.transfer(value);
    }

    function AddToContractBalance() payable public owner_only returns(string memory)
    {
        return ("Add successfully");
    }

    function WithdrawFromContractBalance(uint256 value) public owner_only returns(string memory)
    {
        require(contract_address.balance >= value);
        owner_address.transfer(value);
        emit Withdraw(value);
        return ("Withdraw successfully"); 
    }

    function ChangeOwner(address new_admin) public owner_only{
        owner_address = payable(new_admin);
        emit UpdateAdminAdress(new_admin);
    }

    function random() private view returns (uint256) {
        uint256 rnd = uint256(keccak256(abi.encodePacked(block.timestamp)));
        return (rnd % 37); 
    }


    function Red() public payable balance_check(2) returns(string memory)
    {             

        last_player_address = payable(msg.sender);
        last_win_num = random();

         if(red_number[last_win_num] == 1){
            transfer_to(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "Red", true);
            return "You won! Congratulations!";
            }
        emit PlayTheGame(msg.sender, msg.value, "Red", false);
        return "You lose. Try again.";
    }
    function Black() public payable balance_check(2) returns(string memory){             

        last_player_address = payable(msg.sender);
        last_win_num = random();

        if(red_number[last_win_num] == 0 && last_win_num != 0){
            transfer_to(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "Black", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "Black", false);
        return "You lose. Try again.";
    }

    function BetOnNumber(uint16 number) public payable balance_check(35) returns(string memory){
        last_player_address = payable(msg.sender);
        last_win_num = random();   

        if(last_win_num == number){
            transfer_to(payable(msg.sender), msg.value*35);
            emit PlayTheGame(msg.sender, msg.value, "BetOnNumber", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "BetOnNumber", false);
        return "You lose. Try again.";
    }
    
    function LowerHalf() public payable balance_check(2) returns(string memory){
        last_player_address = payable(msg.sender);
        last_win_num = random();
        if (last_win_num <= 18 &&  last_win_num !=0) {
            transfer_to(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "LowerHalf", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "LowerHalf", false);
        return "You lose. Try again.";
    }

    function UpperHalf() public payable balance_check(2) returns(string memory){
        last_player_address = payable(msg.sender);
        last_win_num = random();
        if (last_win_num >= 19 ) {
            transfer_to(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "UpperHalf", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "UpperHalf", false);
        return "You lose. Try again.";
    }

    function Odd() public payable balance_check(2) returns(string memory){

        last_player_address = payable(msg.sender);
        last_win_num = random();
        if (last_win_num % 2 == 0 && last_win_num != 0)
        {
            transfer_to(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "Odd", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "Odd", false);
        return "You lose. Try again.";
    }

    function NoOdd() public payable balance_check(2) returns(string memory){

        last_player_address = payable(msg.sender);
        last_win_num = random();
        if (last_win_num % 2 == 1)
        {
            transfer_to(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "NoOdd", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "NoOdd", false);
        return "You lose. Try again.";
    }
}
