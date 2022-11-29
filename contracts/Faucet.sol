// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract PlaypointFaucet{
    IERC20 public PPTTToken;
    mapping(address => uint8) public users;
    bool internal locked;

    constructor(address _token){
        PPTTToken = IERC20(_token);
    }

    modifier reentrancyGuard() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    modifier _checkRequest(address _user) {
        require(users[_user] != 1, "User has already request limited PPTT Token!");
        _;
    }

    function requestPPTT() _checkRequest(msg.sender) reentrancyGuard public returns (uint8){
        PPTTToken.transfer(msg.sender, 500000000000000000000000);
        users[msg.sender] = 1;
        return 1;
    }
}