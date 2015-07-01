##
# spec/lib/skn_utils/generic_bean_spec.rb
#

RSpec.describe SknUtils::PageControls, "PageControls Marshal'able Bean class " do
  let(:object) {
    SknUtils::PageControls.new({one: "one",
                               two: "two",
                               three: {four: 4, five: 5, six: {seven: 7, eight: "eight" }},
                               four: {any_key: "any value"}, 
                               five: [],
                               six: [{any_key: "any value"},
                                     {four: 4, 
                                      five: 5, 
                                      six: {seven: 7, eight: "eight" }, 
                                      twenty:[{seven: 7, eight: 8 }, {nine: 9, ten: 10 }]
                                     }
                                    ]
                              })
  }

  context "Internal Operations, assuming :dept => :multi_with_arrays and enable_serialization => true" do
    it "Creates an empty bean if no params are passed" do
      is_expected.to be
    end
    it "Can be Marshalled after dynamically adding a key/value." do
        expect { object.fifty = {any_key: "any value"} }.not_to raise_error  
        expect { object.sixty = 60 }.not_to raise_error
        dmp = obj = ""  
        expect { dmp =  Marshal.dump(object) }.not_to raise_error
        expect { obj = Marshal.load(dmp) }.not_to raise_error
        expect(obj).to be_a(SknUtils::PageControls)
        expect( obj.fifty.any_key).to eql "any value"  
        expect( obj.sixty).to eql 60
    end
    it "Initializes from a hash" do
      expect(object).to be
    end
    it "Does not modify the base class, only singleton instance methods" do
      obj1 = SknUtils::PageControls.new({one: "one", two: "two"})
      obj2 = SknUtils::PageControls.new({three: "3", four: "4"})
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
      expect(object.fourtyfive?).to be false
    end
    it "Supports - respond_to? - method, because it has accessor or method_missing coverage" do
      expect(object).to respond_to(:one)
      expect(object.one).to eql "one"
    end
    it "nest objects if multi-level hash is given" do
      expect(object.three).to be_a(SknUtils::PageControls)
      expect(object.three.five).to eq(5)
    end
    it "nest objects if multi-level array of hashes is given" do
      expect(object.six).to be_a(Array)
      expect(object.six.first).to be_a(SknUtils::PageControls)
      expect(object.six.last).to be_a(SknUtils::PageControls)
      expect(object.six.last.six.eight).to eq('eight')
    end
    it "nest objects if multi-level array of hashes, and an element contains another array of hashes, is given" do
      expect(object.six.first).to be_a(SknUtils::PageControls)
      expect(object.six).to be_a(Array)
      expect(object.six.last.twenty).to be_a(Array)
      expect(object.six.last.twenty.first).to be_a(SknUtils::PageControls)
      expect(object.six.last.twenty.last).to be_a(SknUtils::PageControls)
      expect(object.six.last.twenty.first.eight).to eq(8)
      expect(object.six.last.twenty.last.ten).to eq(10)
    end
    it "nest arrays of objects if array of hashes is dynamically given  (post-create)" do
      expect { object.one_array = [{one: "one", two: "two"},{one: 1, two: 2}] }.not_to raise_error
      expect(object.one_array.first.one).to eql("one")
      expect(object.one_array.last.two).to eql(2)
      expect(object.one_array[0]).to be_a(SknUtils::PageControls)
    end
    it "#attributes method returns a hash of all attributes and their values." do
      expect(object.attributes).to be_a(Hash)
      expect(object.attributes[:one]).to be_eql("one")
      expect(object.attributes[:three]).to be_a(Hash)
      expect(object.attributes[:six].last[:six][:eight]).to eql('eight')
    end
  end

  shared_examples_for "retains initialization options" do
    it "retains depth_level option flag" do
      expect(@obj.depth_level).to eql(:multi_with_arrays)
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
