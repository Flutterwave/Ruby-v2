require_relative "base/charge_base.rb"
require 'json'

class Card < ChargeBase

    # method to initiate card charge
    def initiate_charge(data)
        base_url = rave_object.base_url
        public_key = rave_object.public_key
        encryption_key = rave_object.encryption_key

        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("txRef")
            data.merge!({"txRef" => Util.transaction_reference_generator})
        end

        data.merge!({"PBFPubKey" => public_key})

        required_parameters = ["PBFPubKey", "cardno", "cvv", "expirymonth", "expiryyear", "amount", "txRef", "email"]
        check_passed_parameters(required_parameters, data)

        encrypt_data = Util.encrypt(encryption_key, data)

        payload = {
            "PBFPubKey" => public_key,
            "client" => encrypt_data,
            "alg" => "3DES-24"
        }

        payload = payload.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}", payload)

        return handle_charge_response(response)
    end

    # method to initiate card charge
    def tokenized_charge(data)
        base_url = rave_object.base_url
        encryption_key = rave_object.encryption_key
        public_key = rave_object.public_key

        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("txRef")
            data.merge!({"txRef" => Util.transaction_reference_generator})
        end

        data.merge!({"SECKEY" => rave_object.secret_key.dup})

        required_parameters = ["SECKEY", "amount", "currency", "country", "token", "txRef", "email"]
        check_passed_parameters(required_parameters, data)

        payload = data.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::TOKENISED_CHARGE_ENDPOINT}", payload)

        return handle_charge_response(response)
    end

    def validate_charge(flwRef, otp)
        base_url = rave_object.base_url
        public_key = rave_object.public_key


        payload = {
            "PBFPubKey" => public_key,
            "transactionreference" => flwRef,
            "transaction_reference" => flwRef,
            "otp" => otp,
        }

        payload = payload.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::CARD_VALIDATE_ENDPOINT}", payload)
        return handle_validate_response(response)
    end

    def verify_charge(txref)
        base_url = rave_object.base_url

        payload = {
            "txref" => txref,
            "SECKEY" => rave_object.secret_key.dup,
        }

        payload = payload.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::VERIFY_ENDPOINT}", payload)
        return handle_verify_response(response)
    end
end
