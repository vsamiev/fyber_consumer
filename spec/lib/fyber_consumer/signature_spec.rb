require 'rails_helper'
require 'fyber_consumer'

RSpec.describe "Signature" do
  describe "methods" do

    before(:each) do
      @params = Hash.new
      @params['appid'] = "157"
      @params["uid"] = "player1"
      @params["ip"] = "212.45.111.17"
      @params["locale"] = "de"
      @params["device_id"] = "2b6f0cc904d137be2e1730235f5664094b831186"
      @params["ps_time"] = "1312211903"
      @params["pub0"] = "campaign2"
      @params["page"] = "2"
      @params["timestamp"] = "1312553361"
      @api_key = "e95a21621a1865bcbae3bee89c4d4f84"
    end

    it "generates calid haskey" do
      signature =  FyberConsumer::Signature.new(@params, @api_key)
      expect(signature.hashkey).to eq "7a2b1604c03d46eec1ecd4a686787b75dd693c4d"
    end

  end
end