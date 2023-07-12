require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/mpesa"


test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

payload = {
  "amount" => "100",
  "phonenumber" => "0926420185",
  "email" => "user@exampe.com",
  "IP" => "40.14.290",
  "narration" => "funds payment",
}

RSpec.describe Mpesa do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  charge_mpesa =  Mpesa.new(rave)

  context "when a merchant tries to charge customer with mpesa" do
    it "should return a mpesa object" do
      expect(charge_mpesa.nil?).to eq(false)
    end

    it 'should check if mpesa transaction is successful initiated and validation is required' do
      initiate_mpesa_response = charge_mpesa.initiate_charge(payload)
      expect(initiate_mpesa_response["error"]).to eq(false)
      expect(initiate_mpesa_response["validation_required"]).to eq(false)
      expect(initiate_mpesa_response["status"]).to eq("success-pending-validation")
    end

  end

end
