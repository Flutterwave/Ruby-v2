require 'spec_helper'
require 'dotenv/load'
require "rave_ruby/rave_objects/payment_plan"

test_public_key = ENV['TEST_PUBLIC_KEY'];
test_secret_key = ENV['TEST_SECRET_KEY'];
test_encryption_key = ENV['TEST_ENCRYPTION_KEY'];

payload = {
    "amount" => 100,
    "name" => "Test Plan",
    "interval" => "daily",
    "duration" => 5
}

incomplete_payload = {
    "name" => "Test Plan",
    "interval" => "daily",
    "duration" => 5
}

RSpec.describe PaymentPlan do

  rave = RaveRuby.new(test_public_key, test_secret_key, test_encryption_key, false)
  payment_plan =  PaymentPlan.new(rave)

  context "when a merchant tries to enroll customer with payment plan" do
    it "should return a valid payment plan object" do
      expect(payment_plan.nil?).to eq(false)
    end

    it 'should raise Error if payment plan payload is incomplete' do
        begin
          incomplete_payload_response = payment_plan.create_payment_plan(incomplete_payload)
        rescue  => e
          expect(e.instance_of? IncompleteParameterError).to eq true
        end
    end

    it 'should check if payment plan is successfully created' do
        create_payment_plan_response = payment_plan.create_payment_plan(payload)
      expect(create_payment_plan_response["error"]).to eq(false)
    end

    it 'should check if payment plan list is successfully returned' do
        list_payment_plan_response = payment_plan.list_payment_plans
      expect(list_payment_plan_response["error"]).to eq(false)
    end

    it 'should check if a single payment plan is successfully returned' do
        fetch_payment_plan_response = payment_plan.fetch_payment_plan("1125", "Test Plan")
      expect(fetch_payment_plan_response["error"]).to eq(false)
    end

    it 'should check if a payment plan is successfully edited' do
        edit_payment_plan_response = payment_plan.edit_payment_plan("52374", {"name" => "Jack's Plan", "status" => "active"})
      expect(edit_payment_plan_response["error"]).to eq(false)
    end

    it 'should check if a payment plan is successfully cancelled' do
        cancel_payment_plan_response = payment_plan.cancel_payment_plan("52374")
      expect(cancel_payment_plan_response["error"]).to eq(false)
    end

  end

end
