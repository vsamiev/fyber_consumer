module FyberConsumer
  class Api
    # RestClient.log = "stdout"

    PROVIDER_URI = APP_CONFIG['provider_uri']
    ACCEPT_FORMAT = :json

    def initialize uid, pub0 = nil, page = nil , api_key, params
      # raise ArgumentError, 'Argument is not numeric' if uid.nil? or
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
      case response.code
        when 200
          request_result[:status] = "ERR_OK"
          request_result[:body] = response.body
        when 400
          request_result[:status] = "ERR_BAD_REQUEST"
        when 401
          request_result[:status] = "ERR_UNAUTHORIZED"
        when 404
          request_result[:status] = "ERR_NOT_FOUND"
        when 500
          request_result[:status] = "ERR_INTERNAL_ERROR"
        when 502
          request_result[:status] = "ERR_BAD_GATEWAY"
        else
          request_result[:status] = "ERR_UNKNOWN"
      end
      request_result
    end

    private
    def get params
      return RestClient.get PROVIDER_URI, {:accept => ACCEPT_FORMAT, :params => params}
    end
  end
end