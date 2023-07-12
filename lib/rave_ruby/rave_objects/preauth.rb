require_relative "base/preauth_base.rb"
require 'json'

class Preauth < PreauthBase

    # method to initiate preauth transaction
    def initiate_charge(data)

        base_url = rave_object.base_url
        secret_key = rave_object.secret_key.dup
        encryption_key = rave_object.encryption_key
        public_key = rave_object.public_key

        required_parameters = ["country", "amount", "currency", "email"]
        check_passed_parameters(required_parameters, data)


        # only update the payload with the transaction reference if it isn't already added to the payload
        if !data.key?("txRef")
            data.merge!({"txRef" => Util.transaction_reference_generator})
        end

        data.merge!({"PBFPubKey" => public_key, "charge_type" => "preauth"})

        # only update the payload with the transaction reference if it isn't already added to the payload
        if data.key?("token")
            data.merge!({"SECKEY" => secret_key})
            payload = data.to_json
            response = post_request("#{base_url}#{BASE_ENDPOINTS::PREAUTH_CHARGE_ENDPOINT}", payload)
            return handle_charge_response(response)
        else
            encrypt_data = Util.encrypt(encryption_key, data)

            payload = {
                "PBFPubKey" => public_key,
                "client" => encrypt_data,
                "alg" => "3DES-24"
            }

            payload = payload.to_json

            response = post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}", payload)
puts response
            return handle_charge_response(response)
        end
    end

    # method to capture transaction
    def capture(flwRef, amount=nil)
        base_url = rave_object.base_url

        payload = {
            "flwRef" => flwRef,
            "SECKEY" => rave_object.secret_key.dup,
            "amount" => amount
        }

        payload = payload.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::CAPTURE_ENDPOINT}", payload)
        return handle_capture_response(response)
    end

    # method to refund a transaction
    def refund(flwRef)
        base_url = rave_object.base_url

        payload = {
            "ref" => flwRef,
            "action" => "refund",
            "SECKEY" => rave_object.secret_key.dup,
        }

        payload = payload.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::REFUND_VOID_ENDPOINT}", payload)
        return handle_refund_void_response(response)
    end

     # method to void a transaction
     def void(flwRef)
        base_url = rave_object.base_url

        payload = {
            "ref" => flwRef,
            "action" => "void",
            "SECKEY" => rave_object.secret_key.dup,
        }

        payload = payload.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::REFUND_VOID_ENDPOINT}", payload)
        return handle_refund_void_response(response)
    end

    # method to verify preauth transaction
    def verify_preauth(txRef)
        base_url = rave_object.base_url

        payload = {
            "txref" => txRef,
            "SECKEY" => rave_object.secret_key.dup,
        }

        payload = payload.to_json

        response = post_request("#{base_url}#{BASE_ENDPOINTS::VERIFY_ENDPOINT}", payload)
        return handle_verify_response(response)
    end

end
