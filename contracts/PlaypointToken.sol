// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PlaypointToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Playpoint", "PPTT") {
        _mint(msg.sender, initialSupply);
    }
}