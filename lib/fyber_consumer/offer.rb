module FyberConsumer
  class Offer

    attr_accessor :code, :message, :count, :pages

    def initialize uid, pub0 = nil, page = nil
      fyber_api = FyberConsumer::Api.new(uid, pub0, page)
      response = fyber_api.request

      self.code = response[:body]["code"]
      self.message = response[:body]["message"]
      self.count = response[:body]["count"]
      self.pages = response[:body]["pages"]

      if response[:status] == "ERR_OK"
        @offers = response[:body]["offers"]
        @information = response[:body]["information"]
      end

    end

    def information
      @information
    end

    def offers
      @offers
    end
  end
end
