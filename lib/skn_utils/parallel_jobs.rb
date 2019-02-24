# frozen_string_literal: true
# ##
#
#
# Requires JobPostJson, ...
#

module SknUtils

  class SyncWorker
    def initialize(&blk)
      @blk = blk
    end

    def call
      @blk.call
    end
  end

  class AsyncWorker
    def initialize(&blk)
      @blk = Concurrent::Promise.execute(&blk)
    end

    def call
      @blk.value
    end
  end

  class Result
    def initialize(merged)
      @merged = merged
    end

    def success?
      @merged.compact.all?(&:success)
    end

    def errors
      @merged.map(&:message)&.compact || []
    end

    def values
      @merged
    end
  end

  class ParallelJobs

    def self.call(async: true)
      worker = async ? AsyncWorker : SyncWorker
      new(worker: worker)
    end

    def initialize(worker:)
      @worker  = worker
      @workers = []
    end

    # commands=[data-objs], callable=SknUtils::HttpProcessor
    def register_jobs(commands, callable)
      commands.each do |command|
        register_job do
          callable.call(command)
        end
      end
    end

    def register_job(&blk)
      @workers << @worker.new(&blk)
    end

    def render_jobs
      stime = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      merged = @workers.each_with_object([]) do |worker, acc|
        acc.push( worker.call )
      end
      puts "Duration: #{'%.3f' % (Process.clock_gettime(Process::CLOCK_MONOTONIC) - stime)} seconds"
      Result.new(merged)
    rescue => e
      puts e
      Result.new([])
    end
  end
end
