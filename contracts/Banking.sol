// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// Uncomment this line to use console.log
import "hardhat/console.sol";

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

    // events
    error LowBalance(uint256 toSend, uint256 balance);
    error WithdrawalError(uint256 balance);
    event Transferred(address from, address to, uint amount);

    // getAccountNumber's address
    function getAccountAddress(
        string memory _accNum
    ) public view returns (address) {
        return accounts[_accNum].addr;
    }

    // getAccountNumber's address
    function getAccountBalance(
        string memory _accNum
    ) public view returns (uint256) {
        return accounts[_accNum].balance;
    }

    // withdraw from account
    function withdraw(
        string memory _accNum,
        uint256 _amount
    ) public returns (bool) {
        Accounts storage account = accounts[_accNum];
        unchecked {
            account.balance -= _amount;
            if (account.balance <= _amount) {
                revert WithdrawalError(account.balance);
            }
        }
        return true;
    }

    // deposit amount to account
    function deposit(
        string memory _accNum,
        uint256 _amount
    ) public returns (bool) {
        Accounts storage account = accounts[_accNum];
        account.balance += _amount;
        return true;
    }

    // make a transfer
    function transfer(
        string memory _sender,
        string memory _receiver,
        uint256 _amount
    ) public {
        // get sender account balance
        uint256 accBalance = getAccountBalance(_sender);

        // check if amount to be sent is more than sender's balance
        if (_amount > accBalance) {
            // return an error if balance is lower than sending
            revert LowBalance({toSend: _amount, balance: accBalance});
        } else {
            if (withdraw(_sender, _amount)) {
                if (deposit(_receiver, _amount)) {
                    emit Transferred(
                        getAccountAddress(_sender),
                        getAccountAddress(_sender),
                        _amount
                    );
                }
            }
        }
    }
}
