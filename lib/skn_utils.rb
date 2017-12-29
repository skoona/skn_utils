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
    require 'nokogiri'
  rescue LoadError => e
    puts e.message
  end
end
require 'skn_utils/env_string_handler'
require 'skn_utils/nested_result'
require 'skn_utils/result_bean'
require 'skn_utils/page_controls'
require 'skn_utils/null_object'
require 'skn_utils/notifier_base'
require 'skn_utils/skn_configuration'
require 'skn_utils/configurable'
require 'skn_utils/lists/linked_commons'
require 'skn_utils/lists/link_node'
require 'skn_utils/lists/linked_list'
require 'skn_utils/lists/doubly_linked_list'
require 'skn_utils/lists/circular_linked_list'
# require 'skn_utils/business_services/year_month'
# require 'skn_utils/exploring/commander'
# require 'skn_utils/exploring/action_service'
# require 'skn_utils/exploring/configuration'

if defined?(::Nokogiri)
  begin
    require 'skn_utils/converters/hash_to_xml'
  rescue LoadError, StandardError
    puts 'NotFound -> Converters::HashToXml class depends on Gem:NokoGiri which is not installed at this time.'
  end
end

require 'skn_hash'
require 'skn_settings'

module SknUtils

end
