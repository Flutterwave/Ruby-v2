require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/card"

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
  "amount" => "10",
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


incomplete_card_payload = {
  # "cardno" => "4187427415564246",
  "cvv" => "828",
  "expirymonth" => "09",
  "expiryyear" => "32",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
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

token_payload = {
    "currency" => "NGN",
    "country" => "NG",
    "amount" => "10",
    "token" => "flw-t1nf-75fee8c30ae88f03a5640f36fe7b7893-m03k",
    "email" => "applicant@eum.com",
    "phonenumber" => "0902620185",
    "firstname" => "Ifunanya",
    "lastname" => "Ikemma",
    "IP" => "355426087298442",
    "meta" => [{"metaname"=> "flightID", "metavalue"=> "123949494DC"}],
    "redirect_url" => "https=>//rave-webhook.herokuapp.com/receivepayment",
}

incomplete_token_payload = {
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "applicant@eum.com",
  "phonenumber" => "0902620185",
  "firstname" => "Ifunanya",
  "lastname" => "Ikemma",
  "IP" => "355426087298442",
  "meta" => [{"metaname"=> "flightID", "metavalue"=> "123949494DC"}],
  "redirect_url" => "https=>//rave-webhook.herokuapp.com/receivepayment",
}

pin_payload = {
  "cardno"=> "4187427415564246",
  "cvv"=> "828",
  "expirymonth"=> "09",
  "expiryyear"=> "32",
  "currency"=> "NGN",
  "pin"=> "3310",
  "country"=> "NG",
  "amount"=> "10",
  "email"=> "ifunanyaikemma@gmail.com",
  "phonenumber"=> "08134836828",
  "suggested_auth"=> "PIN",
  "firstname"=> "Ifunanya",
  "lastname"=> "Ikemma",
  "IP"=> "355426087298442",
  "txRef"=> "MC-" + Date.today.to_s,
  "meta"=> [{
      "metaname" => "flightID",
      "metavalue" => "123949494DC"
  }],
  "redirect_url"=> "https=>//rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint"=> "69e6b7f0b72037aa8428b70fbe03986c"
}

RSpec.describe Card do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  charge_card =  Card.new(rave)

  context "when a merchant tries to charge a customers card" do
    it "should return a card object" do
      expect(charge_card.nil?).to eq(false)
    end

    it 'should raise Error if card payload is incomplete' do
      begin
        incomplete_card_payload_response = charge_card.initiate_charge(incomplete_card_payload)
      rescue  => e
        expect(e.instance_of? IncompleteParameterError).to eq true
      end
    end

    it 'should raise Error if card token payload is incomplete' do
      begin
        incomplete_payload_response = charge_card.tokenized_charge(incomplete_token_payload)
      rescue  => e
        expect(e.instance_of? IncompleteParameterError).to eq true
      end
    end

    it 'should confirm that authentication is required before charging a card' do
      first_payload_response = charge_card.initiate_charge(payload)
      expect(first_payload_response["suggested_auth"].nil?).to eq(true)
    end

    it 'should successfully charge card with suggested auth PIN' do
      second_payload_response = charge_card.initiate_charge(pin_payload)
      expect(second_payload_response["validation_required"]).to eq(true)
    end

    it 'should return chargeResponseCode 00 after successfully validating with flwRef and OTP' do
      card_initiate_response = charge_card.initiate_charge(pin_payload)
      card_validate_response = charge_card.validate_charge(card_initiate_response["flwRef"], "12345")
      expect(card_validate_response["chargeResponseCode"]).to eq("00")
    end

    it 'should return chargecode 00 after successfully verifying a card transaction with txRef' do
      card_initiate_response = charge_card.initiate_charge(pin_payload)
      card_validate_response = charge_card.validate_charge(card_initiate_response["flwRef"], "12345")
      card_verify_response = charge_card.verify_charge(card_validate_response["txRef"])
      expect(card_verify_response["data"]["chargecode"]).to eq("00")
    end

    # it 'should return chargecode 00 after successfully charging and verifying a tokenized card transaction with txRef' do
    #   token_initiate_response = charge_card.tokenized_charge(token_payload)
    #   token_verify_response = charge_card.verify_charge(token_initiate_response["txRef"])
    #   expect(token_verify_response["data"]["chargecode"]).to eq("00")
    # end

  end

end
