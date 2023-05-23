require 'spec_helper'

# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X" 
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

invalid_test_public_key = "xxxxxxxxxxxxxxxxxxxxx-X" 
invalid_test_secret_key = "xxxxxxxxxxxxxxxxxxxxx-X"

test_mode_public_key = "FLWPUBK_TEST-xxxxxxxxxxxxxxxxxxxxx-X"
test_mode_secret_key = "FLWSECK_TEST-xxxxxxxxxxxxxxxxxxxxx-X"

RSpec.describe RaveRuby do

  rave = RaveRuby.new(test_public_key, test_secret_key)

  test_mode_rave = RaveRuby.new(test_mode_public_key, test_mode_secret_key)

  # it "has a version number" do
  #   expect(RaveRuby::VERSION).not_to be nil
  # end

  # it "does something useful" do
  #   expect(false).to eq(true)
  # end

  it "should return the valid rave object" do
		expect(rave.nil?).to eq(false)
  end

  it "should return valid public key" do
    expect(rave.public_key[0..7]).to eq("FLWPUBK-")
  end

  it "should return valid private key" do
    expect(rave.secret_key[0..7]).to eq("FLWSECK-")
  end

  it "should return valid test mode public key" do
    expect(test_mode_rave.public_key[0..12]).to eq("FLWPUBK_TEST-")
  end

  it "should return valid test mode private key" do
    expect(test_mode_rave.secret_key[0..12]).to eq("FLWSECK_TEST-")
  end

  it 'should raise Error if invalid public key set' do
    begin
      rave_pub_key_error = RaveRuby.new(invalid_test_public_key, test_secret_key)
    rescue  => e
      expect(e.instance_of? RaveBadKeyError).to eq true
    end
  end

  it 'should raise Error if invalid secret key set' do
    begin
      rave_sec_key_error = RaveRuby.new(test_public_key, invalid_test_secret_key)
    rescue  => e
      expect(e.instance_of? RaveBadKeyError).to eq true
    end
  end
  
end
