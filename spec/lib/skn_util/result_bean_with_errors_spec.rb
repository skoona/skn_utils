##
# spec/lib/skn_util/result_bean_with_errors_spec.rb
#

describe SknUtil::ResultBeanWithErrors, "Generic Bean class with ActiveModel::Errors object " do

  context "Internal Operations" do
    it "Creates an empty bean if no params are passed" do
      is_expected.to be
      expect(subject.errors).to be
    end

    it "Initializes from a hash that DOES NOT include an errors.object " do
      expect(SknUtil::ResultBeanWithErrors.new({one: "one", two: "two"})).to be
    end
    it "Initializes from a hash that DOES include an errors.object " do
      errors = ActiveModel::Errors.new(self)  ## VERY BAD IDEAL
      expect(SknUtil::ResultBeanWithErrors.new({one: "one", two: "two", errors: errors})).to be
    end
    it "provides getters" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: "two"})
      expect(obj.one).to be_eql("one")
      expect(obj.two).to be_eql("two")
    end
    it "provides setters" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: "two"})
      expect(obj.one).to be_eql("one")
      expect(obj.two).to be_eql("two")
      obj.one = "1"
      obj.two = "2"
      expect(obj.one).to be_eql("1")
      expect(obj.two).to be_eql("2")
    end
    it "Does not modify the base class, only singleton instance methods" do
      obj1 = SknUtil::ResultBeanWithErrors.new({one: "one", two: "two"})
      obj2 = SknUtil::ResultBeanWithErrors.new({three: "3", four: "4"})
      expect(obj1.one).to eql "one"
      expect(obj2.three).to eql "3"
      expect(obj2.one?).to be_falsey
      expect(obj1.three?).to be_falsey
      expect { obj1.three }.to raise_error NoMethodError
      expect { obj2.one }.to raise_error NoMethodError
    end
    it "Supports - respond_to - methods, because it has accessor methods" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: "two"})
      expect(obj).to respond_to(:one)
    end
    it "Nests objects if multi-level hash is given using a regular ResultBean" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: "two", three: {four: 4, five: 5}})
      expect(obj.one).to be_eql("one")
      expect(obj.two).to be_eql("two")
      expect(obj.three).to be_a(SknUtil::ResultBeanWithErrors)
      expect(obj.three.five).to eq(5)
    end
  end

  context "ActiveModel:Errors object" do
    it "#errors method returns an ActiveModel::Errors object" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: "two"})
      expect(obj.errors).to be_an_instance_of(ActiveModel::Errors)
    end

    it "#errors method accepts additional errors" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: "two"})
      obj.errors.add(:one,"must be numeric.")
      expect(obj.errors.size).to be 1
    end

    it "#errors.full_messages method returns messages" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: "two"})
      obj.errors.add(:one,"must be numeric.")
      expect(obj.errors.full_messages.first).to include("numeric")
    end

    it "#errors.add_on_empty method correctly adds new errors" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add_on_empty(:two)
      expect(obj.errors.count).to be 1
    end

    it "#errors.add_on_blank method correctly adds new errors" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add_on_blank(:two)
      expect(obj.errors.count).to be 1
    end

    it "#errors.get method correctly retrieves existing message by attribute" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add_on_blank(:two)
      expect(obj.errors.get(:two).first).to include("blank")
    end

    it "#errors[] method correctly retrieves existing message by attribute" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add_on_blank(:two)
      expect(obj.errors[:two].first).to include("blank")
    end

    it "#errors.set method correctly adds sets message on attribute" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.set(:two, "Required value, must not be empty")
      expect(obj.errors.get(:two)).to include("Required")
    end

    it "#errors.include? method correctly determines that an error exists for the given key" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: ""})
      obj.errors.add(:two, "Required value, must not be empty")
      result = obj.errors.include?(:two)
      expect(result).to be_truthy
      result = obj.errors.include?(:one)
      expect(result).to be_falsey
    end

    it "#errors.delete method correctly removes an error for the given key" do
      obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: ""})
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
      @obj = SknUtil::ResultBeanWithErrors.new({one: "one", two: "two", three: {four: 4, five: 5, six: {seven: 7, eight: "eight"}}})      
    end
    it "#attributes method returns a hash of all attributes and their values." do
      expect(@obj.attributes).to be_a(Hash)
      expect(@obj.attributes[:one]).to be_eql("one")
      expect(@obj.attributes[:three]).to be_a(Hash)
    end
    it "#to_json method returns a serialized verion of this object." do
      expect(@obj.to_json).to include(":\"")
    end
    it "#to_xml method returns a serialized verion of this object." do
      expect(@obj.to_xml).to include("xml version")
    end
    it "#to_hash method returns a serialized verion of this object." do
      expect(@obj.to_hash).to be_a(Hash)
    end
    it "Serialization does not include the errors object." do
      expect(@obj.to_hash[:errors]).not_to be
      expect(@obj.errors).to be_a(ActiveModel::Errors)
    end
  end
end
