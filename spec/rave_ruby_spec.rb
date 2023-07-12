require 'spec_helper'
require 'dotenv/load'

test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

RSpec.describe RaveRuby do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)

  it "has a version number" do
    expect(RaveRuby::VERSION).not_to be nil
  end

  # it "does something useful" do
  #   expect(false).to eq(true)
  # end

  it "should return the valid rave object" do
		expect(rave.nil?).to eq(false)
  end

  it "should return valid public key" do
    expect(rave.public_key[0..11]).to eq("FLWPUBK_TEST")
  end

  it "should return valid private key" do
     expect(rave.secret_key[0..11]).to eq("FLWSECK_TEST")
  end

  # it 'should raise Error if invalid public key set' do
  #   begin
  #     rave_pub_key_error = RaveRuby.new(invalid_test_public_key, test_secret_key, encryption_key)
  #   rescue  => e
  #     expect(e.instance_of? RaveBadKeyError).to eq true
  #   end
  # end

  # it 'should raise Error if invalid secret key set' do
  #   begin
  #     rave_sec_key_error = RaveRuby.new(test_public_key, invalid_test_secret_key, encryption_key)
  #   rescue  => e
  #     expect(e.instance_of? RaveBadKeyError).to eq true
  #   end
  # end

end
