##
# spec/lib/skn_util/generic_bean_spec.rb
#

describe SknUtil::PageControls, "Generic Marshal'able Bean class " do
  let(:object) {
    SknUtil::PageControls.new({one: "one",
                               two: "two",
                               three: {four: 4, five: 5, six: {seven: 7, eight: "eight" }},
                               four: {any_key: "any value"}, 
                               five: [],
                               six: [{any_key: "any value"},{four: 4, five: 5, six: {seven: 7, eight: "eight" }}]
                              })
  }

  context "Initialization Features " do
    it "Creates an empty bean if no params are passed" do
      is_expected.to be
    end

    it "Can be Marshalled after dynamically adding a key/value." do
        expect { object.fifty = {any_key: "any value"} }.not_to raise_error  
        expect { object.sixty = 60 }.not_to raise_error
        dmp = obj = ""  
        expect { dmp =  Marshal.dump(object) }.not_to raise_error
        expect { obj = Marshal.load(dmp) }.not_to raise_error
        expect(obj).to be_a(SknUtil::PageControls)
        expect( object.fifty.any_key).to eql "any value"  
        expect( object.sixty).to eql 60
    end
  end
  
  context "Internal Operations " do
    it "Initializes from a hash" do
      expect(object).to be
    end
    it "Does not modify the base class, only singleton instance methods" do
      obj1 = SknUtil::PageControls.new({one: "one", two: "two"})
      obj2 = SknUtil::PageControls.new({three: "3", four: "4"})
      expect(obj1.one).to eql "one"
      expect(obj2.three).to eql "3"
      expect(obj2.one?).to be false
      expect(obj1.three?).to be false
      expect { obj1.three }.to raise_error NoMethodError
      expect { obj2.one }.to raise_error NoMethodError
    end
    it "Supports predicates(?)" do
      expect(object.one?).to be true
      expect(object.three.five?).to be true
    end
    it "Does not support - respond_to - methods, because it has no accessor methods" do
      expect(object).not_to respond_to(:one)
      expect(object.one).to eql "one"
    end
    it "nest objects if multi-level hash is given" do
      expect(object.three).to be_a(SknUtil::PageControls)
      expect(object.three.five).to eq(5)
    end
    it "nest objects if multi-level array of hashes is given" do
      expect(object.six.first).to be_a(SknUtil::PageControls)
      expect(object.six.last).to be_a(SknUtil::PageControls)
      expect(object.six.last.six.eight).to eq('eight')
    end
    it "#attributes method returns a hash of all attributes and their values." do
      expect(object.attributes).to be_a(Hash)
      expect(object.attributes[:one]).to be_eql("one")
      expect(object.attributes[:three]).to be_a(Hash)
      expect(object.attributes[:six].last[:six][:eight]).to eql('eight')
    end
  end

  shared_examples_for "marshal-able generic variable container" do
    it "retains depth_level option flag" do
      expect(@obj.depth_level).to eql(:multi_with_arrays)
    end
    it "retains serialization option flag" do
      expect(@obj.serialization_required?).to be true
    end
    it "provides getters" do
      expect(@obj.one).to be_eql("one")
      expect(@obj.two).to be_eql("two")
    end
    it "provides setters" do
      expect(@obj.one).to be_eql("one")
      expect(@obj.two).to be_eql("two")
      @obj.one = "1"
      @obj.two = "2"
      expect(@obj.two).to be_eql("2")
      expect(@obj.one).to be_eql("1")
    end
    it "#clear_attribute sets given attribute to nil." do
      expect(@obj.two).to be_eql("two")
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
    it "raises an 'NoMethodError' error when attribute does not exist" do
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
      it "#attributes method returns original input hash." do
        expect(object.attributes).to be_a(Hash)
      end
    end
  end

  context "Basic Operations without marshaling " do
    before :each do
      @obj = object
    end
    it_behaves_like "marshal-able generic variable container"
  end
  context "Basic Operations after Yaml marshaling " do
    before :each do
      dmp = YAML::dump(object)
      @obj = YAML::load(dmp)
    end
    it_behaves_like "marshal-able generic variable container"
  end
  context "Basic Operations after Marshal marshaling " do
    before :each do
      dmp =  Marshal.dump(object)
      @obj = Marshal.load(dmp)
    end
    it_behaves_like "marshal-able generic variable container"
  end

end
