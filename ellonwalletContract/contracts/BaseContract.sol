// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BaseContract{
    address public admin;
    constructor(){
        admin = msg.sender;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin,"only admin can call");
        _;
    }
}