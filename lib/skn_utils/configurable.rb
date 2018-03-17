##
# File: <gem-root>/lib/skn_utils/configurable.rb
#  Ref: https://www.toptal.com/ruby/ruby-dsl-metaprogramming-guide
#

module SknUtils

# In the end, we have got ourselves a pretty neat module for making an arbitrary
# class configurable and then specifying those configuration values using a clean
# and simple DSL that also lets us reference one configuration attribute
# from another:
#
#################
# Inside Target component
#################
# class MyApp
#   include SknUtils::Configurable.with(:app_id, :title, :cookie_name)
#   # ...
# end
#
#################
# Inside Initializer
#################
# MyApp.configure do
#   app_id "my_app"
#   title "My App"
#   cookie_name { "#{app_id}_session" }
# end
#
#################
# Usage:
#################
# MyApp.config.app_id # ==> "my_app"
#
# Here is the final version of the module that implements our DSL—a total of 36 lines of code:

  module Configurable

    def self.with(*attrs)
      not_provided = Object.new

      # Define the class/module methods
      config_class = Class.new do
        attrs.each do |attr|
          define_method attr do |value = not_provided, &block|
            if value === not_provided && block.nil?
              result = instance_variable_get("@#{attr}")
              result.is_a?(Proc) ? instance_eval(&result) : result
            else
              instance_variable_set("@#{attr}", block || value)
            end
          end
        end

        attr_writer *attrs
       end

      # Define the runtime access methods
      class_methods = Module.new do
        define_method :config do
          @config ||= config_class.new
        end

        def configure(&block)
          config.instance_eval(&block)
        end
      end

      # Apply the custom configuration
      Module.new do
        singleton_class.send :define_method, :included do |host_class|
          host_class.extend class_methods
        end
      end

    end # method

  end # end module
end # End module
