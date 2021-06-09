pragma solidity >=0.4.22 <0.9.0;

import "truffle/Assert.sol"; 
import "truffle/DeployedAddresses.sol"; 
import "../contracts/RouletteCC.sol";

contract RouletteTest 
{
    RouletteCC public roulette;
    CasinoCoin public coin;

     function beforeEach() public { 
        coin = new CasinoCoin();
        roulette = new RouletteCC(address(coin)); 
        coin.mint(address(this), 100);
        coin.approve(address(roulette), 100);
    }
    function testRed() public {
        uint256 balance_after = coin.balanceOf(address(this));
        roulette.Red(1);
        uint256 balance_before = coin.balanceOf(address(this));
        bool result = (balance_before != balance_after);
        assert(result, "Red don't work");
    }

    function testBlack() public {
        uint256 balance_after = coin.balanceOf(address(this));
        roulette.Black(1);
        uint256 balance_before = coin.balanceOf(address(this));
        bool result = (balance_before != balance_after);
        assert(result, "Black don't work");
    }
    
    function testBetOnNumber() public {
        uint256 balance_after = coin.balanceOf(address(this));
        roulette.BetOnNumber(1, 1);
        uint256 balance_before = coin.balanceOf(address(this));
        bool result = (balance_before != balance_after);
        assert(result, "BetOnNumber don't work");
    }
    function testLowerHalf() public {
        uint256 balance_after = coin.balanceOf(address(this));
        roulette.Red(1);
        uint256 balance_before = coin.balanceOf(address(this));
        bool result = (balance_before != balance_after);
        assert(result, "testLowerHalf don't work");
    }
    function testUpperHalf() public {
        uint256 balance_after = coin.balanceOf(address(this));
        roulette.UpperHalf(1);
        uint256 balance_before = coin.balanceOf(address(this));
        bool result = (balance_before != balance_after);
        assert(result, "testUpperHalf don't work");
    }
    function testOdd() public {
        uint256 balance_after = coin.balanceOf(address(this));
        roulette.Odd(1);
        uint256 balance_before = coin.balanceOf(address(this));
        bool result = (balance_before != balance_after);
        assert(result, "Odd don't work");
    }
    function testNoOdd() public {
        uint256 balance_after = coin.balanceOf(address(this));
        roulette.NoOdd(1);
        uint256 balance_before = coin.balanceOf(address(this));
        bool result = (balance_before != balance_after);
        assert(result, "NoOdd don't work");
    }    
}