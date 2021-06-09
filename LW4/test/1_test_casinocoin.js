const CasinoCoin = artifacts.require("CasinoCoin");

var BN = web3.utils.BN;
var Hex = web3.utils.toHex;
var Decimal = web3.utils.toDecimal;

contract("CasinoCoin test", async (accounts) =>{ 
    it(`Тест CasinoCoin::ExchangeEth, покупка 3 СС за 3 Eth c ${accounts[1]}`, async () =>{
        const CC = await CasinoCoin.deployed();
        await CC.ExchangeEth({value: web3.utils.toWei('3', 'ether'), from: accounts[1]});
        let balance = await CC.GetBalance(accounts[1]);
        assert.equal(Decimal(balance), 3);
    }
    );

    it(`Тест CasinoCoin::ExchangeCC, продажа 1 СС за 1 Eth c ${accounts[1]}`, async () =>{
        const CC = await CasinoCoin.deployed();
        await CC.ExchangeCC(1, {from: accounts[1]});
        let balance = await CC.GetBalance(accounts[1]);
        assert.equal(Decimal(balance), 2);
    }
    );

    it(`Тест CasinoCoin::transfer, перевод 1 СС с ${accounts[1]} на ${accounts[2]}`, async () =>{
        const CC = await CasinoCoin.deployed();
        await CC.transfer(accounts[2], 1, {from: accounts[1]})
        let balance = await CC.GetBalance(accounts[2]);
        assert.equal(Decimal(balance), 1);
    }
    );

    it(`Тест CasinoCoin::AddGame, добавим игру с адресом 0x873E882723542767378D879bF2B1ceDc2D485B01`, async () =>{
        const CC = await CasinoCoin.deployed();
        await CC.AddGame('0x873E882723542767378D879bF2B1ceDc2D485B01');
        let games = await CC.getGamesAddress();
        assert.equal('0x873E882723542767378D879bF2B1ceDc2D485B01', games[0]);
    });

    it(`Тест CasinoCoin::mint, выпустим 10 СС на ${accounts[4]}`, async () =>{
        const CC = await CasinoCoin.deployed();
        await CC.AddGame(accounts[0]);
        await CC.mint(accounts[4], 10);
        let balance = await CC.GetBalance(accounts[4]);
        assert.equal(Decimal(balance), 10);
    }
    );

    it(`Тест CasinoCoin::burn сожем 5 CC с ${accounts[4]}`, async () =>{
        const CC = await CasinoCoin.deployed();
        await CC.burn(5, {from: accounts[4]});
        let balance = await CC.GetBalance(accounts[4]);
        assert.equal(Decimal(balance), 5);
    }
    );

})