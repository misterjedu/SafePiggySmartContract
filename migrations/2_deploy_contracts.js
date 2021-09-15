const SpUsdToken = artifacts.require("SpUsdToken");
const SafePiggyToken = artifacts.require("SafePiggyToken");
const SafePiggySmartContract = artifacts.require("SafePiggySmartContract");

module.exports = async function (deployer) {
  //Deploy SpUsfToken
  await deployer.deploy(SpUsdToken);
  const spUsdToken = await SpUsdToken.deployed();

  //Deploy SafePiggyToken
  await deployer.deploy(SafePiggyToken);
  const safePiggyToken = await SafePiggyToken.deployed();

  //Deploy TokenFarm
  await deployer.deploy(
    SafePiggySmartContract,
    spUsdToken.address,
    safePiggyToken.address
  );
  const safePiggySmartContract = await SafePiggySmartContract.deployed();

  //Transfer all tokens from DappToken to TokenFarm
  await spUsdToken.transfer(
    safePiggySmartContract.address,
    "1000000000000000000000000"
  );

  //Transfer 100 DaiTokens to an investor
  // await safePiggyToken.transfer(accounts[1], "100000000000000000000");
};
