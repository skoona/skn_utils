
require "skn_utils/version"
require 'psych'
require 'json'
require 'erb'
require 'date'
require 'time'
require 'concurrent'
require 'colorize'
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
  #
  def self.catch_exceptions(retries=3, pause_between=3, &block)
    retry_count ||= 1
    attempts = retries
    begin

      SknSuccess.( yield )

    rescue StandardError => error
      Kernel.puts "#{retry_count} - #{error.class.name}:#{error.message}".light_blue.italic
      if retry_count <= attempts
        retry_count+= 1
        sleep(pause_between)
        retry
      else
        SknFailure.( "RETRY ATTEMPTS FAILED - #{error.class.name}:#{error.message}" )
      end
    end
  end # end method

end
