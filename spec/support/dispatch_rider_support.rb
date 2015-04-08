# these are a bunch of helpers for rspec to be able to have more control
# testing integrations that use dispatch rider
module DispatchRiderSupport

  # Clears the job queue and runs any jobs at the end of its block.
  # Skipping any jobs specified in the except param.
  #
  # Example:
  # ```
  #   it "works" do
  #     visit "/foo"
  #     click "bar"
  #     work_off_dispatch_jobs(except: [:useless_job]) do
  #       click "do stuff"
  #     end
  #   end
  # ```
  #
  # @param [Array<Symbol>] except -- names of handlers to skip. eg: :do_foo_stuff
  def work_off_dispatch_jobs(except: [])
    clear_pending_dispatch_jobs
    yield
    run_pending_dispatch_jobs(except: except)
  end

  private

  def create_subscriber
    kind = DispatchRider.config.queue_kind
    info = DispatchRider.config.queue_info

    subscriber = DispatchRider.config.subscriber.new

    DispatchRider.config.handlers.each do |handler_name|
      subscriber.register_handler(handler_name)
    end

    subscriber.register_queue(kind, info)
    subscriber.setup_demultiplexer(kind, ->(error) { raise error })

    subscriber
  end

  def message_info_fragment(message)
    "(#{message.guid}): #{message.subject} : #{message_info_arguments(message).inspect}"
  end

  def message_info_arguments(message)
    message.body.dup.tap { |m|
      m.delete('guid')
    }
  end

  def run_pending_dispatch_jobs(except: [])
    except.map!(&:to_s)
    subscriber = create_subscriber
    queue = subscriber.demultiplexer.queue
    dispatcher = subscriber.demultiplexer.dispatcher
    until queue_empty?(queue)
      queue.pop do |message|
        if except.include?(message.subject)
          logger.debug "Skipping: #{message_info_fragment(message)}"
          true
        else
          begin
            logger.info "Starting execution of: #{message_info_fragment(message)}"
            dispatcher.dispatch(message)
            true
          rescue RuntimeError => e
            logger.error "Failed execution of: #{message_info_fragment(message)}"
            logger.error e.inspect
            raise e
          ensure
            logger.info "Completed execution of: #{message_info_fragment(message)}"
          end
        end
      end
    end
  end

  # Needed to give the filesystem a chance to find messages created by other dispatch rider messages
  def queue_empty?(queue)
    if queue.empty?
      true
      # sleep(0.1)
      # queue.empty?
    end
  end

  def clear_pending_dispatch_jobs
    dispatch_job_paths.each do |path|
      path = File.expand_path(path)
      Dir["#{path}/*"].each do |file|
        File.unlink(file)
      end if File.exist?(path)
    end
  end

  def logger
    DispatchRider.config.logger
  end

  def dispatch_job_paths
    DispatchRider::Publisher.config.destinations.map(&:options).map { |x| x["path"] }.uniq
  end
end
