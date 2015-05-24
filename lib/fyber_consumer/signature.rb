module FyberConsumer
  class Signature
    def initialize params, apikey
      @base_string = base_string params
      @api_key = apikey
    end

    def hashkey
      return sign_payload @base_string
    end

    def self.valid_response? payload, hashkey, api_key
      return Digest::SHA1.hexdigest(payload + api_key) == hashkey
    end

    # loop over ordered keys to prepare concatenated params string
    private
    def base_string params
      base_string = ""

      keys = params.keys
      keys.sort!
      keys.each do |key|
        unless params[key.to_s].to_s.blank?
          if base_string == ""
            base_string = key.to_s + "=" + CGI::escapeHTML(params[key.to_s].to_s).downcase
          else
            base_string = base_string + "&" + key.to_s + "=" + CGI::escapeHTML(params[key.to_s].to_s).downcase
          end
        end
      end

      return base_string
    end

    def sign_payload payload
      Digest::SHA1.hexdigest(payload + '&' + @api_key)
    end

  end
end

