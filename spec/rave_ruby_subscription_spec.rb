require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/subscription"


test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

payload = {
    "amount" => 500,
    "name" => "Ifunanya Ikemma",
    "interval" => "5",
    "duration" => 2
}

RSpec.describe Subscription do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  subscription = Subscription.new(rave)

  context "when a merchant tries to list subscriptions" do
    it "should return a valid subscription object" do
        expect(subscription.nil?).to eq(false)
    end

    it 'should check if all subscription list is successfully fetched' do
        list_subscription_response = subscription.list_all_subscription()
      expect(list_subscription_response["error"]).to eq(false)
    end

    it 'should check if a subscription is successfully fetched by transaction id' do
        fetch_subscription_response = subscription.fetch_subscription(4951)
      expect(fetch_subscription_response["error"]).to eq(false)
    end

  end

end
