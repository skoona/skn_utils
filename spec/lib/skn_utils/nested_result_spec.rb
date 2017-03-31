##
# spec/lib/skn_utils/nested_bean_spec.rb
#

class MyObject

  attr_accessor :some_instance_value

  def initialize(parms)
    @some_instance_value = parms[:value]
  end

  def say(str)
    "saying #{str}!"
  end

  def to_h
    hsh = {msg: "You called #{__method__} on me!"}
    puts hsh
    hsh
  end

end

RSpec.shared_examples 'plain old ruby object' do

  context "Core Operations " do
    it 'creates NestedResults all the way down' do
      expect(object.three.six).to be_a(SknUtils::NestedResult)
      expect(object.six.last).to be_a(MyObject)
    end

    it 'provides getters' do
      expect(bean.one).to eql('one')
      expect(bean[:one]).to eql('one')
      expect(bean['one']).to eql('one')
      expect(bean.two).to eql('two')
      expect(bean[:two]).to eql('two')
      expect(bean['two']).to eql('two')
    end

    it 'provides setters' do
      bean.one = '1'
      bean.two = '2'
      expect(bean.two).to eql('2')
      expect(bean.one).to eql('1')
    end

    it 'can access deeply nested attributes' do
      expect(bean.six.first.six.eight).to eql('eight')
      expect(bean.eight.first.first.one).to eql('one')
    end

    it 'does not affect custom objects being passed in' do
      expect(bean.four.any_key.some_instance_value).to eql(['MyObject Testing', 'Looking for Modifications'])
    end

    it 'allows setting of new attributes' do
      bean.foo = 'bar'
      expect(bean.foo).to eql('bar')
    end

    it '#attribute? returns true or false based on true presence and non-blank contents of attribute.' do
      expect(bean.one?).to be_truthy
      expect(bean.three.seven?).to be_truthy
      expect(bean.three.seven).to be false
    end

    it 'can delete attributes' do
      bean.delete_field(:two)
      expect(bean.two?).to be_falsey
      bean.delete_field(:two)
      expect(bean.two?).to be_falsey
    end

    it 'can be accessed just like a hash with indifferent access' do
      bean.one = '1'
      expect(bean[:one]).to eql('1')
      expect(bean['one']).to eql('1')
    end

    it '#respond_to? replies as expected' do
      expect(bean.respond_to?(:one)).to be true
      expect(object2.respond_to?(:eleven)).to be true
    end

    it 'supports Fixnum keys ' do
      expect(bean[4201]).to eq 'Account Code'
      expect(bean[4201] = 'account code').to eq 'account code'
      expect(bean[4202]).to be_falsey
      expect(bean[4202] = 'account code').to eq 'account code'
    end

    it "protected #hash_from returns remaining hash from any root key as the starting point" do
      expect(bean.send(:hash_from, :one)).to eql({one: 'one'})
      expect(bean.send(:hash_from, :three)).to eql({three: { four: 4, five: 5, six: { seven: 7, eight: 'eight' }, seven: false }})
      expect(bean.send(:hash_from, :eight)).to eql({eight: [[{one: 'one', two: 'two'}],[{three: 'three', four: 'four'}]]})
    end

    it 'Raises NoMethodError in response to invalid key access' do
      expect{object.sixty_two}.to raise_exception(NoMethodError)
    end

    context '#attribute? present? like feature operates as expected' do
      let(:base) do
        SknUtils::NestedResult.new({
                                      empty_string: "", blank_string: " ", null: nil,
                                      empty_array: [], blank_arrays: [[]], empty_hash: {}
                                  })
      end

      it '#attribute? returns false when attribute is not defined or unknown' do
        [:empty_string, :blank_string, :null_string,
         :empty_hash, :empty_array, :blank_arrays, :twelve].each do |key|
          expect(base.send(:attribute?, key)).to be false
        end
      end
    end

  end

  context '#to_h' do
    let(:hash) { bean.to_h }

    it 'returns a hash of all attributes and their values.' do
      expect(hash).to be_a(Hash)
    end

    it 'translates nested objects back to hashes when calling to_h' do
      expect(hash[:three][:six]).to be_a(Hash)
    end

    it 'translates elements with Fixnum as key back to hashes when calling to_h' do
      expect(hash[4201]).to eq('Account Code')
    end

    it 'handles array types when calling to_h' do
      expect(hash[:six]).to be_a(Array)
      expect(hash[:six][2]).to be_a(MyObject)
      expect(hash[:six][0]).to be_a(Hash)
      expect(hash[:six].size).to eql(3)
    end

    it 'handles hashes nested in arrays when calling to_h' do
      expect(hash[:six][0]).to be_a(Hash)
    end

    it 'handles hashes nested in arrays of arrays-of-hashes when calling to_h' do
      expect(hash[:eight][0][0]).to be_a(Hash)
      expect(hash[:eight][1][0]).to be_a(Hash)
      expect(hash[:eight].first.first[:one]).to eql('one')
      expect(hash[:eight].last.first[:four]).to eql('four')
    end

    it 'handles non-hash attributes properly' do
      expect(hash[:one]).to eql('one')
    end

    it 'does not change custom objects nested in beanure' do
      expect(hash[:four][:any_key]).to be_a(MyObject)
      expect(hash[:four][:any_key].some_instance_value).to eql(['MyObject Testing', 'Looking for Modifications'])
    end
  end
end


RSpec.describe SknUtils::NestedResult, 'NestedResult class - Basic usage.' do
  let(:object) do
    SknUtils::NestedResult.new(one: 'one', 4201 => 'Account Code',
                              two: 'two',
                              three: { four: 4, five: 5, six: { seven: 7, eight: 'eight' }, seven: false },
                              four: { any_key: MyObject.new(value: ['MyObject Testing', 'Looking for Modifications']) },
                              five: [4, 5, 6],
                              six: [{ four: 4, five: 5, six: { seven: 7, eight: 'eight' } },
                                    { four: 4, five: 5, six: { nine: 9, ten: 'ten' } },
                                    MyObject.new(value: ['MyObject Testing', 'Looking for Modifications'])],
                              seven: MyObject.new(value: ['MyObject Testing', 'Looking for Modifications']),
                              eight: [[{one: 'one', two: 'two'}],[{three: 'three', four: 'four'}]])
  end

  let(:object2) do
    SknUtils::NestedResult.new({ten: 10,
                               eleven: 11,
                               twelve: [[{five: 5, six: 6}],[{three: 3, '04' => 'four'}]]})
  end

  let(:json_bean) { object.to_json }

  context 'Initializers' do
    it 'Creates an empty bean if no params are passed' do
      is_expected.to be
    end

    it 'Initializes from a hash' do
      expect(SknUtils::NestedResult.new(one: 'one', two: 'two')).to be
    end

    it 'Initializes with attr methods intact after YAML.load' do
      yamled =  Psych.load( Psych.dump(object) )
      [:one, :two, :three, :four, :five, :six, :seven, :eight].each do |key|
        expect(yamled.respond_to?(key)).to be true
      end
    end

    it '#respond_to? verifies attr methods are created on the singleton class and not base class. ' do
      [:one, :two, :three, :four, :five, :six, :seven, :eight].each do |key|
        expect(object.respond_to?(key)).to be true
      end
      [:one, :two, :three, :four, :five, :six, :seven, :eight].each do |key|
        expect(object2.respond_to?(key)).to be false
      end
      [:ten, :eleven, :twelve].each do |key|
        expect(object2.respond_to?(key)).to be true
      end
      [:ten, :eleven, :twelve].each do |key|
        expect(object.respond_to?(key)).to be false
      end
    end

    it '#keys returns array of input hash keys' do
      expect(object.keys).to eq([:one, 4201, :two, :three, :four, :five, :six, :seven, :eight])
    end

  end

  context 'Basic Operations without marshaling' do
    it_behaves_like 'plain old ruby object' do
      let(:bean) { object }
    end
  end

  context 'Marshalling to JSON' do
    it 'maintains structure when marshalling to JSON' do
      expect(JSON.parse(json_bean)['five']).to eql([4, 5, 6])
    end
  end

  context 'Basic Operations after Yaml marshaling' do
    let(:dumped_object) { Psych.dump(object) }

    it "#encode_with exports the original hash when YAML'ed" do
      expect(dumped_object[42..-1]).to_not include('ruby/object:SknUtils::NestedResult')
    end

    it_behaves_like 'plain old ruby object' do
      let(:bean) { Psych.load(dumped_object) }
    end
  end

  context 'NestedResults stripped of their internal singleton accessors can be Marshaled!' do
    let(:dumped_object) { Psych.dump(object) }
    let(:loaded_object) { Psych.load(dumped_object) }
    let(:marshaled_object) { Marshal.dump(loaded_object) }

    it_behaves_like 'plain old ruby object' do
      let(:bean) { Marshal.load(marshaled_object) }
    end
  end

  context 'NestedResults Survive direct Marshall' do
    let(:marshaled_object) { Marshal.dump(object) }

    it_behaves_like 'plain old ruby object' do
      let(:bean) { Marshal.load(marshaled_object) }
    end
  end

end
