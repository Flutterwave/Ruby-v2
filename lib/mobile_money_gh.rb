require_relative 'rave_ruby'


# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-****************************-X", "FLWSECK-****************************-X", true)


# This is used to perform GHS charge

payload = {
    "currency" => "GHS",
    "payment_type" => "mobilemoneygh",
    "country" => "GH",
    "amount" => "50",
    "email" => "ifunanyaikemma@gmail.com",
    "phonenumber" => "054709929220",
    "network" => "MTN",
    "firstname" => "Ifunanya",
    "lastname" => "Ikemma",
    "IP" => "355426087298442",
    "txRef" => "MC-test-gh",
    "orderRef" => "MC_test.1_gh",
    "is_mobile_money_gh" => 1,
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
    "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
  }

# To initiate mpesa transaction
charge_gh = MobileMoney.new(rave)

response = charge_gh.initiate_charge(payload)

print response

# To verify the mpesa transaction
response = charge_gh.verify_charge(response["txRef"])

print response

