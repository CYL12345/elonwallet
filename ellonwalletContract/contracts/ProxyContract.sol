// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

//import "./BaseContract.sol";

contract ProxyContract {
    address public implementation;
     address public admin;
    constructor(address _implementation){
        implementation = _implementation;
    }

     modifier onlyAdmin(){
        require(msg.sender == admin,"only admin can call");
        _;
    }

    function setImplementation(address _newImplementation) public onlyAdmin {
        implementation = _newImplementation;
    }

    fallback() external payable {
        address _impl = implementation;
        assembly {
            calldatacopy(0,0,calldatasize())
            //call the implementation
            let result := delegatecall(gas(),_impl,0,calldatasize(),0,0)
            //copy returned data
            returndatacopy(0,0,returndatasize())

            switch result
            case 0 {revert(0,returndatasize())}
            default {return(0,returndatasize())}
        }
    }
    receive() external payable {}
}