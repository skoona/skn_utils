# frozen_string_literal: true
# ##
#
#
# See JobCommands, HttpProcessor, ...
# See ./bin/par_test_[block|grouped|wrapped] examples
#

module SknUtils

  class SyncWorker
    def initialize(&blk)
      @blk = blk
    end

    def call
      @blk.call
    rescue => ex
      failures = ex.backtrace.map {|x| x.split("/").last }.join(",")
      SknFailure.(ex.class.name, { cause: ex.message, backtrace: failures})
    end
  end

  class AsyncWorker
    def initialize(&blk)
      @blk = Concurrent::Promise.execute(&blk)
    end

    def call
      @blk.value
    rescue => ex
      failures = ex.backtrace.map {|x| x.split("/").last }.join(",")
      SknFailure.(ex.class.name, { cause: ex.message, backtrace: failures})
    end
  end

  class Result
    def initialize(merged)
      @merged = merged
    end

    def success?
      @merged.all?(&:success) rescue false
    end

    def messages
      @merged.map(&:message)&.compact rescue []
    end

    def values
      @merged
    end
  end

  class CallableWrapperJob
    def self.call(callable, command)
      callable.call(command)
    rescue => ex
      failures = ex.backtrace.map {|x| x.split("/").last }.join(",")
      SknFailure.(ex.class.name, { cause: ex.message, backtrace: failures})
    end
  end
  class JobWrapper
    def self.call(command, callable)
      callable.call(command)
    rescue => ex
      failures = ex.backtrace.map {|x| x.split("/").last }.join(",")
      SknFailure.(ex.class.name, { cause: ex.message, backtrace: failures})
    end
  end

  class ConcurrentJobs
    attr_reader :elapsed_time_string

    def self.call(async: true)
      worker = async ? AsyncWorker : SyncWorker
      new(worker: worker)
    end

    def initialize(worker:)
      @worker  = worker
      @workers = []
    end

    # commands: array of command objects related to callable
    # callable: callable class or proc, ex:SknUtils::HttpProcessor
    # callable must return SknSuccess || SknFailure
    def register_jobs(commands, callable)
      commands.each do |command|
        register_job do
          JobWrapper.call(command,callable)
        end
      end
    end

    def register_job(&blk)
      @workers << @worker.new(&blk)
    end

    def render_jobs
      stime = SknUtils.duration
      merged = @workers.each_with_object([]) do |worker, acc|
        begin
          res = worker.call
          acc.push( res.nil? ? SknFailure.("Unknown", {cause: "Nil Return Value to render Jobs", backtrace: []}) : res )
        rescue => ex
          failures = ex.backtrace.map {|x| x.split("/").last }.join(",")
          acc.push SknFailure.(ex.class.name, { cause: ex.message, backtrace: failures})
        end
      end
      @elapsed_time_string = SknUtils.duration(stime)
      Result.new(merged)
    rescue => e
      Result.new(merged || [])
    end
  end
end
