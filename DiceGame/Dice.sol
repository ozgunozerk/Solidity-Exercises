pragma solidity ^0.6.1;


contract DiceGame{
    struct player {
        string name;
        uint8 age;
        uint balance;
        bool exists;
        bool House;
    }
    
    
    mapping(address => player) private players;
    
    
    address payable private houseAddress;
    
    
    constructor(address payable homeAddress) public payable {
        houseAddress = homeAddress;
        players[houseAddress] = player("house", 0, 0, true, true);
    }
    
    
    function register(string memory _name, uint8 _age) public {
        require(players[msg.sender].exists == false && msg.sender != houseAddress);  // should not be the house itself and not be present in the database beforehand
        players[msg.sender] = player(_name, _age, 0 ether, true, false);  // registration operation itself
    }

    function houseDeposit() public payable {
        require(houseAddress == msg.sender);  // only house can do this
        players[houseAddress].balance += msg.value;  // necessary balance operations
    }
    
    
    function houseWithdraw(uint amount) public {
        require(players[houseAddress].balance >= amount && houseAddress == msg.sender);  // only house can do this, and can only withdraw the existing money
        houseAddress.transfer(amount);
        players[houseAddress].balance -= amount;
    }

    
    function playerDeposit() payable public {
        require(players[msg.sender].exists == true && msg.sender != houseAddress);  // should be existing in the database and should be different from house
        players[msg.sender].balance += msg.value;
    }

    
    function playerWithdraw(uint amount) public {
        require(players[msg.sender].balance >= amount && msg.sender != houseAddress); // should be different than house and can only withdraw the existing money
        msg.sender.transfer(amount);
        players[msg.sender].balance -= amount;
    }
    
    
    function bet(uint amount) public {
        require(players[msg.sender].balance >= amount && players[houseAddress].balance >= amount && amount <= 0.1 ether && msg.sender != houseAddress);  // too long to explain xd, look below
        uint256 encodedDice = now;  // get the time
        uint8 decodedDice = uint8(encodedDice % 6);  // make it module 6
        uint8 Dice = decodedDice + 1;  // add 1, Dice is ready!
        
        if (Dice >= 4) {  // player wins
            players[msg.sender].balance += amount; 
            players[houseAddress].balance -= amount;
        }
        else{  // hosue wins
            players[msg.sender].balance -= amount;
            players[houseAddress].balance += amount;
        }
    }
}
