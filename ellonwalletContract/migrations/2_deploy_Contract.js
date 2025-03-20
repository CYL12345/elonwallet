const TransferWithSignature = artifacts.require("TransferWithSignature");
const AdminContract = artifacts.require("AdminContract");

//引入 OpenZappin 的升级工具
const {deployProxy, upgradeProxy} = require("@openzeppelin/truffle-upgrades");
module.exports = async function (deployer, network, accounts) {
  //部署初始实现合约
  const implementation = await deployer.deploy(TransferWithSignature);
  console.log("Implementation Contract Address:", implementation.address);

  //部署代理合约并设置实现合约
  let Proxy = await deployProxy(TransferWithSignature,[],{deployer});
  console.log("Proxy deployed to:", Proxy.address);

  //部署管理员合约，并传入代理合约地址作为参数
  const AdminContract = await deployer.deploy(AdminContract, Proxy.address);
  console.log("Admin Contract deployed to:", AdminContract.address);

  
}