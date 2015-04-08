module ActiveJob
  module QueueAdapters
    class DispatchRiderAdapter
      class << self
        def enqueue(job)
          job_data = job.serialize
          destinations = [ job.queue_name ]
          message = {
            subject: job_data['job_class'].underscore,
            body: {
              guid: job_data['job_id'],
              arguments: job_data['arguments']
            },
          }
          DispatchRider::Publisher.new.publish(destinations: destinations, message: message)
        end

        def enqueue_at(job, timestamp)
          # unless Resque.respond_to?(:enqueue_at_with_queue)
          #   raise NotImplementedError, "To be able to schedule jobs with Resque you need the " \
          #     "resque-scheduler gem. Please add it to your Gemfile and run bundle install"
          # end
          # Resque.enqueue_at_with_queue job.queue_name, timestamp, JobWrapper, job.serialize
        end
      end
    end
  end
end
