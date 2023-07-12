require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/zambia_mobile_money"

test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

payload = {
  "amount" => "30",
  "phonenumber" => "054709929300",
  "firstname" => "John",
  "lastname" => "Doe",
  "network" => "MTN",
  "email" => "user@example.com",
  "IP" => '355426087298442',
  "redirect_url" => "https://webhook.site/6eb017d1-c605-4faa-b543-949712931895",
}

RSpec.describe ZambiaMobileMoney do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  charge_zambia_mobile_money =  ZambiaMobileMoney.new(rave)

  context "when a merchant tries to charge customer with zambia mobile money" do
    it "should return a zambia mobile money object" do
      expect(charge_zambia_mobile_money.nil?).to eq(false)
    end

    it 'should check if zambia mobile money transaction is successful initiated and validation is required' do
      initiate_zambia_mobile_money_response = charge_zambia_mobile_money.initiate_charge(payload)
      expect(initiate_zambia_mobile_money_response["error"]).to eq(false)
      expect(initiate_zambia_mobile_money_response["status"]).to eq("pending")
      expect(initiate_zambia_mobile_money_response["message"]).to eq("Momo initiated")
    end

  end

end
