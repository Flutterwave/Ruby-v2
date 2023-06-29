# RaveRuby

[![Build Status](https://travis-ci.org/MaestroJolly/rave-ruby.svg?branch=master)](https://travis-ci.org/MaestroJolly/rave-ruby) [![Gem Version](https://badge.fury.io/rb/rave_ruby.svg)](https://badge.fury.io/rb/rave_ruby)

This is a Ruby gem for easy integration of Rave API for various applications written in Ruby language from [Rave](https://rave.flutterwave.com) by [Flutterwave.](https://developer.flutterwave.com/reference)

## Documentation

See [Here](https://developer.flutterwave.com/reference) for Rave API Docs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rave_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rave_ruby

## Usage

### Initialization

#### Instantiate rave object in sandbox with environment variable:

To use [Rave](https://ravesandbox.flutterwave.com), you need to instantiate the `RaveRuby` class with your [API](https://ravesandbox.flutterwave.com/dashboard/settings/apis) keys which are your public and secret keys. We recommend that you store your API keys in your environment variable named `RAVE_PUBLIC_KEY` and `RAVE_SECRET_KEY`. Instantiating your rave object after adding your API keys in your environment is as illustrated below:

```ruby
rave = RaveRuby.new
```
This throws a `RaveBadKeyError` if no key is found in the environment variable or invalid public or secret key is found.

#### Instantiate rave object in sandbox without environment variable:

You can instantiate your rave object by setting your public and secret keys by passing them as an argument of the `RaveRuby` class just as displayed below: 

```ruby
rave = RaveRuby.new("YOUR_RAVE_SANDBOX_PUBLIC_KEY", "YOUR_RAVE_SANDBOX_SECRET_KEY")
```

#### NOTE: It is best practice to always set your API keys to your environment variable for security purpose. Please be warned not use this package without setting your API keys in your environment variables in production.

#### To instantiate rave object in production with environment variable:

Simply use it as displayed below:

```ruby
rave = RaveRuby.new("YOUR_RAVE_LIVE_PUBLIC_KEY", "YOUR_RAVE_LIVE_SECRET_KEY", true)
```

## Rave Objects

- [Account.new(rave)](#accountnewrave)
- [Card.new(rave)](#cardnewrave)
- [Preauth.new(rave)](#preauthnewrave)
- [MobileMoney.new(rave)](#mobilemoneynewrave)
- [Mpesa.new(rave)](#mpesanewrave)
- [SubAccount.new(rave)](#subaccountnewrave)
- [PaymentPlan.new(rave)](#paymentplannewrave)
- [Subscription.new(rave)](#subscriptionnewrave)
- [Transfer.new(rave)](#transfernewrave)
- [UgandaMobileMoney.new(rave)](#ugandamobilemoneynewrave)
- [ZambiaMobileMoney.new(rave)](#zambiamobilemoneynewrave)
- [Ussd.new(rave)](#ussdnewrave)
- [ListBanks.new(rave)](#listbanksnewrave)

## `Account.new(rave)`

To perform account transactions, instantiate the account object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.validate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate account transaction. The payload should be a Ruby hash with account details. Its parameters should include the following:

- `accountbank`,

- `accountnumber`,

- `amount`,

- `email`,

- `phonenumber`,

- `IP`

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample `account charge` call:

```ruby
response = charge_account.initiate_charge(payload)
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "validation_required"=>true, "message"=>"V-COMP", "suggested_auth"=>nil, "txRef"=>"MC-2232eed54ca72f8ae2125f49020fb592", "flwRef"=>"ACHG-1544908923260", "chargeResponseCode"=>"02", "chargeResponseMessage"=>"Pending OTP validation", "amount"=>100, "currency"=>"NGN", "validateInstruction"=>"Please dial *901*4*1# to get your OTP. Enter the OTP gotten in the field below", "paymentType"=>"account", "authModelUsed"=>"AUTH", "authurl"=>"NO-URL"
}
```

A `RaveServerError` is raised if there's an error with the charge.

#### Sample error response if an exception is raised:

```ruby
{
    "status":"error","message":"Sorry that account number is invalid. Please check and try again","data":{"code":"FLW_ERR","message":"Sorry that account number is invalid. Please check and try again","err_tx":{"id":360210,"flwRef":"ACHG-1544910130710","chargeResponseCode":"RR","chargeResponseMessage":"Sorry that account number is invalid. Please check and try again","status":"failed","merchantbearsfee":1,"appfee":"1.4","merchantfee":"0","charged_amount":"100.00"
}}}
```

### `.validate_charge(flwRef, "OTP")`

After a successful charge, most times you will be asked to verify with OTP. To check if this is required, check the validation_required key in the response of the charge call i.e `response["validation_required"]` is equal to `true`.

In the case that an `authUrl` is returned from your charge call, you may skip the validation step and simply pass your authurl to the end-user as displayed below:

```ruby
authurl = response['authurl']
```

If validation is required by OTP, you need to pass the `flwRef` from the response of the charge call as well as the OTP.

#### Sample `validate_charge` call:

```ruby
response = charge_account.validate_charge(response["flwRef"], "12345")
```

#### which returns:

It returns this response in Ruby hash with the `txRef` and `flwRef` amongst its successful response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-c0c707a798de82f34b937e6126844d6c", "flwRef"=>"ACHG-1544963949493", "amount"=>100, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Pending OTP validation"
}
```

If an error occurs during OTP validation, you will receive a response similar to this:

```ruby
{
    "error"=>true, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-4cd9b2e4a9a104f92273ce194993ab50", "flwRef"=>"ACHG-1544969082006", "amount"=>100, "currency"=>"NGN", "chargeResponseCode"=>"02", "chargeResponseMessage"=>"Pending OTP validation"
}
```

With `chargeResponseCode` still equals to `02` which means it didn't validate successfully and is till pending validation.

Otherwise if validation is successful using OTP, you will receive a response similar to this:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-c0c707a798de82f34b937e6126844d6c", "flwRef"=>"ACHG-1544963949493", "amount"=>100, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Pending OTP validation"
}
```

With `chargeResponseCode` equals to `00` which means it validated successfully.

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` or `validate_charge` call.

#### Sample `verify_charge` call:

```ruby
response = charge_account.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in Ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>360744, "txref"=>"MC-c0c707a798de82f34b937e6126844d6c", "flwref"=>"ACHG-1544963949493", "devicefingerprint"=>"69e6b7f0b72037aa8428b70fbe03986c", "cycle"=>"one-time", "amount"=>100, "currency"=>"NGN", "chargedamount"=>100, "appfee"=>1.4, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"00", "chargemessage"=>"Pending OTP validation", "authmodel"=>"AUTH", "ip"=>"::ffff:10.11.193.41", "narration"=>"Simply Recharge", "status"=>"successful",
    "vbvcode"=>"N/A", "vbvmessage"=>"N/A", "authurl"=>"NO-URL", "acctcode"=>"00", "acctmessage"=>"Approved Or Completed Successfully", "paymenttype"=>"account", "paymentid"=>"90", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>0, "createddayname"=>"SUNDAY", "createdweek"=>50, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>12, "createdminute"=>39, "createdpmam"=>"pm", "created"=>"2018-12-16T12:39:08.000Z", "customerid"=>64794, "custphone"=>"08134836828", "custnetworkprovider"=>"MTN", "custname"=>"ifunanya Ikemma", "custemail"=>"mijux@xcodes.net", "custemailprovider"=>"COMPANY EMAIL", "custcreated"=>"2018-11-26T11:35:24.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_1544963948269_113435", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>"RV31544963947776E1DB61E313", "amountsettledforthistransaction"=>98.6, "account"=>{"id"=>90, "account_number"=>"0690000033", "account_bank"=>"044", "first_name"=>"NO-NAME", "last_name"=>"NO-LNAME", "account_is_blacklisted"=>0, "createdAt"=>"2017-04-26T12:54:22.000Z", "updatedAt"=>"2018-12-16T12:39:23.000Z", "deletedAt"=>nil, "account_token"=>{"token"=>"flw-t03a483b4eecf61cda-k3n-mock"}}, "meta"=>[]}
}

```

If a transaction couldn't be verified successfully, `error` and `transaction_complete` would both come as `false`.

#### Full Account Transaction Flow:

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is used to perform card charge
payload = {
    "accountbank" => "044",
    "accountnumber" => "0690000033",
    "currency" => "NGN",
    "payment_type" =>  "account",
    "country" => "NG",
    "amount" => "100", 
    "email" => "mijux@xcodes.net",
    "phonenumber" => "08134836828",
    "firstname" => "Maestro",
    "lastname" => "Jolly",
    "IP" => "355426087298442",
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
    "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

charge_account = Account.new(rave)

response = charge_account.initiate_charge(payload)
print response

# Perform validation if it is required
if response["validation_required"]
    response = charge_account.validate_charge(response["flwRef"], "12345")
    print response
end

# Verify charge
response = charge_account.verify_charge(response["txRef"])
print response
```

## `Card.new(rave)`

To perform card transactions, instantiate the card object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.get_auth_type`
- `.update_payload`
- `.tokenized_charge`
- `.validate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate card transaction. The payload should be a Ruby hash with card details. Its parameters should include the following:

- `cardno`,

- `cvv`,

- `expirymonth`,

- `expiryyear`,

- `amount`,

- `email`,

- `phonenumber`,

- `firstname`,

- `lastname`,

- `IP`

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample `card charge` call:

```ruby
response = charge_card.initiate_charge(payload)
```

You need to make this initial charge call to get the suggested_auth for the transaction.

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "validation_required"=>true, "message"=>"AUTH_SUGGESTION", "suggested_auth"=>"PIN", "txRef"=>nil, "flwRef"=>nil, "chargeResponseCode"=>nil, "chargeResponseMessage"=>nil, "amount"=>nil, "currency"=>nil, "validateInstruction"=>nil, "paymentType"=>nil, "authModelUsed"=>nil, "authurl"=>nil
}
```

A `RaveServerError` is raised if there's an error with the card charge.

#### Sample error response if an exception is raised:

```ruby
{
    "status":"error","message":"Card number is invalid","data":{"code":"ERR","message":"Card number is invalid"
    }
}
```

### `.update_payload(suggested_auth, payload, pin or address)`

You need to update the payload with `pin` or `address` parameters depending on the `suggested_auth` returned from the initial charge call i.e `suggested_auth = response["suggested_auth"]` and passing it as a parameter of the `.get_auth_type(suggested_auth)` method.

If the `suggested_auth` returned is `pin`, update the payload with this method `charge_card.update_payload(suggested_auth, payload, pin: "CUSTOMER CARD PIN")`. 

If the `suggested_auth` returned is `address`, update the payload with this method `charge_card.update_payload(suggested_auth, payload, address:{"A Ruby hash OF CUSTOMER'S BILLING ADDRESS"})`. 

This is what the Ruby hash billing address consists:

- `billingzip`,

- `billingcity`,

- `billingaddress`,

- `billingstate`,

- `billingcountry`

After updating the payload, you will need to make the `.initiate_charge` call again with the updated payload, as displayed below:

```ruby
response = charge_card.initiate_charge(updated_payload)
```

This is a sample response returned after updating payload with suggested_auth `pin`:

```ruby
{
    "error"=>false, "status"=>"success", "validation_required"=>true, "message"=>"V-COMP", "suggested_auth"=>nil, "txRef"=>"MC-d8c02b9bdf21d02aa7ab276cda3177ae", "flwRef"=>"FLW-MOCK-68d8095eab1abdb69805be0a55d84630", "chargeResponseCode"=>"02", "chargeResponseMessage"=>"Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com", "amount"=>10, "currency"=>"NGN", "validateInstruction"=>nil, "paymentType"=>"card", "authModelUsed"=>"PIN", "authurl"=>"N/A"
}
```

### `.validate_charge(flwRef, "OTP")`

After a successful charge, most times you will be asked to verify with OTP. To check if this is required, check the validation_required key in the response of the charge call i.e `response["validation_required"]` is equal to `true`.

In the case that an `authUrl` is returned from your charge call, you may skip the validation step and simply pass your authurl to the end-user as displayed below:

```ruby
authurl = response['authurl']
```

If validation is required by OTP, you need to pass the `flwRef` from the response of the charge call as well as the OTP.

A sample `validate_charge` call:

```ruby
response = charge_card.validate_charge(response["flwRef"], "12345")
```

#### which returns:

It returns this response in Ruby hash with the `txRef` and `flwRef` amongst its successful response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-d8c02b9bdf21d02aa7ab276cda3177ae", "flwRef"=>"FLW-MOCK-68d8095eab1abdb69805be0a55d84630", "amount"=>10, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com"
}
```

If an error occurs during OTP validation, you will receive a response similiar to this:

```ruby
{
    "error"=>true, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-155418209b1cf2812da3ceb57e541ef0", "flwRef"=>"FLW-MOCK-35167122c73ccdd8ee796b71042af101", "amount"=>100, "currency"=>"NGN", "chargeResponseCode"=>"02", "chargeResponseMessage"=>"Pending OTP validation"
}
```

With `chargeResponseCode` still equals to `02` which means it didn't validate successfully and is till pending validation.

Otherwise if validation is successful using OTP, you will receive a response similar to this:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"Charge Complete", "txRef"=>"MC-eac8888322fa44343d1a3ed7c8025fde", "flwRef"=>"FLW-MOCK-01cb1be7b183cfdec0d5225316647378", "amount"=>10, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com"
}
```

With `chargeResponseCode` equals to `00` which means it validated successfully.

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` or `validate_charge` call.

#### Sample `verify_charge` call:

```ruby
response = charge_card.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in Ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>362093, "txref"=>"MC-eac8888322fa44343d1a3ed7c8025fde", "flwref"=>"FLW-MOCK-01cb1be7b183cfdec0d5225316647378", "devicefingerprint"=>"69e6b7f0b72037aa8428b70fbe03986c", "cycle"=>"one-time", "amount"=>10, "currency"=>"NGN", "chargedamount"=>10, "appfee"=>0.14, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"00", "chargemessage"=>"Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com", "authmodel"=>"PIN", "ip"=>"::ffff:10.69.80.227", "narration"=>"CARD Transaction ", "status"=>"successful", "vbvcode"=>"00", "vbvmessage"=>"successful", "authurl"=>"N/A", "acctcode"=>nil, "acctmessage"=>nil, "paymenttype"=>"card", "paymentid"=>"861", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>1, "createddayname"=>"MONDAY", "createdweek"=>51, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>17, "createdminute"=>4, "createdpmam"=>"pm", "created"=>"2018-12-17T17:04:45.000Z", "customerid"=>51655, "custphone"=>"0902620185", "custnetworkprovider"=>"AIRTEL", "custname"=>"temi desola", "custemail"=>"user@gmail.com", "custemailprovider"=>"GMAIL", "custcreated"=>"2018-09-24T07:59:14.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_1545066285779_8747935", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>"RV3154506628468675C4CD519A", "amountsettledforthistransaction"=>9.86, "card"=>{"expirymonth"=>"09", "expiryyear"=>"19", "cardBIN"=>"543889", "last4digits"=>"0229", "brand"=>"MASHREQ BANK CREDITSTANDARD", "card_tokens"=>[{"embedtoken"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k", "shortcode"=>"671c0", "expiry"=>"9999999999999"}], "type"=>"MASTERCARD", "life_time_token"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k"}, "meta"=>[{"id"=>1257583, "metaname"=>"flightID", "metavalue"=>"123949494DC", "createdAt"=>"2018-12-17T17:04:46.000Z", "updatedAt"=>"2018-12-17T17:04:46.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>362093}]}
}
```

NOTE: You can tokenize a card after charging the card for the first time for subsequent transactions done with the card without having to send the card details everytime a transaction is done. The card token can be gotten from the `.verify_charge` response, here's how to get the card token from our sample verify response:

`response['card']['card_tokens']['embed_tokens']` which is similar to this: `flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k`

### `.tokenized_charge(payload)`

This function is called to perform a charge a tokenized card. Its payload includes;

- `token`,

- `country`,

- `amount`,

- `email`,

- `firstname`,

- `lastname`,

- `txRef`,

- `currency`

#### Sample `tokenized charge` call:

```ruby
response = charge_card.tokenized_charge(payload)
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "validation_required"=>false, "message"=>"Charge success", "suggested_auth"=>nil, "txRef"=>"MC-f1085c1793bfaf171e667a21be6ec121", "flwRef"=>"FLW-M03K-218f54e6a06dc7da152f115c561f32d2", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Approved", "amount"=>10, "currency"=>"NGN", "validateInstruction"=>nil, "paymentType"=>"card", "authModelUsed"=>"noauth", "authurl"=>"N/A"
}

```
You can now verify the transaction by calling the `.verify_charge` function to verify the transaction and get the full response of the transaction.

#### Sample `verify_charge` call:

```ruby
response = charge_card.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in Ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>390050, "txref"=>"MC-f1085c1793bfaf171e667a21be6ec121", "flwref"=>"FLW-M03K-218f54e6a06dc7da152f115c561f32d2", "devicefingerprint"=>"N/A", "cycle"=>"one-time", "amount"=>10, "currency"=>"NGN", "chargedamount"=>10, "appfee"=>0.14, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"00", "chargemessage"=>"Approved", "authmodel"=>"noauth", "ip"=>"355426087298442", "narration"=>"Simply Recharge", "status"=>"successful", "vbvcode"=>"00", "vbvmessage"=>"Approved", "authurl"=>"N/A", "acctcode"=>nil, "acctmessage"=>nil, "paymenttype"=>"card", "paymentid"=>"861", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>1, "createddayname"=>"MONDAY", "createdweek"=>3, "createdmonth"=>0, "createdmonthname"=>"JANUARY", "createdquarter"=>1, "createdyear"=>2019, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>12, "createdminute"=>57, "createdpmam"=>"pm", "created"=>"2019-01-14T12:57:33.000Z", "customerid"=>51655, "custphone"=>"0902620185", "custnetworkprovider"=>"AIRTEL", "custname"=>"temi desola", "custemail"=>"user@gmail.com", "custemailprovider"=>"GMAIL", "custcreated"=>"2018-09-24T07:59:14.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_86BFB6FF6B6BB6CD6C9E", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>nil, "amountsettledforthistransaction"=>9.86, "card"=>{"expirymonth"=>"09", "expiryyear"=>"19", "cardBIN"=>"543889", "last4digits"=>"0229", "brand"=>"MASHREQ BANK CREDITSTANDARD", "card_tokens"=>[{"embedtoken"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k", "shortcode"=>"671c0", "expiry"=>"9999999999999"}], "type"=>"MASTERCARD", "life_time_token"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k"}, "meta"=>[{"id"=>1263976, "metaname"=>"flightID", "metavalue"=>"123949494DC", "createdAt"=>"2019-01-14T12:57:33.000Z", "updatedAt"=>"2019-01-14T12:57:33.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>390050}]}
}
```

If a transaction couldn't be verified successfully, `error` and `transaction_complete` would both come as `false`.

#### Full Card Transaction Flow:

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is used to perform card charge
payload = {
    "cardno" => "5438898014560229",
    "cvv" => "890",
    "expirymonth" => "09",
    "expiryyear" => "19",
    "currency" => "NGN",
    "country" => "NG",
    "amount" => "10",
    "email" => "user@gmail.com",
    "phonenumber" => "0902620185",
    "firstname" => "temi",
    "lastname" => "desola",
    "IP" => "355426087298442",
    "meta" => [{"metaname": "flightID", "metavalue": "123949494DC"}],
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
    "device_fingerprint" => "69e6b7f0b72037aa8428b70fbe03986c"
}

charge_card = Card.new(rave)

response = charge_card.initiate_charge(payload)

# Update payload with suggested auth
if response["suggested_auth"]
    suggested_auth = response["suggested_auth"]
    auth_arg = charge_card.get_auth_type(suggested_auth)
    if auth_arg == :pin
        updated_payload = charge_card.update_payload(suggested_auth, payload, pin: "3310")
    elsif auth_arg == :address
        updated_payload = charge_card.update_payload(suggested_auth, payload, address:{"billingzip"=> "07205", "billingcity"=> "Hillside", "billingaddress"=> "470 Mundet PI", "billingstate"=> "NJ", "billingcountry"=> "US"})
    end

    # Perform the second charge after payload is updated with suggested auth
    response = charge_card.initiate_charge(updated_payload)
    print response

    # Perform validation if it is required
    if response["validation_required"]
        response = charge_card.validate_charge(response["flwRef"], "12345")
        print response
    end
else
    # You can handle the get the auth url from this response and load it for the customer to complete the transaction if an auth url is returned in the response.
    print response
end

# Verify charge
response = charge_card.verify_charge(response["txRef"])
print response
```

## `Preauth.new(rave)`

This is used to process a preauthorized card transaction.

Its functions includes:

- `.initiate_charge`
- `.capture`
- `.refund`
- `.void`
- `.verify_preauth`

The payload should be a Ruby hash containing card information. It should have the following parameters:

- `token`,

- `country`,

- `amount`,

- `email`,

- `firstname`,

- `lastname`,

- `IP`,

- `txRef`,

- `currency`

NOTE: You need to use the same email used when charging the card for the first time to successfully charge the card.

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample `initiate_charge` call:

```ruby
response = preauth.initiate_charge(payload)
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"pending-capture", "message"=>"Charge success", "validation_required"=>false, "txRef"=>"MC-0df3e7e6cd58b226d4ba2a3d03dd200b", "flwRef"=>"FLW-PREAUTH-M03K-abdc01e69aa424b9e1ac44987ec21ec3", "amount"=>1000, "currency"=>"NGN", "paymentType"=>"card"
}
```

### `.capture(flwRef)`

The capture method is called after the preauth card has been charged. It takes in the `flwRef` from the charge response and call optionally take in amount less than the original amount authorised on the card as displayed below.

#### Sample `capture` call:

```ruby
response = preauth.capture(response["flwRef"], "30")
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"successful", "message"=>"Capture complete", "validation_required"=>false, "txRef"=>"MC-0df3e7e6cd58b226d4ba2a3d03dd200b", "flwRef"=>"FLW-PREAUTH-M03K-abdc01e69aa424b9e1ac44987ec21ec3", "amount"=>30, "currency"=>"NGN", "chargeResponseCode"=>"00", "chargeResponseMessage"=>"Approved", "paymentType"=>"card"
}
```

### `.refund(flwRef)`

This is called to perform a `refund` of a preauth transaction.

#### Sample `refund` call:

```ruby
response = preauth.refund(response["flwRef"])
```

### `.void(flwRef)`

This is called to `void` a preauth transaction.

#### Sample `void` call:

```ruby
response = preauth.void(response["flwRef"])
```

### `.verify_preauth(txRef)`

The verify_preauth method can be called after capture is successfully completed by passing the `txRef` from the `charge` or `capture` response as its argument as shown below.

#### Sample `verify_preauth` call:

```ruby
response = preauth.verify_preauth(response["txRef"])
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>370365, "txref"=>"MC-0df3e7e6cd58b226d4ba2a3d03dd200b", "flwref"=>"FLW-PREAUTH-M03K-abdc01e69aa424b9e1ac44987ec21ec3", "devicefingerprint"=>"N/A", "cycle"=>"one-time", "amount"=>30, "currency"=>"NGN", "chargedamount"=>30.42, "appfee"=>0.42, "merchantfee"=>0, "merchantbearsfee"=>0, "chargecode"=>"00", "chargemessage"=>"Approved", "authmodel"=>"noauth", "ip"=>"190.233.222.1", "narration"=>"TOKEN CHARGE", "status"=>"successful", "vbvcode"=>"00", "vbvmessage"=>"Approved", "authurl"=>"N/A", "acctcode"=>"FLWPREAUTH-M03K-CP-1545740097601", "acctmessage"=>"CAPTURE
REFERENCE", "paymenttype"=>"card", "paymentid"=>"861", "fraudstatus"=>"ok", "chargetype"=>"preauth", "createdday"=>2, "createddayname"=>"TUESDAY", "createdweek"=>52, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>12, "createdminute"=>14, "createdpmam"=>"pm", "created"=>"2018-12-25T12:14:54.000Z", "customerid"=>51655, "custphone"=>"0902620185", "custnetworkprovider"=>"AIRTEL", "custname"=>"temi desola", "custemail"=>"user@gmail.com", "custemailprovider"=>"GMAIL", "custcreated"=>"2018-09-24T07:59:14.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>nil, "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>nil, "amountsettledforthistransaction"=>30, "card"=>{"expirymonth"=>"09", "expiryyear"=>"19", "cardBIN"=>"543889", "last4digits"=>"0229", "brand"=>"MASHREQ BANK CREDITSTANDARD", "card_tokens"=>[{"embedtoken"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k", "shortcode"=>"671c0", "expiry"=>"9999999999999"}], "type"=>"MASTERCARD", "life_time_token"=>"flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k"}, "meta"=>[{"id"=>1259456, "metaname"=>"trxauthorizeid", "metavalue"=>"M03K-i0-8673be673b828e4b2863ef6d39d56cce", "createdAt"=>"2018-12-25T12:14:54.000Z", "updatedAt"=>"2018-12-25T12:14:54.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259457, "metaname"=>"trxreference", "metavalue"=>"FLW-PREAUTH-M03K-abdc01e69aa424b9e1ac44987ec21ec3", "createdAt"=>"2018-12-25T12:14:54.000Z", "updatedAt"=>"2018-12-25T12:14:54.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259458, "metaname"=>"old_amount", "metavalue"=>"1000", "createdAt"=>"2018-12-25T12:14:57.000Z", "updatedAt"=>"2018-12-25T12:14:57.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259459, "metaname"=>"old_charged_amount", "metavalue"=>"1000", "createdAt"=>"2018-12-25T12:14:57.000Z", "updatedAt"=>"2018-12-25T12:14:57.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259460, "metaname"=>"old_fee", "metavalue"=>"", "createdAt"=>"2018-12-25T12:14:57.000Z", "updatedAt"=>"2018-12-25T12:14:57.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}, {"id"=>1259461, "metaname"=>"old_merchant_fee",
"metavalue"=>"0", "createdAt"=>"2018-12-25T12:14:57.000Z", "updatedAt"=>"2018-12-25T12:14:57.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>370365}]}
}
```

#### Full Preauth Transaction Flow:

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is the payload for preauth charge
payload = {
    "token" => "flw-t1nf-75aa4a20695a54c1846e0e8bcae754ee-m03k",
    "country" => "NG",
    "amount" => "1000",
    "email" => "user@gmail.com",
    "firstname" => "temi",
    "lastname" => "Oyekole",
    "IP" => "190.233.222.1",
    "currency" => "NGN",
}

# Instantiate the preauth object
preauth = Preauth.new(rave)

# Perform a charge with the card token from the saved from the card charge
response = preauth.initiate_charge(payload)
print response

# Perform capture 
response = preauth.capture(response["flwRef"], "30")
print response

# Perform a refund
# response = preauth.refund(response["flwRef"])
# print response

# Void transaction
# response = preauth.void(response["flwRef"])
# print response

# Verify transaction
response = preauth.verify_preauth(response["txRef"])
print response
```

## `MobileMoney.new(rave)`

To perform ghana mobile money transactions, instantiate the mobile money object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate mobile money transaction. The payload should be a Ruby hash with mobile money details. Its parameters should include the following:

- `amount`,

- `email`,

- `phonenumber`,

- `network`,

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample mobile money charge` call:

```ruby
response = charge_mobile_money.initiate_charge(payload)
```
#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success-pending-validation", "validation_required"=>true, "txRef"=>"MC-83d9405416ff2a7312d8e3d5fceb3d52", "flwRef"=>"flwm3s4m0c1545818908919", "amount"=>50, "currency"=>"GHS", "validateInstruction"=>nil, "authModelUsed"=>"MOBILEMONEY", "paymentType"=>"mobilemoneygh"
}
```

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` call.

#### Sample `verify_charge` call:

```ruby
response = charge_mobile_money.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in Ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>371101, "txref"=>"MC-1c2a66b7bb6e55c254cad2a61b0ea47b", "flwref"=>"flwm3s4m0c1545824547181", "devicefingerprint"=>"N/A", "cycle"=>"one-time", "amount"=>50, "currency"=>"GHS", "chargedamount"=>50, "appfee"=>0.7, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"00", "chargemessage"=>"Pending Payment Validation", "authmodel"=>"MOBILEMONEY",
"ip"=>"::ffff:10.37.131.195", "narration"=>"Simply Recharge", "status"=>"successful", "vbvcode"=>"N/A", "vbvmessage"=>"N/A", "authurl"=>"NO-URL", "acctcode"=>"00", "acctmessage"=>"Approved", "paymenttype"=>"mobilemoneygh", "paymentid"=>"N/A", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>3, "createddayname"=>"WEDNESDAY", "createdweek"=>52, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>11, "createdminute"=>42, "createdpmam"=>"am", "created"=>"2018-12-26T11:42:26.000Z", "customerid"=>59839, "custphone"=>"08082000503", "custnetworkprovider"=>"AIRTEL", "custname"=>"Anonymous Customer", "custemail"=>"cezojejaze@nyrmusic.com", "custemailprovider"=>"COMPANY EMAIL", "custcreated"=>"2018-11-01T17:26:40.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_MMGH_1545824546523_5297935", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>nil, "amountsettledforthistransaction"=>49.3, "meta"=>[]}
}
```

If a transaction couldn't be verified successfully, `error` and `transaction_complete` would both come as `false`.

#### Full Mobile Money Transaction Flow:

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is used to perform mobile money charge
payload = {
    "amount" => "50",
    "email" => "cezojejaze@nyrmusic.com",
    "phonenumber" => "08082000503",
    "network" => "MTN",
    "redirect_url" => "https://webhook.site/6eb017d1-c605-4faa-b543-949712931895",
    "IP" => ""
}

# To initiate mobile money transaction
charge_mobile_money = MobileMoney.new(rave)

response = charge_mobile_money.initiate_charge(payload)

print response

# To verify the mobile money transaction
response = charge_mobile_money.verify_charge(response["txRef"])

print response
```

## `Mpesa.new(rave)`

To perform mpesa transactions, instantiate the mpesa object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate mpesa transaction. The payload should be a Ruby hash with mpesa details. Its parameters should include the following:

- `amount`,

- `email`,

- `phonenumber`,


You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample `mpesa charge` call:

```ruby
response = charge_mpesa.initiate_charge(payload)
```
#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"pending", "validation_required"=>true, "txRef"=>"MC-0ad3251bcdde39b16c225e9fc46e992c", "flwRef"=>"8833703548", "amount"=>"100", "currency"=>"KES", "paymentType"=>"mpesa"
}
```

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` call.

#### Sample `verify_charge` call:

```ruby
response = charge_mpesa.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in Ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>true, "data"=>{"txid"=>372498, "txref"=>"MC-0ad3251bcdde39b16c225e9fc46e992c", "flwref"=>"8833703548", "devicefingerprint"=>"N/A", "cycle"=>"one-time", "amount"=>100, "currency"=>"KES", "chargedamount"=>100, "appfee"=>1.4, "merchantfee"=>0, "merchantbearsfee"=>0, "chargecode"=>"00", "chargemessage"=>nil, "authmodel"=>"VBVSECURECODE", "ip"=>"::ffff:10.43.205.176", "narration"=>"funds payment", "status"=>"successful", "vbvcode"=>"N/A", "vbvmessage"=>"N/A", "authurl"=>"N/A", "acctcode"=>"00", "acctmessage"=>"MPESA COMPLETED", "paymenttype"=>"mpesa", "paymentid"=>"N/A", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>4, "createddayname"=>"THURSDAY", "createdweek"=>52, "createdmonth"=>11, "createdmonthname"=>"DECEMBER", "createdquarter"=>4, "createdyear"=>2018, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>18, "createdminute"=>50, "createdpmam"=>"pm", "created"=>"2018-12-27T18:50:51.000Z", "customerid"=>65231, "custphone"=>"0926420185", "custnetworkprovider"=>"UNKNOWN PROVIDER", "custname"=>"Anonymous customer", "custemail"=>"user@exampe.com", "custemailprovider"=>"COMPANY EMAIL", "custcreated"=>"2018-11-27T15:23:38.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1,
"acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"8833703548", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>nil, "amountsettledforthistransaction"=>98.6, "meta"=>[{"id"=>1259900, "metaname"=>"MPESARESPONSE", "metavalue"=>"{\"billrefnumber\":\"8833703548\",\"transactionamount\":\"100.00\",\"transactionid\":372498,\"type\":\"mpesa\"}", "createdAt"=>"2018-12-27T18:50:56.000Z", "updatedAt"=>"2018-12-27T18:50:56.000Z", "deletedAt"=>nil, "getpaidTransactionId"=>372498}]}
}
```

If a transaction couldn't be verified successfully, `error` and `transaction_complete` would both come as `false`.

#### Full Mpesa Transaction Flow:

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is used to perform mpesa charge
payload = {
    "amount" => "100",
    "phonenumber" => "0926420185",
    "email" => "user@exampe.com",
    "IP" => "40.14.290",
    "narration" => "funds payment",
}

# To initiate mpesa transaction
charge_mpesa = Mpesa.new(rave)

response = charge_mpesa.initiate_charge(payload)

print response

# To verify the mpesa transaction
response = charge_mpesa.verify_charge(response["txRef"])

print response
```

## `SubAccount.new(rave)`

This is used to process and manage subaccount flow. Instantiate the subaccount object and pass rave object as its argument.

Its functions includes:

- `.create_subaccount`
- `.list_subaccounts`
- `.fetch_subaccount`
- `.delete_subaccount`

### `.create_subaccount(payload)`

This function is called to initiate subaccount transaction. The payload should be a Ruby hash with the subaccount details. Its parameters should include the following:

- `account_bank`,

- `account_number`,

- `business_name`,

- `business_email`,

- `business_contact`,

- `business_contact_mobile`,

- `business_mobile`,

- `split_type`,

- `split_value`,

#### NOTE: 

- split_type can be set as percentage or flat when set as percentage it means you want to take a percentage fee on all transactions, and vice versa for flat this means you want to take a flat fee on every transaction.

- split_value can be a percentage value or flat value depending on what was set on split_type.

#### Sample `create_subaccount` call:

```ruby
response = subaccount.create_subaccount(payload)
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "id"=>350, "data"=>{"id"=>350, "account_number"=>"0690000033", "account_bank"=>"044", "business_name"=>"Test Stores", "fullname"=>"Bale Gary", "date_created"=>"2018-12-28T16:20:40.000Z", "meta"=>[{"metaname"=>"MarketplaceID", "metavalue"=>"ggs-920900"}], "account_id"=>14101, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>3000, "subaccount_id"=>"RS_CC09B109AA8F0CA5D9CE067492C548DA", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}
}
```

### `.list_subaccounts`

This function is called to list all subaccounts under an account. The function can be initiated by calling it on a subaccount object.

#### Sample `list_subaccount` call:

```ruby
response = subaccount.list_subaccounts
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{"status"=>"success", "message"=>"SUBACCOUNT-EDITED", "data"=>{"id"=>1234, "account_number"=>"1234567890", "account_bank"=>"044", "business_name"=>"Test Stores", "fullname"=>"Bale Gary", "date_created"=>"2019-07-18T10:53:32.000Z", "meta"=>[{"metaname"=>"MarketplaceID", "metavalue"=>"ggs-920900"}], "account_id"=>65394, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>3000, "subaccount_id"=>"RS_DB708DA61222E6ED845F63054A52FFAE", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}}
```

### `.fetch_subaccount(subaccount_id)`

This function is used to fetch a subaccount details by taking in the subaccount id as its argument.

#### Sample `fetch_subaccount` call:

```ruby
response = subaccount.fetch_subaccount("RS_CC09B109AA8F0CA5D9CE067492C548DA")
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"status"=>"success", "message"=>"SUBACCOUNT", "data"=>{"id"=>350, "account_number"=>"0690000033", "account_bank"=>"044", "business_name"=>"Test Stores", "fullname"=>"Bale Gary", "date_created"=>"2018-12-28T16:20:40.000Z", "meta"=>[{"metaname"=>"MarketplaceID", "metavalue"=>"ggs-920900"}], "account_id"=>14101, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>3000, "subaccount_id"=>"RS_CC09B109AA8F0CA5D9CE067492C548DA", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}}
}
```

### `.delete_subaccount(subaccount_id)`

This function is used to delete a subaccount by taking in the subaccount id as its argument.

#### Sample `delete_subaccount` call:

```ruby
response = subaccount.delete_subaccount("RS_CC09B109AA8F0CA5D9CE067492C548DA")
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"status"=>"success", "message"=>"SUBACCOUNT-DELETED", "data"=>"Deleted"}
}
```

### `.update_subaccount(id)`

This function is used to update a subaccount by taking in the  id as its argument.

#### Sample `update_subaccount` call:

```ruby
response = subaccount.update_subaccount("1234")
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"status"=>"success", "message"=>"SUBACCOUNT-EDITED", "data"=>{"id"=>1234, "account_number"=>"1234567890", "account_bank"=>"0
44", "business_name"=>"Test Stores", "fullname"=>"Bale Gary", "date_created"=>"2019-07-18T10:53:32.000Z", "meta"=>[{"metaname"=>"MarketplaceID", "meta
value"=>"ggs-920900"}], "account_id"=>65394, "split_ratio"=>1, "split_type"=>"flat", "split_value"=>3000, "subaccount_id"=>"RS_DB708DA61222E6ED845F630
54A52FFAE", "bank_name"=>"ACCESS BANK NIGERIA", "country"=>"NG"}}
}
```

#### Full SubAccount Flow:

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is the payload for sub account creation
payload = {
    "account_bank" => "044",
    "account_number" => "0690000033",
    "business_name" => "Test Stores",
    "business_email" => "test@test.com",
    "business_contact" => "john doe",
    "business_contact_mobile" => "09083772",
    "business_mobile" => "0188883882",
    "split_type" => "flat",
    "split_value" => 3000,
    "meta" => [{"metaname": "MarketplaceID", "metavalue": "ggs-920900"}]
}

# Instantiate the subaccount object
subaccount = SubAccount.new(rave)

# This is used to create a subaccount
response = subaccount.create_subaccount(payload)
print response

# This is used to list all subaccounts
response = subaccount.list_subaccounts
print response

# This is used to fetch a subaccount by taking in the subaccount id
response = subaccount.fetch_subaccount("RS_A59429B9C94C5A862F731711290B9ADD")
print response

# This is used to delete a subaccount by taking in the subaccount id
response = subaccount.delete_subaccount("RS_A59429B9C94C5A862F731711290B9ADD")
print response
```

## `PaymentPlan.new(rave)`

This is used to process and manage payment plan flow. Instantiate the paymentplan object and pass rave object as its argument.

Its functions includes:

- `.create_payment_plan`
- `.list_payment_plans`
- `.fetch_payment_plan`
- `.edit_payment_plan`
- `.cancel_payment_plan`

### `.create_payment_plan(payload)`

This function is called to initiate payment plan transaction. The payload should be a Ruby hash with the payment plan details. Its parameters should include the following:

- `amount`,

- `name`,

- `interval`,

- `duration`,

#### NOTE: 

- amount: this is the amount for the plan

- name: This is what would appear on the subscription reminder email

- interval: This are the charge intervals possible values are:

```
daily;
weekly;
monthly;
yearly;
quarterly;
bi-anually;
every 2 days;
every 90 days;
every 5 weeks;
every 12 months;
every 6 years;
every x y (where x is a number and y is the period e.g. every 5 months)
```

- duration: This is the frequency, it is numeric, e.g. if set to 5 and intervals is set to monthly you would be charged 5 months, and then the subscription stops.

`If duration is not passed, any subscribed customer will be charged indefinitely.`

#### Sample `create_payment_plan` call:

```ruby
response = payment_plan.create_payment_plan(payload)
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"id"=>1298, "name"=>"New Test Plan", "amount"=>1000, "interval"=>"monthly", "duration"=>5, "status"=>"active",
"currency"=>"NGN", "plan_token"=>"rpp_9002500b0440b470f02c", "date_created"=>"2018-12-30T10:54:06.000Z"}
}
```

### `.list_payment_plans`

This function is called to list all payment plans under an account. The function can be initiated by calling it on a paymentplan object.

#### Sample `list_payment_plans` call:

```ruby
response = payment_plan.list_payment_plans
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"QUERIED-PAYMENTPLANS", "data"=>{"page_info"=>{"total"=>21, "current_page"=>1, "total_pages"=>3}, "paymentplans"=>[{"id"=>1298, "name"=>"New Test Plan", "amount"=>1000, "interval"=>"monthly", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_9002500b0440b470f02c", "date_created"=>"2018-12-30T10:54:06.000Z"}, {"id"=>1225, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_6da8f78957b92b3e9128", "date_created"=>"2018-12-12T20:22:43.000Z"}, {"id"=>1196, "name"=>"Jack's Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_49ae581c01d998841116", "date_created"=>"2018-12-04T16:42:58.000Z"}, {"id"=>1195, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_7156462224bc29c5e429", "date_created"=>"2018-12-04T16:39:41.000Z"}, {"id"=>1194, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_a361053c176ae01ae6ea", "date_created"=>"2018-12-04T16:39:14.000Z"}, {"id"=>1193, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_4a6ca4bedef850362dbd", "date_created"=>"2018-12-04T16:34:10.000Z"}, {"id"=>1192, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_7185c10c96eae1b62c92", "date_created"=>"2018-12-04T16:33:22.000Z"}, {"id"=>1191, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_c0bcf71beb2d048d0883", "date_created"=>"2018-12-04T16:32:00.000Z"}, {"id"=>1190, "name"=>"Test Plan", "amount"=>100, "interval"=>"daily", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_607c22f130a5a90e51af", "date_created"=>"2018-12-04T16:27:27.000Z"}, {"id"=>1154, "name"=>"N/A", "amount"=>0, "interval"=>"daily", "duration"=>0, "status"=>"cancelled", "currency"=>"NGN", "plan_token"=>"rpp_cb2ec11390fd718b6eb0", "date_created"=>"2018-11-27T11:31:21.000Z"}]}
}
```

### `.fetch_payment_plan(payment_plan_id, payment_plan_name)`

This function is used to fetch a payment plan details by taking in the payment plan id and payment plan name as its argument.

#### Sample `fetch_payment_plan` call:

```ruby
response = payment_plan.fetch_payment_plan("1298", "New Test Plan")
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"page_info"=>{"total"=>1, "current_page"=>1, "total_pages"=>1}, "paymentplans"=>[{"id"=>1298, "name"=>"New Test Plan", "amount"=>1000, "interval"=>"monthly", "duration"=>5, "status"=>"active", "currency"=>"NGN", "plan_token"=>"rpp_9002500b0440b470f02c", "date_created"=>"2018-12-30T10:54:06.000Z"}]}
}
```

### `.edit_payment_plan(payment_plan_id, payment_plan_name)`

This function is used to edit a payment plan by taking in the the payment plan id and payment plan name as its argument.

#### Sample `edit_payment_plan` call:

```ruby

response = payment_plan.edit_payment_plan("1298", {"name" => "Updated Test Plan", "status" => "active"})
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"id"=>1298, "name"=>"Updated Test Plan", "uuid"=>"rpp_9002500b0440b470f02c", "status"=>"active", "start"=>nil,
"stop"=>nil, "initial_charge_amount"=>nil, "currency"=>"NGN", "amount"=>1000, "duration"=>5, "interval"=>"monthly", "createdAt"=>"2018-12-30T10:54:06.000Z", "updatedAt"=>"2018-12-30T11:26:17.000Z", "deletedAt"=>nil, "AccountId"=>3328, "paymentpageId"=>nil}
}
```

### `.cancel_payment_plan("payment_plan_id")`

This function is used to cancel a payment plan by taking in the payment plan id as its argument.

#### Sample `cancel_payment_plan` call:

```ruby
response = payment_plan.cancel_payment_plan("1298")
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"id"=>1298, "name"=>"Updated Test Plan", "uuid"=>"rpp_9002500b0440b470f02c", "status"=>"cancelled", "start"=>nil, "stop"=>nil, "initial_charge_amount"=>nil, "currency"=>"NGN", "amount"=>1000, "duration"=>5, "interval"=>"monthly", "createdAt"=>"2018-12-30T10:54:06.000Z", "updatedAt"=>"2018-12-30T11:44:55.000Z", "deletedAt"=>nil, "AccountId"=>3328, "paymentpageId"=>nil}
}
```

#### Full PaymentPlan Flow:

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# Payment plan payload
payload = {
    "amount" => 1000,
    "name" => "New Test Plan",
    "interval" => "monthly",
    "duration" => 5
}

# Create an instance of the payment plan object
payment_plan = PaymentPlan.new(rave)

# Method to create payment plan
# response = payment_plan.create_payment_plan(payload)
# print response

# Method to list all payment plan
# response = payment_plan.list_payment_plans
# print response

# Method to fetch payment plan
response = payment_plan.fetch_payment_plan("1298", "New Test Plan")
print response

# Method to edit payment plan
response = payment_plan.edit_payment_plan("1298", {"name" => "Updated Test Plan", "status" => "active"})
print response

# Method to cancel payment plan
response = payment_plan.cancel_payment_plan("1298")
print response

```
## `Subscription.new(rave)`

This is used to process and manage subscription flow. Instantiate the subscription object and pass rave object as its argument.

Its functions includes:

- `.list_all_subscription`
- `.fetch_subscription`
- `.activate_subscription`
- `.cancel_subscription`

### `.list_all_subscription`

This function is called to fetch and list all subscription.

#### Sample `list_all_subscription` call:

```ruby
response = subscription.list_all_subscription
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"SUBSCRIPTIONS-FETCHED", "data"=>{"page_info"=>{"total"=>6, "current_page"=>1, "total_pages"=>1}, "plansubscriptions"=>[{"id"=>1785, "amount"=>100, "customer"=>{"id"=>83207, "customer_email"=>"horozex@ace-mail.net"}, "plan"=>1296, "status"=>"cancelled",
    "date_created"=>"2019-02-06T21:03:21.000Z"}, {"id"=>1726, "amount"=>100, "customer"=>{"id"=>51655, "customer_email"=>"user@gmail.com"}, "plan"=>1296, "status"=>"cancelled", "date_created"=>"2019-01-29T08:58:38.000Z"}, {"id"=>1724, "amount"=>100, "customer"=>{"id"=>51655, "customer_email"=>"user@gmail.com"}, "plan"=>1296, "status"=>"cancelled", "date_created"=>"2019-01-28T17:16:46.000Z"}, {"id"=>1720,
    "amount"=>100, "customer"=>{"id"=>51655, "customer_email"=>"user@gmail.com"}, "plan"=>1296, "status"=>"cancelled", "date_created"=>"2019-01-26T17:15:36.000Z"}, {"id"=>1719, "amount"=>100, "customer"=>{"id"=>51655, "customer_email"=>"user@gmail.com"}, "plan"=>1296, "status"=>"cancelled", "date_created"=>"2019-01-26T15:13:07.000Z"}, {"id"=>1533, "amount"=>100, "customer"=>{"id"=>73332, "customer_email"=>"jolaosoyusuf16@gmail.com"}, "plan"=>1296, "status"=>"active", "date_created"=>"2018-12-29T11:47:45.000Z"}]}, "plansubscriptions"=>[{"id"=>1785, "amount"=>100, "customer"=>{"id"=>83207, "customer_email"=>"horozex@ace-mail.net"}, "plan"=>1296, "status"=>"cancelled", "date_created"=>"2019-02-06T21:03:21.000Z"}, {"id"=>1726, "amount"=>100, "customer"=>{"id"=>51655, "customer_email"=>"user@gmail.com"}, "plan"=>1296, "status"=>"cancelled", "date_created"=>"2019-01-29T08:58:38.000Z"}, {"id"=>1724, "amount"=>100, "customer"=>{"id"=>51655, "customer_email"=>"user@gmail.com"}, "plan"=>1296, "status"=>"cancelled", "date_created"=>"2019-01-28T17:16:46.000Z"}, {"id"=>1720, "amount"=>100, "customer"=>{"id"=>51655, "customer_email"=>"user@gmail.com"}, "plan"=>1296, "status"=>"cancelled", "date_created"=>"2019-01-26T17:15:36.000Z"}, {"id"=>1719, "amount"=>100, "customer"=>{"id"=>51655, "customer_email"=>"user@gmail.com"}, "plan"=>1296, "status"=>"cancelled", "date_created"=>"2019-01-26T15:13:07.000Z"}, {"id"=>1533, "amount"=>100, "customer"=>{"id"=>73332, "customer_email"=>"jolaosoyusuf16@gmail.com"}, "plan"=>1296, "status"=>"active", "date_created"=>"2018-12-29T11:47:45.000Z"}]
}
```

### `.fetch_subscription(transaction_id)`

This function is called to fetch a single subscription by taking the transaction id from a successful charge or verify response as its arguments.

#### Sample `fetch_subscription` call:

```ruby
response = subscription.fetch_subscription("426082")
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"SUBSCRIPTIONS-FETCHED", "data"=>{"page_info"=>{"total"=>1, "current_page"=>1, "total_pages"=>1}, "plansubscriptions"=>[{"id"=>1794, "amount"=>100, "customer"=>{"id"=>51655, "customer_email"=>"user@gmail.com"}, "plan"=>1296, "status"=>"active", "date_created"=>"2019-02-07T16:04:34.000Z"}]}
}
```

### `.activate_subscription(transaction_id)`

This function is called to activate a subscription by taking the transaction id from a successful charge or verify response as its arguments.

#### Sample `activate_subscription` call:

```ruby
response = subscription.activate_subscription(426082)
```
#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
  "error"=>false,
  "status"=> "success",
  "message"=> "SUBSCRIPTION-ACTIVATED",
  "data"=> {
    "id"=> 1794,
    "amount"=> 100,
    "customer"=> {
      "id"=> 51655,
      "customer_email"=> "user@gmail.com"
    },
    "plan"=> 1296,
    "status"=> "active",
    "date_created"=> "2019-02-07T16:04:34.000Z"
  }
}
```

### `.cancel_subscription(transaction_id)`

This function is called to cancel a subscription by taking the transaction id from a successful charge or verify response as its arguments.

#### Sample `cancel_subscription` call:

```ruby
response = subscription.cancel_subscription(426082)
```
#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
  "error"=>false,
  "status" => "success",
  "message"=> "SUBSCRIPTION-CANCELLED",
  "data"=> {
    "id"=> 1794,
    "amount"=> 100,
    "customer"=> {
      "id"=> 51655,
      "customer_email"=> "user@gmail.com"
    },
    "plan"=> 1296,
    "status"=> "cancelled",
    "date_created"=> "2019-02-07T16:04:34.000Z"
  }
}
```

### Full Subscription Flow

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

subscription = Subscription.new(rave)
response = subscription.list_all_subscription
print response
response = subscription.fetch_subscription("1")
print response
response = subscription.activate_subscription(1533)
print response
response = subscription.cancel_subscription(1533)
print response
```

## `Transfer.new(rave)`

This is used to initiate transfer flow. Instantiate the transfer object and pass rave object as its argument.

Its functions includes:

- `.initiate_transfer`
- `.bulk_transfer`
- `.get_fee`
- `.get_balance`
- `.fetch`
- `.fetch_all_transfers`

### `.initiate_transfer`

This function is called to initiate a single transfer from one account to another. The payload should be a Ruby hash with the beneficiary's account details. Its parameters should include the following:

- `account_bank`,

- `account_number`,

- `amount`,

- `narration`,

- `currency`,

#### NOTE: 

For international transfers, you must pass a meta parameter as part of your payload as shown in the sample below:

```ruby
"meta": [
    {
      "AccountNumber": "09182972BH",
      "RoutingNumber": "0000000002993",
      "SwiftCode": "ABJG190",
      "BankName": "BANK OF AMERICA, N.A., SAN FRANCISCO, CA",
      "BeneficiaryName": "Mark Cuban",
      "BeneficiaryAddress": "San Francisco, 4 Newton",
      "BeneficiaryCountry": "US"
    }
]
```
#### Sample `initiate_transfer` call:

```ruby
response = transfer.initiate_transfer(payload)
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "id"=>4520, "data"=>{"id"=>4520, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2019-01-02T08:07:26.000Z", "currency"=>"NGN", "amount"=>500, "fee"=>45, "status"=>"NEW", "reference"=>"MC-df53da98eb0d7475c9e33727dec09e78", "meta"=>nil, "narration"=>"New transfer", "complete_message"=>"", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}
}
```

### `.bulk_transfer`

This function is called to initiate a bulk transfer. The payload should be a Ruby hash with the beneficiaries account details. Its parameters should include the following:

- `title`,

- `bulk_data`,

#### NOTE:

The `bulk_data` should consist of an array of the beneficiaries account details which includes `account_bank`, `account_number`, `amount`, `narration`, `currency`, `reference`.

#### Sample `bulk_transfer` call:

```ruby
response = transfer.bulk_transfer(payload)
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success", "message"=>"BULK-TRANSFER-CREATED", "id"=>765, "data"=>{"id"=>765, "date_created"=>"2019-01-02T08:20:20.000Z", "approver"=>"N/A"}
}
```

### `.get_fee`

This function is called to get transfer rates for all Rave supported currencies. You may or may not pass in a currency as its argument. If you do not pass in a currency, all Rave supported currencies transfer rates will be returned.

#### Sample `get_fee` call:

```ruby
response = transfer.get_fee(currency)
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "data"=>{"status"=>"success", "message"=>"TRANSFER-FEES", "data"=>[{"id"=>1, "fee_type"=>"value", "currency"=>"NGN", "fee"=>45, "createdAt"=>nil, "updatedAt"=>nil, "deletedAt"=>nil, "AccountId"=>1}]}
}
```

### `.get_balance`

This function is called to get balance an account. You may or may not pass in a currency as its argument.

#### Sample `get_balance` call:

```ruby
response = transfer.get_balance(currency)
```
#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "returned_data"=>{"status"=>"success", "message"=>"WALLET-BALANCE", "data"=>{"Id"=>27622, "ShortName"=>"NGN", "WalletNumber"=>"3927000121168", "AvailableBalance"=>100, "LedgerBalance"=>100}}
}
```

### `.fetch`

This function is called to fetch a single transfer. It takes in transfer refernce as its argument.

#### Sample `fetch` call:

```ruby
response = transfer.fetch("Bulk Transfer 2")
```
#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "returned_data"=>{"status"=>"success", "message"=>"QUERIED-TRANSFERS", "data"=>{"page_info"=>{"total"=>0, "current_page"=>0, "total_pages"=>0}, "transfers"=>[]}}
}
```

### `.fetch_all_transfers`

This function is called to fetch all transfers.

#### Sample `fetch_all_transfers` call:

```ruby
response = transfer.fetch_all_transfers
```
#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "returned_data"=>{"status"=>"success", "message"=>"QUERIED-TRANSFERS", "data"=>{"page_info"=>{"total"=>97, "current_page"=>1, "total_pages"=>10}, "transfers"=>[{"id"=>4520, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2019-01-02T08:07:26.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-df53da98eb0d7475c9e33727dec09e78", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}, {"id"=>4103, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2018-12-14T16:38:23.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-3b3814d6e2bc0d7d6683354abcdd5b98", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}, {"id"=>4102, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2018-12-14T14:54:31.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-26efdf0a77145315ac7d62ee274371a5", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}, {"id"=>4101, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2018-12-14T11:00:29.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-1d7ad363292b0c3a18cbccff891bd332", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}, {"id"=>4074, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2018-12-13T21:24:50.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-96d44c562f077869953b63a0d86e8263", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}, {"id"=>4073, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2018-12-13T21:16:08.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-510222befb79c0ac9d6aa6cb0010547a", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}, {"id"=>4072, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2018-12-13T21:09:52.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-38e5c011326d88b67f2ae9fe39e94212", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}, {"id"=>4071, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2018-12-13T20:59:21.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-9dbe233dc15abf647412670d965d9fce", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}, {"id"=>4070, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2018-12-13T20:31:45.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-e2d49d7f68e48d80dfdab2871d14bda3", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}, {"id"=>4069, "account_number"=>"0690000044", "bank_code"=>"044", "fullname"=>"Mercedes Daniel", "date_created"=>"2018-12-13T20:22:50.000Z", "currency"=>"NGN", "debit_currency"=>nil, "amount"=>500, "fee"=>45, "status"=>"FAILED", "reference"=>"MC-5af02b704d1d66884f7e50fe7a81ba82", "meta"=>nil, "narration"=>"New transfer", "approver"=>nil, "complete_message"=>"DISBURSE FAILED: Insufficient funds", "requires_approval"=>0, "is_approved"=>1, "bank_name"=>"ACCESS BANK NIGERIA"}]}}
}
```

### Full Transfer Flow

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is used to initiate single transfer
payload = {
    "account_bank" => "044",
    "account_number" => "0690000044",
    "amount" => 500,
    "narration" => "New transfer",
    "currency" => "NGN",
}

transfer = Transfer.new(rave)

response = transfer.initiate_transfer(payload)
print response

# This is used to send bulk transfer

# payload = {
#     "title" => "test",
#     "bulk_data" => [
#         {
#             "account_bank" => "044",
#             "account_number" => "0690000044",
#             "amount" => 500,
#             "narration" => "Bulk Transfer 1",
#             "currency" => "NGN",
#             "reference" => "MC-bulk-reference-1"
#         },
#         {
#             "account_bank" => "044",
#             "account_number" => "0690000034",
#             "amount" => 500,
#             "narration" => "Bulk Transfer 2",
#             "currency" => "NGN",
#             "reference" => "MC-bulk-reference-1"
#         }
#     ]
# }


# transfer = Transfer.new(rave)

# response = transfer.bulk_transfer(payload)
# print response

# This is used to get the transfer fee by taking in the currency
response = transfer.get_fee("NGN")
print response

# This is used to get the balance by taking in the currency
response = transfer.get_balance("NGN")
print response

# This is used to fetch a single transfer by passing in the transaction reference
response = transfer.fetch("Bulk Transfer 2")
print response

# This is used to fetch all transfer
response = transfer.fetch_all_transfers
print response
```

## `UgandaMobileMoney.new(rave)`

To perform uganda mobile money transactions, instantiate the uganda mobile money object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate uganda mobile money transaction. The payload should be a Ruby hash with uganda mobile money details. Its parameters should include the following:

- `amount`,

- `email`,

- `phonenumber`,

- `network`,

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample `initiate_charge` call:

```ruby
response = charge_uganda_mobile_money.initiate_charge(payload)
```

#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success-pending-validation", "validation_required"=>true, "txRef"=>"MC-c716f37ff7c0f719c5976aaf239e11e1", "flwRef"=>"flwm3s4m0c1546503628014", "amount"=>30, "currency"=>"UGX", "validateInstruction"=>nil, "authModelUsed"=>"MOBILEMONEY", "paymentType"=>"mobilemoneygh"
}
```

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` call.

#### Sample `verify_charge` call:

```ruby
response = charge_uganda_mobile_money.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in Ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>false, "data"=>{"txid"=>378423, "txref"=>"MC-c716f37ff7c0f719c5976aaf239e11e1", "flwref"=>"flwm3s4m0c1546503628014", "devicefingerprint"=>"N/A", "cycle"=>"one-time", "amount"=>30, "currency"=>"UGX", "chargedamount"=>30, "appfee"=>0.8, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"02", "chargemessage"=>"Pending Payment Validation", "authmodel"=>"MOBILEMONEY", "ip"=>"::ffff:10.65.63.158", "narration"=>"Simply Recharge", "status"=>"success-pending-validation", "vbvcode"=>"N/A", "vbvmessage"=>"N/A", "authurl"=>"NO-URL", "acctcode"=>nil, "acctmessage"=>nil, "paymenttype"=>"mobilemoneygh", "paymentid"=>"N/A", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>4, "createddayname"=>"THURSDAY", "createdweek"=>1, "createdmonth"=>0, "createdmonthname"=>"JANUARY",
"createdquarter"=>1, "createdyear"=>2019, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>8, "createdminute"=>20, "createdpmam"=>"am", "created"=>"2019-01-03T08:20:27.000Z", "customerid"=>66732, "custphone"=>"054709929300", "custnetworkprovider"=>"UNKNOWN PROVIDER", "custname"=>"Edward Kisane", "custemail"=>"tester@flutter.co", "custemailprovider"=>"COMPANY EMAIL", "custcreated"=>"2018-12-03T11:33:23.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_MMGH_1546503627253_1491735", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>nil, "meta"=>[]}
}
```

If the `chargecode` returned is `02`, it means the transaction is still pending validation else if it returns `00`, it means the transaction is successfully completed.

#### Full Uganda Mobile Money Transaction Flow:

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is used to perform mobile money charge
payload = {
    "amount" => "30",
    "phonenumber" => "054709929300",
    "firstname" => "Edward",
    "lastname" => "Kisane",
    "network" => "UGX",
    "email" => "tester@flutter.co",
    "IP" => '103.238.105.185',
    "redirect_url" => "https://webhook.site/6eb017d1-c605-4faa-b543-949712931895",
}

# To initiate uganda mobile money transaction
charge_uganda_mobile_money = UgandaMobileMoney.new(rave)

response = charge_uganda_mobile_money.initiate_charge(payload)

print response

# To verify the mobile money transaction
response = charge_uganda_mobile_money.verify_charge(response["txRef"])

print response
```

## `ZambiaMobileMoney.new(rave)`

To perform zambia mobile money transactions, instantiate the zambia mobile money object and pass rave object as its argument.

Its functions includes:

- `.initiate_charge`
- `.verify_charge`

### `.initiate_charge(payload)`

This function is called to initiate zambia mobile money transaction. The payload should be a Ruby hash with uganda mobile money details. Its parameters should include the following:

- `amount`,

- `email`,

- `phonenumber`,

- `network`,

You can also add your custom transaction reference `(txRef)`, if not, one would be automatically generated for you in which we used the ruby `securerandom` module for generating this in the `Util` module.

#### Sample `initiate_charge` call:

```ruby
response = charge_zambia_mobile_money.initiate_charge(payload)
```
#### which returns:

It returns this response in Ruby hash. A sample response:

```ruby
{
    "error"=>false, "status"=>"success-pending-validation", "validation_required"=>true, "txRef"=>"MC-bed3093128cd133623ad3cc7cbfc22b2", "flwRef"=>"flwm3s4m0c1549542975743", "amount"=>30, "currency"=>"ZMW", "validateInstruction"=>nil, "authModelUsed"=>"MOBILEMONEY", "paymentType"=>"mobilemoneyzm"
}
```

### `.verify_charge(txRef)`

You can call the `verify_charge` function to check if your transaction was completed successfully. To do this, you have to pass the transaction reference generated at the point of making your charge call. This is the txRef in the response parameter returned in any of the `initiate_charge` call.

#### Sample `verify_charge` call:

```ruby
response = charge_zambia_mobile_money.verify_charge(response["txRef"])
```

#### which returns:

It returns this response in Ruby hash with the `txRef`, `flwRef` and `transaction_complete` which indicates the transaction is successfully completed.

Full sample response returned if a transaction is successfully verified:

```ruby
{
    "error"=>false, "transaction_complete"=>false, "data"=>{"txid"=>425673, "txref"=>"MC-bed3093128cd133623ad3cc7cbfc22b2", "flwref"=>"flwm3s4m0c1549542975743", "devicefingerprint"=>"N/A", "cycle"=>"one-time", "amount"=>30, "currency"=>"ZMW", "chargedamount"=>30, "appfee"=>0.42, "merchantfee"=>0, "merchantbearsfee"=>1, "chargecode"=>"02", "chargemessage"=>"Pending Payment Validation", "authmodel"=>"MOBILEMONEY", "ip"=>"::ffff:10.63.225.86", "narration"=>"Simply Recharge", "status"=>"success-pending-validation", "vbvcode"=>"N/A", "vbvmessage"=>"N/A", "authurl"=>"NO-URL", "acctcode"=>nil, "acctmessage"=>nil, "paymenttype"=>"mobilemoneyzm", "paymentid"=>"N/A", "fraudstatus"=>"ok", "chargetype"=>"normal", "createdday"=>4, "createddayname"=>"THURSDAY", "createdweek"=>6, "createdmonth"=>1, "createdmonthname"=>"FEBRUARY", "createdquarter"=>1, "createdyear"=>2019, "createdyearisleap"=>false, "createddayispublicholiday"=>0, "createdhour"=>12, "createdminute"=>36, "createdpmam"=>"pm", "created"=>"2019-02-07T12:36:15.000Z", "customerid"=>83416, "custphone"=>"054709929300", "custnetworkprovider"=>"UNKNOWN PROVIDER",
    "custname"=>"John Doe", "custemail"=>"user@example.com", "custemailprovider"=>"COMPANY EMAIL", "custcreated"=>"2019-02-07T12:36:14.000Z", "accountid"=>6076, "acctbusinessname"=>"Simply Recharge", "acctcontactperson"=>"Jolaoso Yusuf", "acctcountry"=>"NG", "acctbearsfeeattransactiontime"=>1, "acctparent"=>1, "acctvpcmerchant"=>"N/A", "acctalias"=>nil, "acctisliveapproved"=>0, "orderref"=>"URF_MMGH_1549542975097_8307535", "paymentplan"=>nil, "paymentpage"=>nil, "raveref"=>nil, "meta"=>[]}
}
```

If the `chargecode` returned is `02`, it means the transaction is still pending validation else if it returns `00`, it means the transaction is successfully completed.

#### Full Zambia Mobile Money Transaction Flow:

```ruby
require 'rave_ruby'

# This is a rave object which is expecting public and secret keys
rave = RaveRuby.new("FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxxxx-X")

# This is used to perform zambia mobile money charge
payload = {
    "amount" => "30",
    "phonenumber" => "054709929300",
    "firstname" => "John",
    "lastname" => "Doe",
    "network" => "MTN",
    "email" => "user@example.com",
    "IP" => '355426087298442',
    "redirect_url" => "https://webhook.site/6eb017d1-c605-4faa-b543-949712931895",
}

# To initiate zambia mobile money transaction
charge_zambia_mobile_money = ZambiaMobileMoney.new(rave)

response = charge_zambia_mobile_money.initiate_charge(payload)

print response

# To verify the zambia mobile money transaction
response = charge_zambia_mobile_money.verify_charge(response["txRef"])

print response
```

## `Ussd.new(rave)`

NOTE: This option is currently unavailable.

## `ListBanks.new(rave)`

This function is called to fetch and return a list of banks currently supported by rave.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributors

- [Ifunanya Ikemma](https://github.com/iphytech)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MaestroJolly/rave_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RaveRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/MaestroJolly/rave_ruby/blob/master/CODE_OF_CONDUCT.md).
