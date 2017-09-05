##
# spec/lib/skn_utils/converters/hash_to_xml_spec.rb
#

describe SknUtils::Converters::HashToXml,  "Hash to XML Converter Utility " do

  context "Initializers Feature. " do

    it "#new can be called without params or block without error. " do
      expect( described_class.new()).to be_a described_class
    end

    it "#call can be called without params or block without error. " do
      expect( described_class.call()).to be nil
    end

    it "#new().hash_simple_to_xml() called with params returns xml string as expected. " do
      obj = described_class.new()
      string = obj.hash_simple_to_xml([{one: 1, two: 2, three: 3}])
      puts __method__, string
      expect(string).to be_a String
    end
    it "#new().hash_to_xml() called with params returns xml string as expected. " do
      obj = described_class.new()
      string = obj.hash_to_xml([{one: 1, two: 2, three: [1,2,3]}])
      puts __method__, string
      expect(string).to be_a String
    end
    it "#new().to_xml() called with params returns xml string as expected. " do
      obj = described_class.new()
      string = obj.send(:to_xml, [{one: 1, two: 2, three: [1,2,3]}])
      puts __method__, string
      expect(string).to be_a String
    end

    it "#call called with params returns xml string as expected. " do
      string = described_class.call([{one: 1, two: 2, three: [1,2,3]}])
      puts __method__, string
      expect(string).to be_a String
    end

    it "#call called with params and block yields xml string as expected. " do
      described_class.call([{one: 1, two: 2, three: [1,2,3]}]) do |string|
        expect(string).to be_a String
        puts __method__, string
      end
    end

  end

  context "Handles Complex Hashes. " do


    it "#call(nested_hash) return an xml string as expected." do
      string = described_class.call({one: 1, two: 2, three: [1,2,3]})
      puts __method__, string
      expect( string ).to be_a String
    end

    it "#call(array_of_hashes) return an xml string as expected." do
      string = described_class.call({one: 1, two: 2, three: [1,2,3]})
      puts __method__, string
      expect( string ).to be_a String
    end

  end


end
