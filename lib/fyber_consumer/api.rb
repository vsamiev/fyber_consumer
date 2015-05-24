module FyberConsumer
  class Api
    # RestClient.log = "stdout"

    PROVIDER_URI = APP_CONFIG['provider_uri']
    ACCEPT_FORMAT = :json

    def initialize uid, pub0 = nil, page = nil, api_key, params
      raise ArgumentError, 'uid not defined' if uid.nil? or uid.to_s.length == 0

      @api_key=api_key

      @request_params = Hash.new
      @request_params['uid'] = uid if uid.to_s.length > 0
      @request_params['pub0'] = pub0 if pub0.to_s.length > 0
      @request_params['page'] = page if page.to_s.length > 0
      @request_params = @request_params.merge params
    end

    def request
      signature = FyberConsumer::Signature.new @request_params, @api_key

      signed_params = {'hashkey' => signature.hashkey}.merge @request_params

      response = get signed_params

      request_result = Hash.new
      request_result[:status] = set_status response
      request_result[:body] = json_data response

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
          if FyberConsumer::Signature.valid_response? response.body, response.headers[:x_sponsorpay_response_signature], @api_key
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
  end
end