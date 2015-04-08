require 'spec_helper'
require 'dispatch_rider/active_job'
require 'dispatch-rider'

describe DispatchRider::ActiveJob do

  before do
    DispatchRider::Publisher.configure({
                                         notification_services: {
                                           file_system: {}
                                         },
                                         destinations: {
                                           sample_queue: {
                                             service: :file_system,
                                             channel: :sample_queue,
                                             options: {
                                               path: "test/channel",
                                             }
                                           }
                                         }
                                       })
    DispatchRider.configure do |config|

    end
    ActiveJob::Base.queue_adapter = :dispatch_rider
    DispatchRider.config.logger = Logger.new(STDERR)
    DispatchRider.config.logger.level = 99
    DispatchRider.config.queue_kind = :file_system
    DispatchRider.config.queue_info = {
      path: 'test/channel'
    }
  end

  example do
    DispatchRider::QueueServices::FileSystem
    work_off_dispatch_jobs do
      SampleJob.perform_later "foo", "bar"
    end
  end

end
