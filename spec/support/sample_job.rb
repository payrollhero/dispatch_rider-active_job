class SampleJob < DispatchRider::ActiveJob::Handler::Base

  queue_as :sample_queue

  def perform(*args)
    p args
  end

end
