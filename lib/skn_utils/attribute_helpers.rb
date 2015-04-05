##
# <Rails.root>/lib/skn_utils/attribute_helpers.rb
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

    # return a hash of all attributes and their current values
    # including nested arrays of hashes/objects
    def attributes
      instance_variable_names.each_with_object({}) do |attr,collector|
        next if ['skn_enable_serialization', 'skn_enabled_depth'].include?(attr.to_s[1..-1])   # skip control keys
        value = instance_variable_get(attr)
        next if value.is_a?(ActiveModel::Errors)

        if value.kind_of?(Array) and value.first.respond_to?(:attribute_helper_object)
          value = value.map {|ov| ov.respond_to?(:attribute_helper_object) ? ov.attributes : ov }
        elsif value.respond_to?(:attribute_helper_object)
          value = value.attributes
        end
        collector[attr.to_s[1..-1].to_sym] = value
      end
    end

    def to_hash
      attributes
    end

    # An alternative mechanism for property access.
    # This let's you do foo['bar'] along with foo.bar.
    def [](attr)
      send("#{attr}")
    end

    def []=(attr, value)
      send("#{attr}=", value)
    end

    # determines if this is one of our objects
    def attribute_helper_object
      true
    end

    ##
    #  DO NOT ADD METHODS BELOW THIS LINE, unless you want them to be private
    ##
    private

    def attribute?(attr)
      if attr.is_a? Symbol
        send(attr).present?
      else
        send(attr.to_sym).present?
      end
    end

    def clear_attribute(attr)
      if attr.is_a? Symbol
        instance_variable_set("@#{attr.to_s}", nil)
      else
        instance_variable_set("@#{attr}", nil)
      end
    end

    # Determines operable Options in effect for this instance
    # see NestedResultBase
    def serial_required?
      respond_to? :serialization_required? and serialization_required?
    end
    # see NestedResultBase
    def multi_required?
      respond_to? :depth_level and depth_level != :single 
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
    def method_missing(method, *args, &block)
      #puts "method_missing/method/type=#{method}/#{method.class.name}"
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
        elsif args.size > 0
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
