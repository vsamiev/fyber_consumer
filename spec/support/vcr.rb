require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec', 'fixtures', 'vcr_cassettes')
  config.hook_into :webmock
end

# WebMock.disable_net_connect!(allow_localhost: true)