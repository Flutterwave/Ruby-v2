require 'spec_helper'
require 'dotenv/load'
require 'rave_ruby/rave_objects/account'

test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

payload = {
  "accountbank" => "044",
  "accountnumber" => "0690000031",
  "currency" => "NGN",
  "payment_type" =>  "account",
  "country" => "NG",
  "amount" => "100",
  "email" => "mijux@xcodes.net",
  "phonenumber" => "08134836828",
  "firstname" => "ifunanya",
  "lastname" => "Ikemma",
  "IP" => "355426087298442",
  "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

RSpec.describe Account do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  charge_account =  Account.new(rave)

  context "when a merchant tries to charge a customers account" do

    it "should return account object" do
      expect(charge_account.nil?).to eq(false)
    end

  end

end
