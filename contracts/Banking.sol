// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Banking {
    // User details
    struct UserDetails {
        uint256 id;
        string name;
        string email;
        string phone;
        string country;
        string residence;
    }
    // Accounts
    struct Accounts {
        uint256 id;
        uint256 usrId;
        address addr;
        string currency;
        uint256 balance;
    }

    // Storing user details
    mapping(uint256 => UserDetails) private userDetails; //storing organisations and their addresses
    uint256[] private userDetailsIds; //Store organisations id

    string[] private accountsIds; //Store accounts id
    mapping(string => Accounts) private accounts; //storing accounts and their addresses with related user details

    // Store customer data
    function storeData(
        string memory _name,
        string memory _email,
        string memory _phone,
        string memory _country,
        string memory _residence,
        string memory _currency,
        uint256 _balance,
        address _addr,
        string memory _accNum
    ) public returns (bool) {
        uint256 _id = userDetailsIds.length + 1;
        uint256 _aid = accountsIds.length + 1;

        // store user details
        userDetails[_id] = UserDetails({
            id: _id,
            name: _name,
            email: _email,
            phone: _phone,
            country: _country,
            residence: _residence
        });
        userDetailsIds.push(_id);
        // store user account address with user details id
        accounts[_accNum] = Accounts({
            id: _aid,
            usrId: _id,
            addr: _addr,
            currency: _currency,
            balance: _balance
        });
        accountsIds.push(_accNum);

        return true;
    }

    // getAccount
    function getAccountAddress(string memory _accNum) public view returns (address) {
        return accounts[_accNum].addr;
    }

    // function localTransfer(address sender, address receiver,uint256 amount) public {
    //     require(msg.sender);
    // }
}

// contract ABSAToken is ERC20 {
//     address public owner;

//     constructor() ERC20("ABSA Token", "ABSA") {
//         owner = msg.sender;
//     }

//     // Add a restriction to only ABSA
//     modifier onlyAbsa() {
//         require(msg.sender == owner, "Restricted to ABSA only");
//         _;
//     }

//     function mint(address to, uint256 amount) public onlyAbsa {
//         _mint(to, amount);
//     }
// }
