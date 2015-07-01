##
# <root>/spec/support/shared_example_ruby_pojo.rb
#
# refs: result_bean, result_with_errors
#

RSpec.shared_examples "ruby pojo" do
  it "provides getters" do
    expect(@obj.one).to eql("one")
    expect(@obj.two).to eql("two")
  end
  it "provides setters" do
    @obj.one = "1"
    @obj.two = "2"
    expect(@obj.two).to eql("2")
    expect(@obj.one).to eql("1")
  end
  it "#clear_attribute sets given attribute to nil." do
    expect(@obj.two).to eql("two")
    expect(@obj.clear_two).to be_nil
  end
    it "#attribute? returns true or false based on true presence and non-blank contents of attribute." do
    expect(@obj.two?).to be true
    @obj.two = false
    expect(@obj.two?).to be true
    @obj.clear_two
    expect(@obj.two?).to be false
    expect(@obj.three?).to be true
    @obj.clear_three
    expect(@obj.three?).to be false
  end
  it "#attribute? returns false when attribute is not defined or unknown" do
    expect(@obj.address?).to be false
  end
  it "raises an 'NoMethodError' error when attribute that does not exist is accessed " do
    expect { @obj.address }.to raise_error NoMethodError
  end
  it "Nests objects if multi-level hash is given " do
    obj = SknUtils::ResultBeanWithErrors.new({one: "one", two: "two", three: {four: 4, five: 5}})
    expect(obj.three).to be_kind_of(SknUtils::NestedResultBase)
    expect(obj.three.five).to eq(5)
  end
  it "#attributes method returns a hash of all attributes and their values." do
    expect(@obj.attributes).to be_a(Hash)
    expect(@obj.attributes[:one]).to eql("one")
    expect(@obj.attributes[:three]).to be_a(Hash)
  end
  it "#attributes method excludes internal attributes unless overridden." do
    expect(@obj.attributes[:skn_enabled_depth]).to be_nil
    expect(@obj.attributes(true)[:skn_enabled_depth]).to be_nil
    expect(@obj.attributes(false)[:skn_enabled_depth]).to eql @obj.depth_level
  end
  
  context "transformations are enabled with " do
    it "#attributes method returns a hash of all attributes and their values." do
      expect(@obj.attributes).to be_a(Hash)
      expect(@obj.attributes[:one]).to be_eql("one")
      expect(@obj.attributes[:three]).to be_a(Hash)
    end    
    it "#to_json method returns a serialized version of this object." do
      expect(@obj.to_json).to include(":\"")
    end
    it "#to_xml method returns a serialized version of this object." do
      expect(@obj.to_xml).to include("xml version")
    end
    it "#to_hash method returns a serialized version of this object." do
      expect(@obj.to_hash).to be_a(Hash)
    end
  end
end
