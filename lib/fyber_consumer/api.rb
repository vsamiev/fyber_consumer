module FyberConsumer
  class Api
    # RestClient.log = "stdout"

    PROVIDER_URI = APP_CONFIG['provider_uri']
    ACCEPT_FORMAT = :json
    API_KEY = APP_CONFIG['api_key']

    def initialize uid, pub0 = nil, page = nil

      raise ArgumentError, 'uid not defined' if uid.nil? or uid.to_s.length == 0

      @request_params = Hash.new
      @request_params['uid'] = uid
      @request_params['pub0'] = pub0 if pub0.to_s.length > 0
      @request_params['page'] = page if page.to_s.length > 0
      @request_params = @request_params.merge(config_params)
    end

    def request
      signature = FyberConsumer::Signature.new @request_params, API_KEY
      signed_params = {'hashkey' => signature.hashkey}.merge @request_params

      response = get signed_params

      request_result = Hash.new
      status = set_status response
      if status != "ERR_FAKE_DATA"
        request_result[:status] = status
        request_result[:body] = json_data response
      else
        request_result[:status] = status
      end
      return request_result

    end

    private
    def get params
      return RestClient.get(PROVIDER_URI, {:accept => ACCEPT_FORMAT, :params => params}) { |response, request, result|
        response
      }
    end

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

    def json_data response
      begin
        return @json ||= JSON.parse(response.body)
      rescue Exception => e
        return ''
      end
    end

    protected
    def config_params
      params_hash = Hash.new
      params_hash['appid'] = APP_CONFIG["appid"]
      params_hash['locale'] = APP_CONFIG["locale"].downcase
      params_hash['os_version'] = APP_CONFIG["os_version"]
      params_hash['apple_idfa'] = APP_CONFIG["apple_idfa"].downcase
      params_hash['apple_idfa_tracking_enabled'] = APP_CONFIG["apple_idfa_tracking_enabled"].downcase
      params_hash['ip'] = APP_CONFIG["ip"]
      params_hash['offer_types'] = APP_CONFIG["offer_types"]
      params_hash["device"] = APP_CONFIG["device"].downcase
      params_hash['device_id'] = APP_CONFIG["device_id"].downcase
      params_hash["timestamp"] = Time.now.to_i

      return params_hash
    end


  end
end