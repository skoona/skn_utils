##
# spec/lib/skn_utils/result_bean_spec.rb
#

RSpec.describe SknUtils::ResultBean, "Result Bean class - Basic usage." do
  let(:object) {
    SknUtils::ResultBean.new({one: "one",
                             two: "two",
                             three: {four: 4, five: 5, six: {seven: 7, eight: "eight" }},
                             four: {any_key: "any value"}, 
                             five: [],
                             six: [{four: 4, five: 5, six: {seven: 7, eight: "eight" }},
                                   {four: 4, five: 5, six: {nine: 9, ten: "ten" }}
                                  ]
                            })
  }

  context "Internal Operations, assuming :dept => :multi and enable_serialization => false" do
    it "Creates an empty bean if no params are passed" do
      is_expected.to be
    end
    it "Initializes from a hash" do
      expect(SknUtils::ResultBean.new({one: "one", two: "two"})).to be
    end
    it "Does not modify the base class, only singleton instance methods" do
      obj1 = SknUtils::ResultBean.new({one: "one", two: "two"})
      obj2 = SknUtils::ResultBean.new({three: 3, four: "4"})
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
    it "Supports - respond_to - methods, because it has respond_to_missing? method" do
      expect(object.method(:one)).to be
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
      # @obj.attributes.keys.each do |k|
        # @obj.singleton_class.send(:attr_accessor, k)
      # end
    end
    it_behaves_like "retains initialization options"    
    it_behaves_like "ruby pojo"
  end

end
