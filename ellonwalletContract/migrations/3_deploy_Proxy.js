const TransferWithSignature = artifacts.require("TransferWithSignature");
const AdminContract = artifacts.require("AdminContract");
//增加兼容性
//const { ReadableStream } = require('stream/web'); // ES 模块
// 或者
//const { ReadableStream } = require('web-streams-polyfill'); // CommonJS 模块

//引入 OpenZappin 的升级工具
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

module.exports = async function (deployer, network, accounts) {
  //部署初始实现合约
  //const implementation = await deployer.deploy(TransferWithSignature,{ gas: 5000000 });

  //部署代理合约并设置实现合约
  let Proxy = await deployProxy(TransferWithSignature,[],{ deployer });
  console.log('Deployed', Proxy.address);
  //部署管理员合约，并传入代理合约地址作为参数
  //const AdminContract = await deployer.deploy(AdminContract, Proxy.address);

  
}