# frozen_string_literal: true

#
#
# Ruby Notify like class
#
# Ref: https://ozone.wordpress.com/category/programming/metaprogramming/
##
# Listeners implement:
#
#  def attribute_changed(attr, old, new)
#    ...
#  end
#
#
module SknUtils
  class NotifierBase

    def initialize
      @listeners = []
    end

    def register_listener(listener)
      @listeners.push(listener) unless @listeners.include?(listener)
    end

    def unregister_listener(listener)
      @listeners.delete(listener)
    end

    # create writer-with-notify and reader
    def self.attribute(*attrs)
      attrs.each do |attr|
        instance_variable_set("@#{attr}", nil)
        define_method(attr) do
          instance_variable_get("@#{attr}")
        end
        define_method("#{attr}=") do |value|
          old_value = instance_variable_get("@#{attr}")
          unless (value == old_value)
            instance_variable_set("@#{attr}", value)
            @listeners.each do |listener|
              listener.attribute_changed(attr, old_value, value)
            end
          end
        end
      end # loop on attrs
    end # end of attribute method

  end # end of NotifierBase class
end

