require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/mobile_money"

test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

payload = {
  "currency" => "GHS",
  "payment_type" => "mobilemoneygh",
  "country" => "GH",
  "amount" => "50",
  "email" => "ifunanyaikemma@gmail.com",
  "phonenumber" => "054709929220",
  "network" => "MTN",
  "firstname" => "Ifunanya",
  "lastname" => "Ikemma",
  "IP" => "355426087298442",
  "txRef" => "MC-test-gh",
  "orderRef" => "MC_test.1_gh",
  "is_mobile_money_gh" => 1,
  "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

RSpec.describe MobileMoney do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  charge_mobile_money =  MobileMoney.new(rave)

  context "when a merchant tries to charge customer with mobile money" do
    it "should return a mobile money object" do
      expect(charge_mobile_money.nil?).to eq(false)
    end

    it 'should check if mobile money transaction is successful initiated and validation is required' do
      initiate_mobile_money_response = charge_mobile_money.initiate_charge(payload)
      expect(initiate_mobile_money_response["error"]).to eq(false)
      expect(initiate_mobile_money_response["link"].nil?).to eq(false)
      expect(initiate_mobile_money_response["status"]).to eq("pending")
      expect(initiate_mobile_money_response["message"]).to eq("Momo initiated")
    end

  end

end
