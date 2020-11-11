require_relative "base.rb"

class MobileMoneyBase < Base

    # method to handle mobile money charge response
    def handle_charge_response(response)
        charge_response = response
        message = charge_response["message"]
        charge_response_code = charge_response["data"]["code"]
        status = charge_response["data"]["status"]
        ts = charge_response["data"]["ts"]
        link = charge_response["data"]["link"]

        if charge_response_code == "00"
            res = {"error": false, "status": status, "validation_required": false, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "validateInstruction": validate_instruction, "authModelUsed": auth_model_used, "paymentType": payment_type}
            return JSON.parse(res.to_json)
        else
            res = {"error": false, "status": status, "message": message, "ts": ts, "link": link}
            return JSON.parse(res.to_json)
        end
    end


    # method to handle mobile money verify response
    def handle_verify_response(response)
        verify_response = response
        status = verify_response["data"]["status"]
        charge_code = verify_response["data"]["chargecode"]

        if charge_code == "00" && status == "successful"
            res = {"error": false, "transaction_complete": true, "data": verify_response["data"]}
            return JSON.parse(res.to_json)
        else
            res = {"error": false, "transaction_complete": false, "data": verify_response["data"]}
            return JSON.parse(res.to_json)
        end
    end
end