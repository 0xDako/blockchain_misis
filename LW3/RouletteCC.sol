// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "contracts/CasinoCoin.sol";

contract Roulette {
    
    address public owner_address;
    address public last_player_address;
    uint256 public last_win_num;
    CasinoCoin public token;

    uint16[] public red_number = [0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1];

    // truffle(development)> let test = await Roulette.deployed()
    // undefined
    // truffle(development)> test.addToContract({value: web3.utils.toWei('2', 'ether'), from: accounts[0]})

    event PlayTheGame(address player_address, uint256 value, string game, bool results);
    event UpdateAdminAdress(address new_admin_address);

    modifier owner_only() { 
      require(msg.sender == owner_address, "error-only-owner"); 
      _;
    }

    constructor() {
        owner_address = payable(msg.sender);
    }

    function send_win(address to, uint256 value) private 
    {
        token.Emit(to, value);
    }
    function take_lose(address from, uint256 value) private 
    {
        token.burnFrom(from, value);
    }

    function ChangeOwner(address new_admin) public owner_only{
        owner_address = payable(new_admin);
        emit UpdateAdminAdress(new_admin);
    }

    function random() private view returns (uint256) {
        uint256 rnd = uint256(keccak256(abi.encodePacked(block.timestamp)));
        return (rnd % 37); 
    }


    function Red(uint256 value) public payable returns(string memory){         
        require( value <= token.GetAllowed(msg.sender, address(this)), "Allow withdraw first");

        last_player_address = msg.sender;
        last_win_num = random();

         if(red_number[last_win_num] == 1){
                send_win(msg.sender,value);
                emit PlayTheGame(msg.sender, msg.value, "Red", true);
                return "You won! Congratulations!";
            }
            else{
                take_lose(msg.sender, value);
                emit PlayTheGame(msg.sender, msg.value, "Red", false);
                return "You lose. Try again.";
            }
    }
    function Black(uint value) public payable returns(string memory){    
        require( value <= token.GetAllowed(msg.sender, address(this)), "Allow withdraw first");

        last_player_address = payable(msg.sender);
        last_win_num = random();

        if(red_number[last_win_num] == 0 && last_win_num != 0){
            send_win(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "Black", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "Black", false);
        return "You lose. Try again.";
    }

    function BetOnNumber(uint16 number, uint256 value) public payable  returns(string memory){
        require( value <= token.GetAllowed(msg.sender, address(this)), "Allow withdraw first");
        last_player_address = payable(msg.sender);
        last_win_num = random();   

        if(last_win_num == number){
            send_win(payable(msg.sender), msg.value*35);
            emit PlayTheGame(msg.sender, msg.value, "BetOnNumber", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "BetOnNumber", false);
        return "You lose. Try again.";
    }
    
    function LowerHalf(uint256 value) public payable  returns(string memory){
        require( value <= token.GetAllowed(msg.sender, address(this)), "Allow withdraw first");
        last_player_address = payable(msg.sender);
        last_win_num = random();
        if (last_win_num <= 18 &&  last_win_num !=0) {
            send_win(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "LowerHalf", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "LowerHalf", false);
        return "You lose. Try again.";
    }

    function UpperHalf() public payable returns(string memory){
        last_player_address = payable(msg.sender);
        last_win_num = random();
        if (last_win_num >= 19 ) {
            send_win(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "UpperHalf", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "UpperHalf", false);
        return "You lose. Try again.";
    }

    function Odd() public payable  returns(string memory){

        last_player_address = payable(msg.sender);
        last_win_num = random();
        if (last_win_num % 2 == 0 && last_win_num != 0)
        {
            send_win(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "Odd", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "Odd", false);
        return "You lose. Try again.";
    }

    function NoOdd() public payable  returns(string memory){

        last_player_address = payable(msg.sender);
        last_win_num = random();
        if (last_win_num % 2 == 1)
        {
            send_win(payable(msg.sender), msg.value*2);
            emit PlayTheGame(msg.sender, msg.value, "NoOdd", true);
            return "You won! Congratulations!";
        }
        emit PlayTheGame(msg.sender, msg.value, "NoOdd", false);
        return "You lose. Try again.";
    }
}
