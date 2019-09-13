var CompliantCoupon = artifacts.require("CompliantCoupon");
var SingleLimitTransferChecker = artifacts.require("SingleLimitTransferChecker");
var TransferPolicy = artifacts.require("TransferPolicy");
var AccountStatusPolicySelector = artifacts.require("AccountStatusPolicySelector");

require("./test-setup");

contract('Account status policy selector', function ([operator, normal, accredited, recipient]) {

  var compliantCoupon, policyNormal, policyAccredited, policySelector;
  var limitCheckerLow, limitCheckerHigh;

  step("should define policy for normal investors", async function () {
    compliantCoupon = await CompliantCoupon.new(100);

    policyNormal = await TransferPolicy.new();
    limitCheckerLow = await SingleLimitTransferChecker.new(10);
    await policyNormal.addChecker(limitCheckerLow.address, {from:operator});

    policySelector = await AccountStatusPolicySelector.new(policyNormal.address);
    await compliantCoupon.setPolicySelector(policySelector.address);
  });


  step("should setup normal investor", async function () {
    await compliantCoupon.mint(normal, 100);

    (await compliantCoupon.balanceOf(normal)).should.be.bignumber.equal('100');
    (await compliantCoupon.balanceOf(recipient)).should.be.bignumber.equal('0');
  });


  step("should allow transfers withing limit for normal investors", async function () {

    await compliantCoupon.transfer(recipient, 10, {from: normal});

    (await compliantCoupon.balanceOf(normal)).should.be.bignumber.equal('90');
    (await compliantCoupon.balanceOf(recipient)).should.be.bignumber.equal('10');
  });


  step("should block transfer above a defined limit for normal investors", async function () {
    await compliantCoupon.transfer(recipient, 11, {from: normal}).shouldBeReverted();

    (await compliantCoupon.balanceOf(normal)).should.be.bignumber.equal('90');
    (await compliantCoupon.balanceOf(recipient)).should.be.bignumber.equal('10');
  });


  step("should define policy for accredited investors", async function () {
    policyAccredited = await TransferPolicy.new();
    limitCheckerHigh = await SingleLimitTransferChecker.new(100);
    await policyAccredited.addChecker(limitCheckerHigh.address, {from:operator});

    await policySelector.setPolicyForStatus('ACCREDITED', policyAccredited.address);
    (await policySelector.getPolicyForStatus('ACCREDITED')).should.be.equal(policyAccredited.address);
  });


  step("should setup accredited investor", async function () {
    //Set status
    await policySelector.setStatusForAccount(accredited, 'ACCREDITED');

    (await policySelector.getStatusOfAddress(accredited)).should.be.equal('ACCREDITED');

    //Mint tokens
    await compliantCoupon.mint(accredited, 1000);

    (await compliantCoupon.balanceOf(accredited)).should.be.bignumber.equal('1000');
    (await compliantCoupon.balanceOf(recipient)).should.be.bignumber.equal('10');
  });


  step("should allow transfers withing limit for accredited investors", async function () {
    await compliantCoupon.transfer(recipient, 100, {from: accredited});

    (await compliantCoupon.balanceOf(accredited)).should.be.bignumber.equal('900');
    (await compliantCoupon.balanceOf(recipient)).should.be.bignumber.equal('110');
  });


  step("should block transfer above a defined limit for accredited investors", async function () {
    await compliantCoupon.transfer(recipient, 101, {from: accredited}).shouldBeReverted();

    (await compliantCoupon.balanceOf(accredited)).should.be.bignumber.equal('900');
    (await compliantCoupon.balanceOf(recipient)).should.be.bignumber.equal('110');
  });


  step("should allow higher transfers after promoting a user to an accredited status", async function () {
    await policySelector.setStatusForAccount(normal, 'ACCREDITED');

    await compliantCoupon.transfer(recipient, 11, {from: normal});

    (await compliantCoupon.balanceOf(normal)).should.be.bignumber.equal('79');
    (await compliantCoupon.balanceOf(recipient)).should.be.bignumber.equal('121');
  });

});
