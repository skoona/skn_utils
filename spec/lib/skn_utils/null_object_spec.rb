##
# spec/lib/skn_utils/null_object_spec.rb
#

RSpec.describe SknUtils::NullObject, "NullObject with Helpers " do

  context "Null Object Operations" do
    it "consumes any method called on it" do
      expect(subject.any_method).to be_a(subject.class)
    end

    it "consumes the whole chain of methods called on it" do
      expect(subject.any_method.chaining_methods).to be_a(subject.class)
    end
  end

  context "Alternate #try() named #nullable?() " do
    it "#nullable?(value) returns null object if value is nil" do
      expect(SknUtils::nullable?(nil)).to be_a(subject.class)
    end

    it "#nullable?(value) consumes the whole chain of methods called on it if value is nil" do
      expect(SknUtils::nullable?(nil).any_method.chaining_methods).to be_a(subject.class)
    end
    it "#nullable?(value) returns the value if valid" do
      expect(SknUtils::nullable?({value: true})[:value]).to be true
    end
  end

end
