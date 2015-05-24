require 'rails_helper'
require 'fyber_consumer'

RSpec.describe "Api" do
  describe "methods" do
    before(:each) do
      @params = Hash.new
      @params['format'] = "json"
      @params['appid'] = "157"
      @params['locale'] = "de"
      @params['os_version'] = "6.0"
      @params["timestamp"] = 1432457656
      # @params["apple_idfa"] = '2E7CE4B3-F68A-44D9-A923-F4E48D92B31E'
      @params["apple_idfa_tracking_enabled"] = false
      @params["ip"] = "109.235.143.113"
      @params["offer_types"] = "112"
      @params["ps_time"] = "1312211903"
      @params["device"] = "tablet"
      @params["device_id"] = "2b6f0cc904d137be2e1730235f5664094b83"

      @api_key = "b07a12df7d52e6c118e5d47d3f9e60135b109a1f"

      @uid = "player1"
      @pub0 = "campaign2"
      @page = "2"

      @provider = APP_CONFIG['provider_uri']
    end

    it 'gets successful response' do
      VCR.use_cassette("err_ok") do
        api = FyberConsumer::Api.new(@uid, @pub0, @page, @api_key, @params)
        response = api.request
        puts response[:body]
        expect(response[:status]).to eq "ERR_OK"
      end
    end

    it "handles 400 error code" do
      VCR.turned_off do
        stub_request(:any, /.*/).to_return(status: 400)
        api = FyberConsumer::Api.new(@uid, @pub0, @page, @api_key, @params)
        response = api.request
        expect(response[:status]).to eq "ERR_BAD_REQUEST"
      end
    end

    it "handles 401 error code" do
      VCR.turned_off do
        stub_request(:any, /.*/).to_return(status: 401)
        api = FyberConsumer::Api.new(@uid, @pub0, @page, @api_key, @params)
        response = api.request
        expect(response[:status]).to eq "ERR_UNAUTHORIZED"
      end
    end

    it "handles 404 error code" do
      VCR.turned_off do
        stub_request(:any, /.*/).to_return(status: 404)
        api = FyberConsumer::Api.new(@uid, @pub0, @page, @api_key, @params)
        response = api.request
        expect(response[:status]).to eq "ERR_NOT_FOUND"
      end
    end

    it "handles 500 error code" do
      VCR.turned_off do
        stub_request(:any, /.*/).to_return(status: 500)
        api = FyberConsumer::Api.new(@uid, @pub0, @page, @api_key, @params)
        response = api.request
        expect(response[:status]).to eq "ERR_INTERNAL_ERROR"
      end
    end

    it "handles 502 error code" do
      VCR.turned_off do
        stub_request(:any, /.*/).to_return(status: 502)
        api = FyberConsumer::Api.new(@uid, @pub0, @page, @api_key, @params)
        response = api.request
        expect(response[:status]).to eq "ERR_BAD_GATEWAY"
      end
    end

    it "fails with invalid hashkey" do
      VCR.turned_off do
        body = "original message body goes here"
        signature = Digest::SHA1.hexdigest(body + @api_key)
        body = "fake message body goes here"
        stub_request(:any, /.*/).to_return(status: 200, body: body, headers: {'X-Sponsorpay-Response-Signature' => signature})
        api = FyberConsumer::Api.new(@uid, @pub0, @page, @api_key, @params)
        response = api.request
        expect(response[:status]).to eq "ERR_FAKE_DATA"
      end
    end

  end
end
