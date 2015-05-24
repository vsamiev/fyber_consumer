require 'rails_helper'
require 'fyber_consumer'

RSpec.describe "Signature" do
  describe "methods" do
    before(:each) do
      @params = Hash.new
      @params['format'] = "json"
      @params['appid'] = "157"
      @params['locale'] = "de"
      @params['os_version'] = "6.0"
      @params["timestamp"] = Time.now.to_i.to_s
      # @params["apple_idfa"] = '2E7CE4B3-F68A-44D9-A923-F4E48D92B31E'
      @params["apple_idfa_tracking_enabled"] = false
      @params["ip"] = "109.235.143.113"
      @params["offer_types"] = "112"
      @params["ps_time"] = "1312211903"
      @params["device"] = "tablet"
      @params["device_id"] = "2b6f0cc904d137be2e1730235f5664094b83"
      @api_key = "b07a12df7d52e6c118e5d47d3f9e60135b109a1f"

      @uid   =  "player1"
      @pub0  =  "campaign2"
      @page  =  "2"
    end

    it 'gets successful response' do
      api = FyberConsumer::Api.new(@uid, @pub0, @page, @api_key, @params)
      response = api.request
      expect(response[:status]).to eq "ERR_OK"
    end

  end
end
