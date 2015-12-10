##
# <root>/spec/support/shared_example_marshalable_ruby_pojo.rb
#
# refs: page_controls, generic_bean
#

RSpec.shared_examples "marshalable ruby pojo" do
  it "provides getters" do
    expect(@obj.one).to be_eql("one")
    expect(@obj.two).to be_eql("two")
  end
  it "provides setters" do
    @obj.one = "1"
    @obj.two = "2"
    expect(@obj.two).to be_eql("2")
    expect(@obj.one).to be_eql("1")
  end
  it "#clear_attribute sets given attribute to nil." do
    expect(@obj.two).to be_eql("two")
    expect(@obj.clear_two).to be_nil
  end
  it "#attribute? returns true or false based on true presence and non-blank contents of attribute." do
    expect(@obj.two?).to be true
    @obj.two = false
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
  it "#attributes method excludes internal attributes unless overridden." do
    expect(@obj.attributes[:skn_enabled_depth]).to be_nil
    expect(@obj.attributes(true)[:skn_enabled_depth]).to be_nil
    expect(@obj.attributes(false)[:skn_enabled_depth]).to eql @obj.depth_level
  end
  context "transformations are enabled with " do
    it "#to_hash method returns a serialized version of this object." do
      expect(@obj.to_hash).to be_a(Hash)
    end
    it "#attributes method returns original input hash." do
      expect(@obj.attributes).to be_a(Hash)
    end
  end
end
