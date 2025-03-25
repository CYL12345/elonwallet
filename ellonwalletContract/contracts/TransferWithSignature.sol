// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract TransferWithSignature is Initializable{
    // 合约管理员地址
    address public admin;

    event SignatureVerified(bool result, address expected, address recovered);

    function initialize() initializer public {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin can call");
        _;
    }

    // 验证签名
    function verifySignature(
        address from,
        address to,
        uint256 amount,
        bytes memory signature
    ) internal returns (bool) {
        // 计算消息哈希
        bytes32 message = prefixed(keccak256(abi.encodePacked(from, to, amount)));
        // 恢复签名者地址并验证
        address recovered = recoverSignature(message, signature);
        bool result = recovered == from;
        emit SignatureVerified(result, from, recovered);
        return result;
    }

    // 恢复签名者地址
    function recoverSignature(bytes32 message, bytes memory signature)
        internal
        pure
        returns (address)
    {
        bytes32 r;
        bytes32 s;
        uint8 v;

        if (signature.length != 65) {
            revert("Invalid signature length");
        }

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        if (v < 27) {
            v += 27;
        }
        if (v != 27 && v != 28) {
            revert("Invalid signature v value");
        }
        // 恢复签名者地址
        return ecrecover(message, v, r, s);
    }

    // 添加前缀以避免签名被用于其他用途
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    // 签名验证后进行转账
    function transferWithSignature(
        address from,
        address to,
        uint256 amount,
        bytes memory signature
    ) external onlyAdmin {
        require(verifySignature(from, to, amount, signature), "invalid signature");
        require(from.balance >= amount, "insufficient balance");
        payable(to).transfer(amount);
    }

    receive() external payable {}
}



