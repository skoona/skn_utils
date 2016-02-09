##
# <project.root>/lib/skn_utils/commander.rb
##
# ref: https://github.com/saturnflyer/direction
##
# Provide a feature like the Forwardable library,
# but set the return value to self.
# It provides a class level "command" method to do
# message forwarding.
#
# class SomeClass
#   extend SknUtils::Commander
#
#   command [:print_details, :setup_things] => :collaborator
#   query [:name, :id] => :collaborator, :type => :@partner
# end
#
# This will define methods on instances that forward to the
# provided receiver while enforcing encapsulation of the
# relationship between objects.
#
# the collaborator and you must agree on how results can be exchanged
# you might provide a callback method for it to set its return value on you
# :callback, develop a protocol to exchange messages with collaborator
##


module SknUtils
  module Commander

    # Forward messages and return self, protecting the encapsulation of the object
    def command(options)
      Commander.define_methods(self, options) do |command, accessor|
        %{
          def #{command}(*args, &block)
            #{accessor}.__send__(:#{command}, *args, &block)
            self
          end
        }
      end
    end

    # Forward messages and return the result of the forwarded message
    def query(options)
      Commander.define_methods(self, options) do |query, accessor|
        %{
          def #{query}(*args, &block)
            #{accessor}.__send__(:#{query}, *args, &block)
          end
        }
      end
    end

    # Commander's class method
    def self.define_methods(mod, options)
      method_defs = []
      options.each_pair do |method_names, accessor|
        Array(method_names).map do |message|
          method_defs.push yield(message, accessor)
        end
      end
      mod.class_eval method_defs.join("\n"), __FILE__, __LINE__
    end

  end # Commander
end # SknUtils
