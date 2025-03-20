// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./ProxyContract.sol";
import "./BaseContract.sol";

contract AdminContract is BaseContract{
    ProxyContract public proxy;

    constructor(address payable _proxy){
        proxy = ProxyContract(_proxy);
        admin = msg.sender;
    }

    function upgradeImplementation(address _newImplementation) public onlyAdmin {
        proxy.setImplementation(_newImplementation);
    }
}