module SknUtils

  class JobPostJson
    def self.call(request)
      sleep rand(0..3)
      result = "#{Process.clock_gettime(Process::CLOCK_MONOTONIC)} - querying: #{request}"
      puts result
      raise "boom #{request}" if rand(10) < 1
      SknSuccess.call(result)
    rescue => exception
      SknFailure.call(request, "#{exception.message}; #{exception.backtrace[0]}")
    end
  end

end