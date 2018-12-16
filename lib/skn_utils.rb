
require "skn_utils/version"
require 'psych'
require 'json'
require 'erb'
require 'date'
require 'time'
require 'concurrent'
unless defined?(Rails)
  begin
    require 'deep_merge'
  rescue LoadError => e
    puts e.message
  end
end
require 'skn_utils/core_extensions'
require 'skn_utils/env_string_handler'
require 'skn_utils/nested_result'
require 'skn_utils/dotted_hash'
require 'skn_utils/result_bean'
require 'skn_utils/page_controls'
require 'skn_success'
require 'skn_failure'
require 'skn_utils/null_object'
require 'skn_utils/notifier_base'
require 'skn_utils/configuration'
require 'skn_utils/configurable'

require 'skn_hash'
require 'skn_registry'
require 'skn_container'
require 'skn_settings'



module SknUtils

  # Random Utils
  # Retries block up to :retries times with a :pause_between, and returns Success/Failure object
  # -- return SknSuccess | SknFailure response object
  #
  def self.catch_exceptions(retries=3, pause_between=3, &block)
    retry_count ||= 1
    attempts = retries
    begin

      res = yield
      [SknFailure, SknFailure].any? {|o| res.kind_of?(o) } ? res : SknSuccess.( res )

    rescue StandardError, ScriptError => error
      puts "#{retry_count} - #{error.class.name}:#{error.message}"
      if retry_count <= attempts
        retry_count+= 1
        sleep(pause_between)
        retry
      else
        SknFailure.( "RETRY ATTEMPTS FAILED - #{error.class.name}:#{error.message}", error.backtrace[0..5].to_s )
      end
    end
  end # end method


  # ##
  # SknUtils.as_human_size(12345) #=> 12 KB
  #
  def self.as_human_size(number)
    units = %W(Bytes KB MB GB TB PB EB)
    num = number.to_f
    if number < 1001
      num = number
      exp = 0
    else
      max_exp  = units.size - 1
      exp = ( Math.log( num ) / Math.log( 1024 ) ).round
      exp = max_exp  if exp > max_exp
      num /= 1024 ** exp
    end
    ((num > 9 || num.modulo(1) < 0.1) ? '%d %s' : '%.1f %s') % [num, units[exp]]
  end

  # call without to get start time
  # call with start_time to get duration string
  def self.duration(start_time=nil)
    start_time.nil? ? Process.clock_gettime(Process::CLOCK_MONOTONIC) :
        "%3.3f seconds" % (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time)
  end

end
