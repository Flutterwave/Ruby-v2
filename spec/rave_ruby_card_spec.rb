require 'spec_helper'
require "rave_ruby/rave_objects/card"


# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X"
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"
# test_encryption_key = "FLW-XXXXXXXXXXXXXXXXXX-X"

payload = {
  "cardno" => "5438898014560229",
  "cvv" => "890",
  "expirymonth" => "09",
  "expiryyear" => "19",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "user@gmail.com",
  "phonenumber" => "0902620185",
  "firstname" => "temi",
  "lastname" => "desola",
  "IP" => "355426087298442",
  "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
  "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

incomplete_card_payload = {
  # "cardno" => "5438898014560229",
  "cvv" => "890",
  "expirymonth" => "09",
  "expiryyear" => "19",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "user@gmail.com",
  "phonenumber" => "0902620185",
  "firstname" => "temi",
  "lastname" => "desola",
  "IP" => "355426087298442",
  "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
  "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

token_payload = {
    "currency" => "NGN",
    "country" => "NG",
    "amount" => "10",
    "token" => "flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k",
    "email" => "user@gmail.com",
    "phonenumber" => "0902620185",
    "firstname" => "temi",
    "lastname" => "desola",
    "IP" => "355426087298442",
    "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
}

incomplete_token_payload = {
    "currency" => "NGN",
    "country" => "NG",
    "amount" => "10",
    "email" => "user@gmail.com",
    "phonenumber" => "0902620185",
    "firstname" => "temi",
    "lastname" => "desola",
    "IP" => "355426087298442",
    "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
}

pin_payload = {
  "cardno" => "5438898014560229",
  "cvv" => "890",
  "expirymonth" => "09",
  "expiryyear" => "19",
  "currency" => "NGN",
  "country" => "NG",
  "amount" => "10",
  "email" => "user@gmail.com",
  "phonenumber" => "0902620185",
  "suggested_auth" => "PIN",
  "pin" => "3310",
  "firstname" => "temi",
  "lastname" => "desola",
  "IP" => "355426087298442",
  "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
  "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

avs_payload = {
  "cardno" => "4556052704172643",
  "cvv" => "828",
  "expirymonth" => "09",
  "expiryyear" => "19",
  "currency" => "USD",
  "country" => "NG",
  "amount" => "10",
  "email" => "user@gmail.com",
  "phonenumber" => "0902620185",
  "firstname" => "temi",
  "lastname" => "desola",
  "IP" => "355426087298442",
  "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
  "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
  "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c",
  "billingzip"=> "07205",
  "billingcity"=> "Hillside",
  "billingaddress"=> "470 Mundet PI",
  "billingstate"=> "NJ",
  "billingcountry"=> "US"
}

RSpec.describe Card do

  rave = RaveRuby.new(test_public_key, test_secret_key)
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

    it 'should check if authentication is required after charging a card' do
      first_payload_response = charge_card.initiate_charge(payload)
      expect(first_payload_response["suggested_auth"].nil?).to eq(false)
    end

    it 'should successfully charge card with suggested auth PIN' do
      second_payload_response = charge_card.initiate_charge(pin_payload)
      expect(second_payload_response["validation_required"]).to eq(true)
    end

    it 'should successfully charge card with suggested auth AVS' do
      avs_payload_response = charge_card.initiate_charge(avs_payload)
      expect(avs_payload_response["authurl"].nil?).to eq(false)
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

    it 'should return chargecode 00 after successfully charging and verifying a tokenized card transaction with txRef' do
      token_initiate_response = charge_card.tokenized_charge(token_payload)
      token_verify_response = charge_card.verify_charge(token_initiate_response["txRef"])
      expect(token_verify_response["data"]["chargecode"]).to eq("00")
    end

  end

end
