##
# spec/lib/skn_util/result_bean_spec.rb
#

describe SknUtil::ResultBean, "Generic Bean class " do
  let(:object) {
    SknUtil::ResultBean.new({one: "one",
                             two: "two",
                             three: {four: 4, five: 5, six: {seven: 7, eight: "eight" }},
                             four: {any_key: "any value"}, five: []}
                           )
  }


  it "Creates an empty bean if no params are passed" do
    is_expected.to be
  end

  context "Internal Operations " do
    it "Initializes from a hash" do
      expect(SknUtil::ResultBean.new({one: "one", two: "two"})).to be
    end
    it "Does not modify the base class, only singleton instance methods" do
      obj1 = SknUtil::ResultBean.new({one: "one", two: "two"})
      obj2 = SknUtil::ResultBean.new({three: 3, four: "4"})
      expect(obj1.one).to eql "one"
      expect(obj2.three).to eql 3
      expect(obj2.one?).to be false
      expect(obj1.three?).to be false
      expect { obj1.three }.to raise_error NoMethodError
      expect { obj2.one }.to raise_error NoMethodError
    end
    it "Supports - respond_to - methods, because it has accessor methods" do
      expect(object).to respond_to(:one)
    end
    it "nest objects if multi-level hash is given" do
      expect(object.three).to be_a(SknUtil::ResultBean)
      expect(object.three.five).to eq(5)
    end
    it "#attributes method returns a hash of all attributes and their values." do
      expect(object.attributes).to be_a(Hash)
      expect(object.attributes[:one]).to eql("one")
      expect(object.attributes[:three]).to be_a(Hash)
    end
  end

  shared_examples_for "generic variable container" do
    it "retains depth_level option flag" do
      expect(@obj.depth_level).to eql(:multi)
    end
    it "retains serialization option flag" do
      expect(@obj.serialization_required?).to be false
    end
    it "provides getters" do
      expect(@obj.one).to eql("one")
      expect(@obj.two).to eql("two")
    end
    it "provides setters" do
      expect(@obj.one).to eql("one")
      expect(@obj.two).to eql("two")
      @obj.one = "1"
      @obj.two = "2"
      expect(@obj.two).to eql("2")
      expect(@obj.one).to eql("1")
    end
    it "#clear_attribute sets given attribute to nil." do
      expect(@obj.two).to eql("two")
      expect(@obj.clear_two).to be_nil
    end
    it "#attribute? returns true or false based on contents of attribute." do
      expect(@obj.two?).to be true
      @obj.clear_two
      expect(@obj.two?).to be false
      expect(@obj.three?).to be true
      expect(@obj.four?).to be true
      @obj.clear_three
      expect(@obj.three?).to be false
      @obj.clear_four
      expect(@obj.four?).to be false
    end
    it "#attribute? returns false when attribute is not defined or unknown" do
      expect(@obj.address?).to be false
    end
    it "raises an 'NoMethodError' error when attribute that does not exist is accessed " do
      expect { @obj.address }.to raise_error NoMethodError
    end
    context "transformations are enabled with " do
      it "#to_json method returns a serialized version of this object." do
        expect(object.to_json).to include(":\"")
      end
      it "#to_xml method returns a serialized version of this object." do
        expect(object.to_xml).to include("xml version")
      end
      it "#to_hash method returns a serialized version of this object." do
        expect(object.to_hash).to be_a(Hash)
      end
    end
  end

  context "Basic Operations without marshaling " do
    before :each do
      @obj = object
    end
    it_behaves_like "generic variable container"
  end
  context "Basic Operations after Yaml marshaling " do
    before :each do
      dmp = YAML::dump(object)
      @obj = YAML::load(dmp)
    end
    it_behaves_like "generic variable container"
  end
  context "Basic Operations after Marshal marshaling " do
    it "Singleton objects (like ResultBean) cannot be marshaled" do
      expect { Marshal.dump(object) }.to raise_error TypeError
    end
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
    it_behaves_like "generic variable container"
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
    it_behaves_like "generic variable container"
  end

end
