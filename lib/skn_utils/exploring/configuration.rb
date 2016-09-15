module SknUtils
  module Exploring
    module Configuration

      module_function
      def configure         # Initialize with both the configuration keys and default values
        @@configuration ||= Options.new({one: 1, two: 2, three: 3})
        yield(@@configuration) if block_given?
        @@configuration
      end

      def config
        configure
      end

      private
      @@configuration = nil

      class Options
        def initialize(parms={})
          parms.each_pair do |k,v|
            singleton_class.send(:attr_accessor, k)
            instance_variable_set("@#{k}",v)
          end
        end
      end

    end
    # require your Gem or Engine here

  end
end
