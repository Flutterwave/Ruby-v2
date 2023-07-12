require_relative "base/mpesa_base.rb"
require 'json'

class Mpesa < MpesaBase

    # method to initiate mpesa transaction
    def initiate_charge(data)

        base_url = rave_object.base_url
        encryption_key = rave_object.encryption_key
        public_key = rave_object.public_key


        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("txRef")
            data.merge!({"txRef" => Util.transaction_reference_generator})
        end

        # only update the payload with the order reference if it isn't already added to the payload
        if !data.key?("orderRef")
            data.merge!({"orderRef" => Util.transaction_reference_generator})
        end

        data.merge!({"PBFPubKey" => public_key, "payment_type" => "mpesa", "country" => "KE", "is_mpesa" => "1", "is_mpesa_lipa" => true, "currency" => "KES"})

        required_parameters = ["amount", "email", "phonenumber"]
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

    # method to verify mpesa transaction
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
