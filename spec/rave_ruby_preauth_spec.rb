require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/preauth"


test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

payload = {
    "cardno" => "4187427415564246",
  "cvv" => "828",
  "expirymonth" => "09",
  "expiryyear" => "32",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "100",
  "email" => "ifunanyaikemma@gmail.com",
  "phonenumber" => "08134836828",
  "firstname" => "Ifunanya",
  "lastname" => "Ikemma",
  "IP" => "355426087298442",
  "txRef" => "MC-" + Date.today.to_s,
    "meta" => [{
        "metaname" => "flightID",
        "metavalue" => "123949494DC"
    }],
    "redirect_url" => "https=>//rave-webhook.herokuapp.com/receivepayment",
    "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

RSpec.describe Preauth do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  preauth =  Preauth.new(rave)

  context "when a merchant tries to charge customer with a tokenized card" do
    it "should return a valid preauth object" do
        expect(preauth.nil?).to eq(false)
    end

#     it 'should return chargeResponseCode 00 after successfully capturing the charge' do
#         preauth_initiate_response = preauth.initiate_charge(payload)
#         preauth_capture_response = preauth.capture(preauth_initiate_response["flwRef"], "10")
#         expect(preauth_capture_response["chargeResponseCode"]).to eq("00")
#     end

#     it 'should return error equals false if preauth transaction is successfully refunded' do
#         preauth_initiate_response = preauth.initiate_charge(payload)
#         preauth_capture_response = preauth.capture(preauth_initiate_response["flwRef"], "10")
#         preauth_refund_response = preauth.refund(preauth_capture_response["flwRef"])
#         expect(preauth_refund_response["error"]).to eq(false)
#     end

#     it 'should return error equals false if preauth is successfully void' do
#         preauth_initiate_response = preauth.initiate_charge(payload)
#         preauth_capture_response = preauth.capture(preauth_initiate_response["flwRef"], "10")
#         preauth_void_response = preauth.void(preauth_capture_response["flwRef"])
#         expect(preauth_void_response["error"]).to eq(false)
#     end

#     it 'should return charge code equals 00 if preauth successfully verified' do
#         preauth_initiate_response = preauth.initiate_charge(payload)
#         preauth_capture_response = preauth.capture(preauth_initiate_response["flwRef"], "10")
#         preauth_verify_response = preauth.verify_preauth(preauth_capture_response["txRef"])
#         expect(preauth_verify_response["data"]["chargecode"]).to eq("00")
#     end

  end

end
