module FyberConsumer
  class Api
    # Api class make requests to provider
    # We do not care about data inside body it is work of Offer class
    # Only care about calls, http statuses and security

    # Config constants

    PROVIDER_URI = 'http://api.sponsorpay.com/feed/v1/offers.json'
    ACCEPT_FORMAT = :json
    API_KEY = Rails.application.secrets.fyber_api_key

    def initialize uid, pub0 = nil, page = nil

      # uid is mandatory
      raise ArgumentError, 'uid not defined' if uid.nil? or uid.to_s.length == 0

      # set input params
      @request_params = Hash.new
      @request_params['uid'] = uid
      @request_params['pub0'] = pub0 if pub0.to_s.length > 0
      @request_params['page'] = page if page.to_s.length > 0

      # merge with config params
      @request_params = @request_params.merge(config_params)
    end

    def request

      # prepare hashkey
      signature = FyberConsumer::Signature.new @request_params, API_KEY
      signed_params = {'hashkey' => signature.hashkey}.merge @request_params

      # get response
      response = get signed_params

      # prepare result for offer class
      request_result = Hash.new

      # check for valid hashkey
      status = set_status response
      if status != "ERR_FAKE_DATA"

        # if not fake assign data for offer class
        request_result[:status] = status
        request_result[:body] = json_data response
      else

        # otherwise only status of fake
        request_result[:status] = status
      end

      return request_result
    end

    # call api provider with params, if error occurred also return response also for processing
    private
    def get params
      return RestClient.get(PROVIDER_URI, {:accept => ACCEPT_FORMAT, :params => params}) { |response, request, result|
        response
      }
    end

    # checking response codes
    def set_status response
      case response.code
        when 200
          if FyberConsumer::Signature.valid_response? response.body, response.headers[:x_sponsorpay_response_signature], API_KEY
            "ERR_OK"
          else
            "ERR_FAKE_DATA"
          end
        when 400
          "ERR_BAD_REQUEST"
        when 401
          "ERR_UNAUTHORIZED"
        when 404
          "ERR_NOT_FOUND"
        when 500
          "ERR_INTERNAL_ERROR"
        when 502
          "ERR_BAD_GATEWAY"
        else
          "ERR_UNKNOWN"
      end
    end

    # json helper
    def json_data response
      begin
        return @json ||= JSON.parse(response.body)
      rescue Exception => e
        return ''
      end
    end

    # config assignment, downcase all strings for valid hashkeys
    protected
    def config_params
      params_hash = Hash.new
      params_hash['appid'] = Rails.application.secrets.fyber_appid
      params_hash['locale'] = Rails.application.secrets.fyber_locale
      params_hash['os_version'] = Rails.application.secrets.fyber_os_version
      params_hash['apple_idfa_tracking_enabled'] = Rails.application.secrets.fyber_apple_idfa_tracking_enabled
      params_hash['ip'] = Rails.application.secrets.fyber_ip
      params_hash['offer_types'] = Rails.application.secrets.fyber_offer_types
      params_hash["device"] = Rails.application.secrets.fyber_device
      params_hash['device_id'] = Rails.application.secrets.fyber_device_id
      params_hash["timestamp"] = Time.now.to_i

      return params_hash
    end


  end
end