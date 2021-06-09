pragma solidity >=0.6.0 <0.9.0;

//алькоин на основе стандарта ERC20

//  let coin = await CasinoCoin.deployed()
//  coin.ExchangeEth({value: web3.utils.toWei('1', 'ether'), from: accounts[0]})
//  coin.approve('address-roulette', 10000)
//  coin.AddGame('address-roulette')
//  CasinoCoin.deployed().then(function(instance) { return instance.(GetBalance('0x91abA0aD6F65CD3611b09e5C8f42c67Ee5b87d75')); }).then(function(bn) { return bn.toString() });

contract CasinoCoin {

    string public name = "CasinoCoin"; // Название алькоина
    string public symbol = "CC"; // Аббривиатура
    uint8 public decimals = 0; // Количество знаков после запятой

    uint256 public totalSupply = 0; // Количество выпущенных монет

    mapping (address => uint256) public balanceOf; // массив аккаунтов и их балансов
    mapping (address => mapping (address => uint256)) public allowance;//разрешения на снятие денег каким-то адресам с других адресов

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event BuyCC(address indexed from, uint256 value);
    event BuyETH(address indexed from, uint256 value);

    address payable public owner_address;

    address[] games = new address[](0);  

    // курс обмена 1 eth -> CasinoCoin
    uint256 direct_exchange_rate = 1000000000000000000;
    // курс обмена CasinoCoin->  1 eth
    uint256 reverse_exchange_rate = 1000000000000000000;

    modifier owner_only() { 
     require(msg.sender == owner_address, "error-only-owner"); 
     _;
    }
    
    modifier games_only() { 
        bool is_game = false;
        for(uint256 i = 0; i < games.length; ++i)
            if(games[i] == msg.sender) is_game = true;
        require(is_game, "msg.sender is not a game");
        _;
    }
    
    constructor() public {
        owner_address = payable(msg.sender);
    }

    function _transfer(address _from, address _to, uint _value) internal {
        //проверка адресса назначения на пустоту, для удаления монет используется burn()
        require(_to != address(0x0), "Sender can't transfer currency to null address");
        //проверка на наличие переводимой суммы
        require(balanceOf[_from] >= _value, "Sender have no enough currency");
        //проверка на переполнение
        require(balanceOf[_to] + _value > balanceOf[_to], "You sent too much currency");
        // Сохраним предыдущий баланс для проверки 
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        // Проверка на соответсвие
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender], "Sender didn't approved such amount of currency");     // Проверка на возможность снятия
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Sender has no enough currency");   // Проверка баланса
        balanceOf[msg.sender] -= _value;            // Вычитаем из 
        totalSupply -= _value;                      // Обновление количества выпущенных монет
        emit Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, 'Sender has no enough currency');                //  Проверка баланса
        require(_value <= allowance[_from][msg.sender], "Sender didn't approved such amount of currency");    // проверка возможности снятия
        balanceOf[_from] -= _value;                         // вычитаем из баланса уничтожаемые монеты
        allowance[_from][msg.sender] -= _value;             // вычитаем из монеты разрешенных к снятию
        totalSupply -= _value;                              // вычитаем из общего количества выпущеных монет
        emit Burn(_from, _value);
        return true;
    }

    function GetBalance(address target) public view returns(uint256)
    {
        return balanceOf[target];
    }

    function GetAllowed(address from, address to) public view returns(uint256)
    {
        return allowance[from][to];
    }

    function set_direct_exchange_rate(uint256 target_value) public owner_only
    {
        direct_exchange_rate = target_value;    
    }

    function set_reverse_exchange_rate(uint target_value) public owner_only
    {
        reverse_exchange_rate = target_value;
    }

    function ExchangeEth() public payable
    {
        balanceOf[msg.sender] = balanceOf[msg.sender] + msg.value/direct_exchange_rate;      
        totalSupply += msg.value/direct_exchange_rate;
        emit BuyCC(msg.sender, msg.value);
    } 

    function ExchangeCC(uint256 value) public
    {
        require(address(this).balance >= value*reverse_exchange_rate, "Low contract balance");
        require(balanceOf[msg.sender] >= value, "Low user balace");
        
        balanceOf[msg.sender] -= value;
        payable(msg.sender).transfer(value*reverse_exchange_rate);
        emit BuyETH(msg.sender, value);
    }

    function AddGame(address new_game) public owner_only
    {
        address[] memory new_games = new address[](games.length+1);
        for(uint256 i = 0; i < games.length; ++i)
        {
            new_games[i] = games[i];
        }
        new_games[games.length] = new_game;
        games = new_games;
    }

    function mint(address _to, uint256 value) public
    {
        balanceOf[_to] += value;
        totalSupply += value;
    }

    function getGamesAddress() public view returns( address[] memory)
    {
        return games;
    }
}