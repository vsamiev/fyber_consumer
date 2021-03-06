require "fyber_consumer/version"

module FyberConsumer
  require 'fyber_consumer/signature'
  require 'fyber_consumer/api'
  require 'fyber_consumer/offer'


  class << self
    attr_accessor :configuration

  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :format, :appid, :uid, :locale, :os_version, :timestamp, :apple_idfa,
                  :apple_idfa_tracking_enabled, :ip, :pub0, :page, :offer_types, :ps_time, :device, :device_id

  end
end
