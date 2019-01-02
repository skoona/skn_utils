# frozen_string_literal: true

##
# File: <gem-root>/lib/skn_utils/configurable.rb
#  Ref: https://www.toptal.com/ruby/ruby-dsl-metaprogramming-guide
#

module SknUtils
  # For making an arbitrary class configurable and then specifying those configuration values using a clean
  # and simple DSL that also lets us reference one configuration attribute from another
  #
  #################
  # Inside Target component
  #################
  # class MyApp
  #   include SknUtils::Configurable.with(:app_id, :title, :cookie_name) # or {root_enable: false})
  #   # ... default=true for root|env|logger
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
  # -or- During Definition
  #################
  # class MyApp
  #   include SknUtils::Configurable.with(:app_id, :title, :cookie_name, {root_enable: true})
  #   # ...
  #   configure do
  #     app_id "my_app"
  #     title "My App"
  #     cookie_name { "#{app_id}_session" }
  #   end
  #
  #   # these are the root_enable default settings
  #   self.logger = Logger.new
  #   self.env    = ENV.fetch('RACK_ENV', 'development')
  #   self.root   = Dir.pwd
  # end
  #
  #################
  # Usage:
  #################
  # MyApp.config.app_id # ==> "my_app"
  # MyApp.logger        # ==> <Logger.class>
  # MyApp.env.test?     # ==> true
  #
  # ###############
  # Syntax
  # ###############
  # Main Class Attrs
  # - root     =  application rood directory as Pathname
  # - env      =  string value from RACK_ENV
  # - registry =  SknRegistry instance
  # - logger   =  Assigned Logger instance
  # #with(*user_attrs, enable_root: true|false) - defaults to enable of Main Class Attrs
  # ##
  # User-Defined Attrs
  # MyThing.with(:name1, :name2, ...)
  #
  # ##

  module Configurable

    def self.with(*config_attrs, **root_options)
      _not_provided = Object.new
      _root_options = root_options.empty? || root_options.values.any?{|v| v == true}

      # Define the config class/module methods
      config_class = Class.new do
        # add hash notation
        define_method :[] do |attr|
          instance_variable_get("@#{attr}")
        end
        define_method :[]= do |attr, val|
          instance_variable_set("@#{attr}", val)
        end

        config_attrs.each do |attr|
          define_method attr do |value = _not_provided, &block|
            if value === _not_provided && block.nil?
              result = instance_variable_get("@#{attr}")
              result.is_a?(Proc) ? instance_eval(&result) : result
            else
              instance_variable_set("@#{attr}", block || value)
            end
          end
        end

        attr_writer *config_attrs
      end

      # Define the runtime access methods
      class_methods = Module.new do
        define_method :config do
          @__config ||= config_class.new
        end
        def configure(&block)
          config.instance_eval(&block)
        end
        if _root_options
          # Enable Rails<Like>.env and Rails.logger like feature:
          # - MyClass.env.production? or MyClass.logger or MyClass.root
          def registry
            @__registry ||= ::SknRegistry.new
          end
          def registry=(obj_instance)
            @__registry = obj_instance
          end
          def env
            @__env ||= ::SknUtils::EnvStringHandler.new( ENV.fetch('RACK_ENV', 'development') )
          end
          def env=(str)
            @__env = ::SknUtils::EnvStringHandler.new( str || ENV.fetch('RACK_ENV', 'development') )
          end
          def root
            @__root ||= ::SknUtils::EnvStringHandler.new( Dir.pwd )
          end
          def root=(path)
            @__root = ::SknUtils::EnvStringHandler.new( path || Dir.pwd )
          end
          def logger
            @__logger ||= 'No Logger Assigned.'
          end
          def logger=(obj)
            @__logger = obj
          end
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

#
# def [](key)
#   @internal_var[key]
# end
#
# def []=(key, value)
#   @internal_var[key] = value
# end
