require 'rails_helper'
require 'fyber_consumer'

RSpec.describe "Offer" do
  describe "methods" do
    before(:each) do
      @uid = "player1"
      @pub0 = "campaign2"
      @page = "2"
    end

    it "initialize api call and assigns data" do
      VCR.use_cassette("ofers") do
        Timecop.freeze(Time.local(2015, 05, 24, 17, 9, 16))
        fyber_offers = FyberConsumer::Offer.new(@uid, @pub0, @page)
        expect(fyber_offers.count).to eq fyber_offers.offers.length
      end
    end
  end
end