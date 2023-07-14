require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/uganda_mobile_money"

test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

payload = {
  "amount" => "30",
  "phonenumber" => "054709929300",
  "firstname" => "Edward",
  "lastname" => "Kisane",
  "network" => "UGX",
  "email" => "tester@flutter.co",
  "IP" => '103.238.105.185',
  "redirect_url" => "https://webhook.site/6eb017d1-c605-4faa-b543-949712931895",
}

RSpec.describe UgandaMobileMoney do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  charge_uganda_mobile_money =  UgandaMobileMoney.new(rave)

  context "when a merchant tries to charge customer with uganda mobile money" do
    it "should return a uganda mobile money object" do
      expect(charge_uganda_mobile_money.nil?).to eq(false)
    end

    it 'should check if uganda mobile money transaction is successful initiated and validation is required' do
      initiate_uganda_mobile_money_response = charge_uganda_mobile_money.initiate_charge(payload)
      expect(initiate_uganda_mobile_money_response["error"]).to eq(false)
    end

  end

end
