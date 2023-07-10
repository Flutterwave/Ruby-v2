require_relative "rave_ruby/rave_modules/base_endpoints"
require_relative "rave_ruby/rave_objects/base/base"
require_relative "rave_ruby/rave_modules/util"
require_relative "rave_ruby/rave_objects/list_banks"
require_relative "rave_ruby/rave_objects/card"
require_relative "rave_ruby/rave_objects/account"
require_relative "rave_ruby/rave_objects/transfer"
require_relative "rave_ruby/rave_objects/mpesa"
require_relative "rave_ruby/rave_objects/mobile_money"
require_relative "rave_ruby/rave_objects/uganda_mobile_money"
require_relative "rave_ruby/rave_objects/zambia_mobile_money"
require_relative "rave_ruby/rave_objects/payment_plan"
require_relative "rave_ruby/rave_objects/subscription"
require_relative "rave_ruby/rave_objects/ussd"
require_relative "rave_ruby/rave_objects/preauth"
require_relative "rave_ruby/rave_objects/sub_account"
require_relative 'rave_ruby/error'


  class RaveRuby

      attr_accessor :public_key, :secret_key, :encryption_key, :production, :url

      # method to initialize rave object

      def initialize(public_key=nil, secret_key=nil, encryption_key=nil, production=false)

        @public_key = public_key
        @secret_key = secret_key
        @production = production
        @encryption_key = encryption_key
        rave_sandbox_url = BASE_ENDPOINTS::RAVE_SANDBOX_URL
        rave_live_url = BASE_ENDPOINTS::RAVE_LIVE_URL

        # set rave url to sandbox or live if we are in production or development
        if production == false
            @url =  rave_sandbox_url
        else
            @url = rave_live_url
        end


        # check if we set our public and secret keys to the environment variable
        if (public_key.nil?)
          @public_key = ENV['RAVE_PUBLIC_KEY']
        else
          @public_key = public_key
        end

        if(secret_key.nil?)
          @secret_key = ENV['RAVE_SECRET_KEY']
        else
          @secret_key = secret_key
        end

        if(encryption_key.nil?)
          @encryption_key = ENV['RAVE_ENCRYPTION_KEY']
        else
          @encryption_key = encryption_key
        end
          warn "Warning: To ensure your rave account api keys are safe, It is best to always set your keys in the environment variable"


        # raise this error if no public key is passed
        unless !@public_key.nil?
          raise RaveBadKeyError, "No public key supplied and couldn't find any in environment variables. Make sure to set public key as an environment variable RAVE_PUBLIC_KEY"
        end
        # raise this error if invalid public key is passed
        unless  @public_key[0..7] == 'FLWPUBK-' || @public_key[0..11] == 'FLWPUBK_TEST'
          raise RaveBadKeyError, "Invalid public key #{@public_key}"
        end

        # raise this error if no secret key is passed
        unless !@secret_key.nil?
          raise RaveBadKeyError, "No secret key supplied and couldn't find any in environment variables. Make sure to set secret key as an environment variable RAVE_SECRET_KEY"
        end
        # raise this error if invalid secret key is passed
        unless @secret_key[0..7] == 'FLWSECK-' || @secret_key[0..11] == 'FLWSECK_TEST'
          raise RaveBadKeyError, "Invalid secret key #{@secret_key}"
        end

        # raise this error if no encryption key is passed
        unless !@encryption_key.nil?
          raise RaveBadKeyError, "No encryption key supplied and couldn't find any in environment variables. Make sure to set encryption key as an environment variable RAVE_ENCRYPTION_KEY"
        end
  end

  # method to return the base url
  def base_url
    return url
  end
end
