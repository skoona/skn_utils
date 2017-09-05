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

    it "#call called with params returns xml string as expected. " do
      string = described_class.call({
                                      one: 1,
                                      two: 2,
                                      list: {item: [1,2,3]},
                                      listings: {item: [1,2,3]}
                                    })
      puts __method__, string
      expect(string).to be_a String
    end

    it "#call called with params and block yields xml string as expected. " do
      described_class.call({
                             one: 1,
                             two: 2,
                             list: {item: [1,2,3]},
                             listings: {item: [1,2,3]}
                           }) do |string|
        puts __method__, string
        expect(string).to be_a String
      end
    end

  end

  context "Handles Complex Hashes. " do
    let(:array_of_hashes) {
        {'resource' => [
                      { 'name' => 'category1',
                        'subCategory' => [
                            { 'name' => 'subCategory1',
                              'product' => [
                                  { 'name' => 'productName1',
                                    'desc' => 'desc1' },
                                  { 'name' => 'productName2',
                                    'desc' => 'desc2' } ]
                            } ]
                      },
                      { 'name' => 'category2',
                        'subCategory' => [
                            { 'name' => 'subCategory2.1',
                              'product' => [
                                  { 'name' => 'productName2.1.1',
                                    'desc' => 'desc1' },
                                  { 'name' => 'productName2.1.2',
                                    'desc' => 'desc2' } ]
                            } ]
                      }
                   ]
        }
    }

    let(:xml_aware_hash) {
                    {'xmlAwareHash' =>
                      {
                        'num' => 99,
                        'title' => 'something witty',
                        'nested' => {
                          'total' => [99, 98],
                          '@attributes' => {'foo' => 'bar', 'hello' => 'world'}
                        },
                        'anothernest' => {
                          '@attributes' => {'foo' => 'bar', 'hello' => 'world'},
                          'date' => [
                            'today',
                            {'day' => 23, 'month' => 'Dec',
                              'year' => {'y' => 1999, 'c' => 21},
                              '@attributes' => {'foo' => 'blhjkldsaf'}
                            }
                          ]
                        }
                      }
                    }
    }

    it "#call(nested_hash) return an xml string as expected." do
      string = described_class.call({
                                      one: 1,
                                      two: 2,
                                      list: {item: [1,2,3]},
                                      listings: {
                                          uri: 'topic/content/topic_value',
                                          '@attributes' => {secured: true}}
                                    })
      puts __method__, string
      expect( string ).to be_a String
    end

    it "#call(array_of_hashes) return an xml string as expected." do
      string = described_class.call(array_of_hashes, false)
      puts __method__, string
      expect( string ).to be_a String
    end

    it "#call(xml_aware_hash) return an xml string as expected." do
      string = described_class.call(xml_aware_hash)
      puts __method__, string
      expect( string ).to be_a String
    end

  end


end
