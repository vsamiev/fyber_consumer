module FyberConsumer
  class Offer

    # Offer class calls provider by Api class
    # Prepare data come from Api class
    # Provide attributes for use

    attr_accessor :http_code, :code, :message, :count, :pages, :status, :offers, :information

    def initialize uid, pub0 = nil, page = nil
      fyber_api = FyberConsumer::Api.new(uid, pub0, page)
      response = fyber_api.request

      self.status = response[:status]

      self.http_code = response[:body]["http_code"]
      self.http_code = response[:body][":http_code"] if response[:body][":http_code"]
      self.code = response[:body]["code"]
      self.code = response[:body][":code"] if response[:body][":code"]
      self.message = response[:body]["message"]
      self.message = response[:body][":message"] if response[:body][":message"]
      self.count = response[:body]["count"]
      self.pages = response[:body]["pages"]

      # Assign data and information if we have valid HTTP response
      if response[:status] == "ERR_OK"
        self.offers = response[:body]["offers"]
        self.information = response[:body]["information"]
      end

    end

  end
end
