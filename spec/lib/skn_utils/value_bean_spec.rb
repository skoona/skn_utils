##
# spec/lib/skn_utils/Value_bean_spec.rb
#

RSpec.describe SknUtils::ValueBean, "Basic Value Bean class " do
  let(:object) {
    SknUtils::ValueBean.new({one: "one",
                             two: "two",
                             three: {four: 4, five: 5, six: {seven: 7, eight: "eight" }},
                             four: {any_key: "any value"}, five: []}
                           )
  }

  context "Internal Operations, assuming :dept => :multi and enable_serialization => true" do
    it "Creates an empty bean if no params are passed" do
      is_expected.to be
    end
    it "Can be Marshalled after dynamically adding a key/value." do
        expect { object.fifty = {any_key: "any value"} }.not_to raise_error  
        expect { object.sixty = 60 }.not_to raise_error
        dmp = obj = ""  
        expect { dmp =  Marshal.dump(object) }.not_to raise_error
        expect { obj = Marshal.load(dmp) }.not_to raise_error
        expect(obj).to be_a(SknUtils::ValueBean)
        expect(obj.fifty[:any_key]).to eql "any value"
        expect(obj.sixty).to eql 60
    end
    it "Initializes from a hash" do
      expect(SknUtils::ValueBean.new({one: "one", two: "two"})).to be
    end
    it "Does not modify the base class, only singleton instance methods" do
      obj1 = SknUtils::ValueBean.new({one: "one", two: "two"})
      obj2 = SknUtils::ValueBean.new({three: "3", four: "4"})
      expect(obj1.one).to eql "one"
      expect(obj2.three).to eql "3"
      expect(obj2.one?).to be false
      expect(obj1.three?).to be false
      expect { obj1.three }.to raise_error NoMethodError
      expect { obj2.one }.to raise_error NoMethodError
    end
    it "Supports - respond_to? - method, because it has accessors or method_missing coverage" do
      expect(object).to respond_to(:one)
      expect(object.one).to eql "one"
      expect{ object.fifty = {any_key: "any value"} }.not_to raise_error  
      expect( object.fifty).not_to respond_to(:any_key)
    end
    it "nest objects if multi-level hash is given" do
      expect(object.one).to be_eql("one")
      expect(object.two).to be_eql("two")
      expect(object.three).to be_a(Hash)
      expect(object.three[:five]).to eq(5)
    end
    it "#attributes method returns a hash of all attributes and their values." do
      expect(object.to_hash).to be_a(Hash)
      expect(object.to_hash[:one]).to be_eql("one")
      expect(object.to_hash[:three]).to be_a(Hash)
    end
  end

  shared_examples_for "retains initialization options" do
    it "retains depth_level option flag" do
      expect(@obj.depth_level).to eql(:single)
    end
    it "retains serialization option flag" do
      expect(@obj.serialization_required?).to be true
    end    
  end

  context "Basic Operations without marshaling " do
    before :each do
      @obj = object
    end

    it_behaves_like "retains initialization options"    
    it_behaves_like "marshalable ruby pojo"
  end
  context "Basic Operations after Yaml marshaling " do
    before :each do
      dmp = YAML::dump(object)
      @obj = YAML::load(dmp)
    end

    it_behaves_like "retains initialization options"    
    it_behaves_like "marshalable ruby pojo"
  end
  context "Basic Operations after Marshal marshaling " do
    before :each do
      dmp =  Marshal.dump(object)
      @obj = Marshal.load(dmp)
    end

    it_behaves_like "retains initialization options"    
    it_behaves_like "marshalable ruby pojo"
  end

end
