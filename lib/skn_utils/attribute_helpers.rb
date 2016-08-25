##
# <project.root>/lib/skn_utils/attribute_helpers.rb
#
# *** See SknUtils::NestedResultBase for details ***
#
##
# This module provides
#
# to_hash Serializer:
#    person.to_hash
#      => {"name"=>"Bob"}
#
# Support <attr>? and clear_<attr>? method patterns
#  example:
#    person.name?
#      => true          true or false, like obj.name.present?
#    person.clear_name
#      => nil           sets :name to nil
#
# attr_accessor like feature for all instance variables
#   person.name
#     => "Bob"
#   person.name = "James"
#     => "James"
##



module SknUtils
  module AttributeHelpers

    # These methods normally come from ActiveSupport in Rails
    # If your not using this gem with Rails, then the :included method
    # will add these routines to the Object class
    def self.included(mod)
        unless Object.respond_to? :instance_variable_names  
          Object.class_exec {
            def instance_variable_names 
              instance_variables.map { |var| var.to_s } 
            end
            def instance_values
              Hash[instance_variables.map { |name| [name[1..-1], instance_variable_get(name)] }]
            end
          }
        end
    end

    # return a hash of all attributes and their current values
    # including nested arrays of hashes/objects
    def attributes(filter_internal=true)
      instance_variable_names.each_with_object({}) do |attr,collector|
        next if ['skn_enable_serialization', 'skn_enabled_depth'].include?(attr.to_s[1..-1]) and filter_internal  # skip control keys
        value = instance_variable_get(attr)

        if value.kind_of?(Array) and value.first.respond_to?(:attribute_helper_object)
          value = value.map {|ov| ov.respond_to?(:attribute_helper_object) ? ov.attributes : ov }
        elsif value.respond_to?(:attribute_helper_object)
          value = value.attributes
        end
        collector[attr.to_s[1..-1].to_sym] = value
      end
    end

    def to_hash(exclude_internal_vars=false)
      attributes(!exclude_internal_vars)
    end
    alias_method :to_h, :to_hash

    # An alternative mechanism for property access.
    # Hash notation
    def [](attr)
      send("#{attr}")
    end

    # Hash notation
    def []=(attr, value)
      send("#{attr}=", value)
    end

    ##
    #  DO NOT ADD METHODS BELOW THIS LINE, unless you want them to be private
    ##

    # Support the regular respond_to? method by 
    # answering for any attr that method missing actually handle
    #:nodoc:
    def respond_to_missing?(method, incl_private=false)
       instance_variable_names.include?("@#{method.to_s}") || super(method,incl_private)
    end
    
    private

    # Deals with the true existance of an attribute and then its non-blank or empty value
    # - attribute must exist and have a non-blank value to cause this method to return true
    #:nodoc:    
    def attribute?(attr)
      return false unless  instance_variable_names.include?("@#{attr.to_s}")
      if attr.is_a? Symbol        
       ![ "", " ", nil, [],[""], [" "], {} ].include?( send(attr) )
      else
        ![ "", " ", nil, [],[""], [" "], {} ].include?( send(attr.to_sym) )
      end
    end

    #:nodoc:
    def clear_attribute(attr)
      if attr.is_a? Symbol
        instance_variable_set("@#{attr.to_s}", nil)
      else
        instance_variable_set("@#{attr}", nil)
      end
    end

    # Determines operable Options in effect for this instance
    # see NestedResultBase
    #:nodoc:
    def serial_required?
      respond_to? :serialization_required? and serialization_required?
    end
    # see NestedResultBase
    #:nodoc:
    def multi_required?
      respond_to? :depth_level and depth_level != :single 
    end
    # see NestedResultBase
    #:nodoc:
    def multi_with_arrays_required?
      respond_to? :depth_level and depth_level == :multi_with_arrays 
    end

    ##
    # Adds the attr?() method pattern.  all attributes will respond to attr?: example - obj.name? with true or false
    # Adds the clear_attr() method pattern.  all attributes will respond to clear_attr(): example - obj.clear_name sets :name to nil
    # Handles getter for any instance_variable currently defined
    # Handles setter for any instance_variable currently defined
    # Sets new instance_variable for any undefined variable with non-hash value
    # Sets instance_variable value to Bean object for any undefined variable with hash value param
    #
    # Using any form of singleton_class() will break the generic bean, which requires Serialization.
    # However not adding attr_accessors may impact performance, as method_missing must fill-in for read/writes
    ##
    #:nodoc:
    def method_missing(method, *args, &block)
      # puts("method_missing/method/class/*args=#{method}/#{method.class.name}/#{args}")
      if method.to_s.start_with?('clear_') and instance_variable_defined?("@#{method.to_s[6..-1]}")
        clear_attribute(method.to_s[6..-1].to_sym)
      elsif method.to_s.end_with?('?')
        if instance_variable_defined?("@#{method.to_s[0..-2]}")
          attribute?(method.to_s[0..-2].to_sym)
        else
          false
        end
      elsif method.to_s.end_with?("=")              # add new attribute or whole object
        if args.first.is_a?(Hash) 
          singleton_class.send(:attr_accessor, method.to_s[0..-2]) unless serial_required?
          if multi_required?
            instance_variable_set "@#{method.to_s[0..-2]}", self.class.new(*args)
          else
            instance_variable_set "@#{method.to_s[0..-2]}", *args
          end
        elsif args.first.is_a?(Array) and args.flatten.first.kind_of?(Hash)
          singleton_class.send(:attr_accessor, method.to_s[0..-2]) unless serial_required?
          if multi_with_arrays_required?
            instance_variable_set("@#{method.to_s[0..-2]}", 
                (args.first.map {|nobj| nobj.kind_of?(Hash) ? self.class.new(nobj) : nobj }) 
            )
          else
            instance_variable_set "@#{method.to_s[0..-2]}", *args
          end
        elsif !args.empty?
          singleton_class.send(:attr_accessor, method.to_s[0..-2]) unless serial_required?
          instance_variable_set "@#{method.to_s[0..-2]}", *args
        else
          super(method, *args, &block)      # throw excpt for not found or could return false
        end
      elsif instance_variable_defined? "@#{method.to_s}"
        instance_variable_get "@#{method.to_s}"
      else
        super(method, *args, &block)
      end
    rescue
       # puts $!.message + $!.backtrace.join("\n")
      super(method, *args, &block)
    end
    # end of private section

  end # end module
end # end module
