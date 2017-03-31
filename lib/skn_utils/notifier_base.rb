#
#
# Ruby Notify like class
#
# Ref: https://ozone.wordpress.com/category/programming/metaprogramming/


class NotifierBase

  def initialize
    @listeners = []
  end

  def register_listener(l)
    @listeners.push(l) unless @listeners.include?(l)
  end

  def unregister_listener(l)
    @listeners.delete(l)
  end

  def self.attribute(*properties)
    properties.each do |prop|
      define_method(prop) {
        instance_variable_get("@#{prop}")
      }
      define_method("#{prop}=") do |value|
        old_value = instance_variable_get("@#{prop}")
        return if (value == old_value)
        @listeners.each { |listener|
          listener.attribute_changed(prop, old_value, value)
        }
        instance_variable_set("@#{prop}", value)
      end
    end # loop on properties
  end # end of attribute method

end # end of NotifierBase class


# Create a bean from that base
class TestBean < NotifierBase
  attribute :name, :firstname
end

class LoggingPropertyChangeListener
  def attribute_changed(attribute, old_value, new_value)
    print attribute, " changed from ",
          old_value, " to ",
          new_value, "\n"
  end
end

class SimpleBean < NotifierBase
  attribute :name, :firstname

  def impotent_name=(new_name)
    @name = new_name
  end
end


test = TestBean.new
listener = LoggingPropertyChangeListener.new
test.register_listener(listener)
test.name = 'James Scott'
test.firstname = "Scott"
test.firstname = "James"
test.unregister_listener(listener)



test = SimpleBean.new
listener = LoggingPropertyChangeListener.new
test.register_listener(listener)
test.name = 'James Scott'
test.firstname = 'Scott'
test.firstname = 'James'
test.unregister_listener(listener)


# output it generates:

# ==> name changed from nil to James Scott
# ==> firstname changed from nil to Scott
# ==> firstname changed from Scott to James


#
# END
#



