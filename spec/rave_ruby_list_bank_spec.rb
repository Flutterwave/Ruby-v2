require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/list_banks"

test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

RSpec.describe ListBanks do

  rave = RaveRuby.new(test_public_key, test_secret_key,test_encryption_key, false)

  context "when the list bank endpoint is called" do

    it "should return a valid list banks object" do
      list_banks =  ListBanks.new(rave)
      expect(list_banks.nil?).to eq(false)
    end

    it "should return error equals false if banks successfully fetched" do
      list_banks =  ListBanks.new(rave)
      list_bank_response = list_banks.fetch_banks
      expect(list_bank_response["error"]).to eq(false)
    end
  end
end
