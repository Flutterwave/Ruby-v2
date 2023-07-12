require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/ussd"


test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

payload = {
  "accountbank" => "057",
  "accountnumber" => "0691008392",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "desola.ade1@gmail.com",
  "phonenumber" => "0902620185",
  "IP" => "355426087298442",
}

incomplete_payload = {
  "accountnumber" => "0691008392",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "desola.ade1@gmail.com",
  "phonenumber" => "0902620185",
  "IP" => "355426087298442",
}

RSpec.describe Ussd do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  charge_ussd =  Ussd.new(rave)

  context "when a merchant tries to charge customer with ussd" do
    it "should return a ussd object" do
      expect(charge_ussd.nil?).to eq(false)
    end

    it 'should raise Error if ussd payload is incomplete' do
      begin
        incomplete_payload_response = charge_ussd.initiate_charge(incomplete_payload)
      rescue  => e
        expect(e.instance_of? IncompleteParameterError).to eq true
      end
  end

  end

end
