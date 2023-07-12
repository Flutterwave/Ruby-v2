require_relative "base.rb"

class UssdBase < Base

    # method to handle ussd charge response
    def handle_charge_response(response, request)
        charge_response = response
        flwRef = charge_response["data"]["flwRef"]
        txRef = charge_response["data"]["txRef"]
        status = charge_response["data"]["status"]
        amount = charge_response["data"]["amount"]
        charged_amount = charge_response["data"]["charged_amount"]
        currency = charge_response["data"]["currency"]
        payment_type = charge_response["data"]["paymentType"]
        charge_response_code = charge_response["data"]["chargeResponseCode"]
        charge_response_message = charge_response["data"]["chargeResponseMessage"]
        validation_instruction = charge_response["data"]["validateInstructions"]

        # new response structure
        provider = charge_response["data"]["data"]["provider"]
        provider_status = charge_response["data"]["data"]["status"]
        provider_amount = charge_response["data"]["data"]["amount"]
        provider_payment_code = charge_response["data"]["data"]["payment_code"]
        provider_note = charge_response["data"]["data"]["note"]
        provider_transaction_date = charge_response["data"]["data"]["transaction_date"]
        provider_transaction_reference = charge_response["data"]["data"]["transactionreference"]
        meta_data = charge_response["data"]["data"]["meta_data"]
        flw_reference = charge_response["data"]["data"]["flw_reference"]
        provider_response = charge_response["data"]["response_message"]
        provider_response_code = charge_response["data"]["response_code"]

        bank_list = {"gtb" => "058", "zenith" => "057"}
        gtb_response_text = "To complete this transaction, please dial *737*50*#{charged_amount}*159#"


        if charge_response_code == "02"
            if request["accountbank"] == bank_list["gtb"]
                res = {"error": false, "status": status, "validation_required": true, "txRef": txRef, "flwRef": flwRef, "validateInstruction": gtb_response_text, "amount": amount, "currency": currency, "paymentType": payment_type}
                return JSON.parse(res.to_json)
            else
                res = {"error": false, "status": status, "validation_required": true, "txRef": txRef, "flwRef": flwRef, "validateInstruction": validation_instruction, "amount": amount, "currency": currency, "paymentType": payment_type}
                return JSON.parse(res.to_json)
            end

        elsif provider_response_code == "02"
            res = {"error": false, "status": provider_status, "validation_required": true, "txRef": provider_transaction_reference, "flwRef": flw_reference, "note": provider_note, "amount": provider_amount, "provider": provider, "paymentCode": provider_payment_code, "meta": meta_data, "provider_response": provider_response}
            return JSON.parse(res.to_json)

        else
            res = {"error": false, "status": status, "validation_required": false, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "paymentType": payment_type}
            return JSON.parse(res.to_json)
        end
    end


    # method to handle ussd verify response
    def handle_verify_response(response)
        verify_response = response
        flwref = verify_response["data"]["flwref"]
        txref = verify_response["data"]["txref"]
        status = verify_response["data"]["status"]
        charged_amount = verify_response["data"]["chargedamount"]
        amount = verify_response["data"]["amount"]
        vbvmessage = verify_response["data"]["vbvmessage"]
        vbvcode = verify_response["data"]["vbvcode"]
        currency = verify_response["data"]["currency"]
        charge_code = verify_response["data"]["chargecode"]
        charge_message = verify_response["data"]["chargemessage"]

        if charge_code == "00" && status == "successful"
            res = {"error": false, "status": status, "transaction_complete": true, "txref": txref, "flwref": flwref, "amount": amount, "chargedamount": charged_amount, "vbvmessage": vbvmessage, "vbvcode": vbvcode, "currency": currency, "chargecode": charge_code, "chargemessage": charge_message}
            return JSON.parse(res.to_json)
        else
            res = {"error": false, "status": status, "transaction_complete": false, "txref": txref, "flwef": flwref, "amount": amount, "chargedamount": charged_amount, "vbvmessage": vbvmessage, "vbvcode": vbvcode, "currency": currency, "charge_code": charge_code, "chargemessage": charge_message}
            return JSON.parse(res.to_json)
        end
    end
end
