##
# File: <gem-root>/lib/skn_utils/exploring/configuration.rb
#
# Engines and Gem sometimes need a configuration object, this is an example
# Options class, consider OpenStruct2 or ActiveSupport::OrderedOptions as alternatives

module SknUtils
  module Exploring
    module Configuration

      module_function

      def option_defaults
        @option_defaults ||= {one: 1, two: 2, three: 3}
      end
      def option_defaults=(parms)
        @option_defaults = parms
      end

      def reset!
        @configuration = Options.new(option_defaults)
        true
      end

      def config
        configure
      end

      def configure         # Initialize with both the configuration keys and default values
        @configuration || reset!
        yield(@configuration) if block_given?
        @configuration
      end

      private

      class Options
        def initialize(parms={})
          parms.each_pair do |k,v|
            self.singleton_class.send(:attr_accessor, k)
            instance_variable_set("@#{k}",v)
          end
        end
      end

    end
    # require your Gem or Engine here

  end
end

# In config/initializers/gem_config.rb
# SknUtils::Exploring::Configuration.class_variable_set(:option_defaults, {one: 1, two: 2, three: 3})