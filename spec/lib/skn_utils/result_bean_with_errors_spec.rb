##
# spec/lib/skn_utils/result_bean_with_errors_spec.rb
#

RSpec.describe SknUtils::ResultBeanWithErrors, "Result Bean class with ActiveModel::Errors object " do
  let(:object) {
    SknUtils::ResultBeanWithErrors.new({one: "one",
                             two: "two",
                             three: {four: 4, five: 5, six: {seven: 7, eight: "eight" }},
                             four: {any_key: "any value"}, 
                             five: []
                            })
  }

  context "Internal Operations, assuming :dept => :multi and enable_serialization => false" do
    it "Creates an empty bean if no params are passed" do
      is_expected.to be
      expect(subject.errors).to be
    end
    it "Initializes from a hash that DOES NOT include an errors.object " do
      expect(SknUtils::ResultBeanWithErrors.new({one: "one", two: "two"})).to be
    end
    it "Initializes from a hash that DOES include an errors.object " do
      errors = ActiveModel::Errors.new(self)  ## VERY BAD IDEAL
      expect(SknUtils::ResultBeanWithErrors.new({one: "one", two: "two", errors: errors})).to be
    end
    it "Does not modify the base class, only singleton instance methods" do
      obj1 = SknUtils::ResultBeanWithErrors.new({one: "one", two: "two"})
      obj2 = SknUtils::ResultBeanWithErrors.new({three: "3", four: "4"})
      expect(obj1.one).to eql "one"
      expect(obj2.three).to eql "3"
      expect(obj2.one?).to be_falsey
      expect(obj1.three?).to be_falsey
      expect { obj1.three }.to raise_error NoMethodError
      expect { obj2.one }.to raise_error NoMethodError
    end
    it "Supports - respond_to - methods, because it has accessor methods" do
      expect(object).to respond_to(:one)
    end
  end

  shared_examples_for "retains initialization options" do
    it "retains depth_level option flag" do
      expect(@obj.depth_level).to eql(:multi)
    end
    it "retains serialization option flag" do
      expect(@obj.serialization_required?).to be false
    end    
  end

  context "ActiveModel:Errors object" do
    it "#errors method returns an ActiveModel::Errors object" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: "two"})
      expect(obj.errors).to be_an_instance_of(ActiveModel::Errors)
    end

    it "#errors method accepts additional errors" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: "two"})
      obj.errors.add(:one,"must be numeric.")
      expect(obj.errors.size).to be 1
    end

    it "#errors.full_messages method returns messages" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: "two"})
      obj.errors.add(:one,"must be numeric.")
      expect(obj.errors.full_messages.first).to include("numeric")
    end

    it "#errors.add_on_empty method correctly adds new errors" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add_on_empty(:two)
      expect(obj.errors.count).to be 1
    end

    it "#errors.add_on_blank method correctly adds new errors" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add_on_blank(:two)
      expect(obj.errors.count).to be 1
    end

    it "#errors.get method correctly retrieves existing message by attribute" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add_on_blank(:two)
      expect(obj.errors.get(:two).first).to include("blank")
    end

    it "#errors[] method correctly retrieves existing message by attribute" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add_on_blank(:two)
      expect(obj.errors[:two].first).to include("blank")
    end

    it "#errors.set method correctly adds sets message on attribute" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.set(:two, "Required value, must not be empty")
      expect(obj.errors.get(:two)).to include("Required")
    end

    it "#errors.include? method correctly determines that an error exists for the given key" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add(:two, "Required value, must not be empty")
      result = obj.errors.include?(:two)
      expect(result).to be_truthy
      result = obj.errors.include?(:one)
      expect(result).to be_falsey
    end

    it "#errors.delete method correctly removes an error for the given key" do
      obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add(:two, "Required value, must not be empty")
      result = obj.errors.include?(:two)
      expect(result).to be_truthy
      obj.errors.delete(:two)
      result = obj.errors.include?(:two)
      expect(result).to be_falsey
    end
  end

  context "Serialization" do
    before :each do
      @obj = object
    end
    it "Serialization does not include the errors object." do
      expect(@obj.to_hash[:errors]).not_to be
      expect(@obj.errors).to be_a(ActiveModel::Errors)
    end

    it_behaves_like "retains initialization options"    
    it_behaves_like "ruby pojo"    
  end

  context "Basic Operations after Marshal marshaling " do
    it "Singleton objects (like ResultBean) cannot be marshaled" do
      expect { Marshal.dump(object) }.to raise_error TypeError
    end
  end
  context "Basic Operations without marshaling " do
    before :each do
      @obj = object
    end
    it_behaves_like "retains initialization options"    
    it_behaves_like "ruby pojo"
  end
  context "Basic Operations after Yaml marshaling " do
    before :each do
      dmp = YAML::dump(object)
      @obj = YAML::load(dmp)
    end
    it_behaves_like "retains initialization options"    
    it_behaves_like "ruby pojo"
  end
  context "ResultBeans stripped of their internal singleton accessors can be Marshaled! " do
    before :each do
      dmp = YAML::dump(object)
      obj = YAML::load(dmp)                        # Yaml'ing removes singleton accessor methods'
                                                   # by initializing object without using its
                                                   # initialize() method

      dmp =  Marshal.dump(obj)                     # Now Marshal load/dump will work
      @obj = Marshal.load(dmp)                     # Use GenericBean if Marshal support is needed
    end
    it_behaves_like "retains initialization options"    
    it_behaves_like "ruby pojo"
  end
  context "Basic Operations after Yaml marshaling via restored accessors " do
    before :each do
      dmp = YAML::dump(object)
      @obj = YAML::load(dmp)
      # Restore setters
      @obj.attributes.keys.each do |k|
        @obj.singleton_class.send(:attr_accessor, k)
      end
    end
    it_behaves_like "retains initialization options"    
    it_behaves_like "ruby pojo"
  end
  
end
