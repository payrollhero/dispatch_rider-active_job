require 'active_job'
module DispatchRider
  module ActiveJob
    module Handler
      class Base < ::ActiveJob::Base
        include DispatchRider::Handlers::NamedProcess
        extend DispatchRider::Handlers::InheritanceTracking
        include DispatchRider::Handlers::Core

        def process(job_info)
          active_job_info = {
            "job_id" => job_info['guid'],
            "job_class" => self.class.to_s,
            "arguments" => job_info['arguments'],
          }
          ::ActiveJob::Base.execute active_job_info
        end
      end
    end
  end
end
