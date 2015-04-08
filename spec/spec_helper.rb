require 'rspec'
require 'dispatch_rider/active_job'

require_relative 'support/sample_job'
require_relative 'support/dispatch_rider_support'

RSpec.configure do |config|
  config.include DispatchRiderSupport
end
