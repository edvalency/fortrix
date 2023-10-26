// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Banking is ERC20, Ownable {
    uint public unlockTime;
    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

    constructor(
        uint _unlockTime,
        address owner,
        uint256 initialSupply
    ) public ERC20("ABSA Token", "ABSA") Ownable(owner) {
        // require(
        //     block.timestamp < _unlockTime,
        //     "Unlock time should be in the future"
        // );
        unlockTime = _unlockTime;
        _mint(msg.sender, initialSupply);
        balances[msg.sender] = initialSupply;
    }

    // function mint(address to, uint256 amount) public onlyOwner {
    //     _mint(to, amount);
    // }

    // events
    event LowBalance(uint256 toSend, uint256 balance);
    event WithdrawalError(uint256 balance);
    event Transferred(address from, address to, uint amount);
    event Deposited(address to, uint amount);

    // getAccountNumber's address
    // function getAccountAddress(
    //     string memory _accNum
    // ) public view returns (address) {
    //     return accounts[_accNum].addr;
    // }

    // getAccountNumber's balance
    function getAccountBalance(address _accNum) public view returns (uint256) {
        return balances[_accNum];
    }

    // // deposit amount to account
    // function makeDeposit(address _addr, uint256 _amount) public {
    //     balances[_addr] = balances[_addr] + _amount;
    //     emit Deposited(_addr, _amount);
    // }

    // get accounts

    // function getAccounts() public view returns () {
    //     return balances;
    // }

    // make a transfer
    function makeTransfer(
        address _sender,
        address _receiver,
        uint256 _amount
    ) public {
        // get sender account balance
        uint256 accBalance = getAccountBalance(_sender);

        // check if amount to be sent is more than sender's balance
        if (_amount > accBalance) {
            // return an error if balance is lower than sending
            emit LowBalance({toSend: _amount, balance: accBalance});
        } else {
            balances[_sender] = balances[_sender] - _amount;
            balances[_receiver] = balances[_receiver] + _amount;

            emit Transferred(_sender, _receiver, _amount);
        }
    }
}
