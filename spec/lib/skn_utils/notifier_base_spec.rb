##
# spec/lib/skn_utils/null_object_spec.rb
#

# Create a bean from that base
class TestBean < SknUtils::NotifierBase
  attribute :name, :firstname
end

class LoggingPropertyChangeListener
  def attribute_changed(attribute, old_value, new_value)
    print attribute, " changed from ",
          old_value, " to ",
          new_value, "\n"
  end
end

class SimpleBean < SknUtils::NotifierBase
  attribute :name, :firstname

  def impotent_name=(new_name)
    @name = new_name
  end
end


RSpec.describe SknUtils::NotifierBase, "Notify feature example for Ruby " do
  let(:test_obj)   { TestBean.new }
  let(:simple_obj) { SimpleBean.new }
  let(:listener)   { LoggingPropertyChangeListener.new }

  context "Basic Operations" do
    it "Initializes without params" do
      expect(subject).to be
    end
    it "Can be Inherited." do
      expect(test_obj).to be
    end
  end

  context "Notify Operations" do
    it "#register_listener registers listeners." do
      expect(test_obj.register_listener(listener)).to include(listener)
    end

    it "#unregister_listener removes listener." do
      test_obj.register_listener(listener)
      expect(test_obj.unregister_listener(listener)).to eq(listener)
    end

    it "notifies listeners of changes when attribute writer is used." do
      test_obj.register_listener(listener)
      expect(listener).to receive(:attribute_changed).with(:name, nil, 'James Scott')
      test_obj.name = 'James Scott'
    end

    it "does not notify listeners when attribute writer is not used." do
      simple_obj.register_listener(listener)
      expect(listener).not_to receive(:attribute_changed)
      simple_obj.impotent_name = 'James Scott'
      expect(simple_obj.name).to eq('James Scott')
    end

  end

end
