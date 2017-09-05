## lib/skn_utils/converters/hash_to_xml.rb
#
# Converts Simple Hash to XML, or a Complex nested hash to XML
# Ref: https://stackoverflow.com/questions/11933451/converting-nested-hash-into-xml-using-nokogiri
#
# Input Format:
# {
#   someKey: someValue,
#   list: {item: [1,2,3]},
#   listings: {
#       uri: 'topic/content/topic_value',
#       '@attributes' => {secured: true}
#   }
# }
#
# - produces:
# <?xml version="1.0"?>
# <root>
#   <one>1</one>
#   <two>2</two>
#   <list>
#     <item>1</item>
#     <item>2</item>
#     <item>3</item>
#   </list>
#   <listings secured="true">
#     <uri>topic/content/topic_value</uri>
#   </listings>
# </basic>
##
# xml_string = SknUtils::Converters::HashToXml.call(hash)
##
module SknUtils
  module Converters

    class HashToXml

      def initialize(*args)
      end

      def self.call(*vargs_with_at_least_one_hash, &block)
        new().call(*vargs_with_at_least_one_hash, &block)
      end

      def call(*vargs, &block)
        return nil if vargs.size == 0
        hash = generate_xml(*vargs )
          yield hash if block_given?
        hash
      end

    protected

      ##
      # generate xml from a hash of hashes or array of hashes
      def generate_xml(data, parent = false, opt = {})
        return if data.to_s.empty?
        return unless data.is_a?(Hash)

        unless parent
          # assume that if the hash has a single key that it should be the root
          root, data = (data.length == 1) ? [data.keys.first.to_s , data] : ["root", data]
          builder = ::Nokogiri::XML::Builder.new(opt.merge(:encoding => 'UTF-8')) do |xml|
            xml.send(root) {
              generate_xml(data, xml)
            }
          end

          return builder.to_xml
        end

        data.each do |label, value|
          if value.is_a?(Hash)
            attrs = value.fetch('@attributes', {})
            # also passing 'text' as a key makes nokogiri do the same thing
            text = value.fetch('@text', '')
            parent.send(label, attrs, text) {
              value.delete('@attributes')
              value.delete('@text')
              generate_xml(value, parent)
            }

          elsif value.is_a?(Array)
            value.each do |el|
              # lets trick the above into firing so we do not need to rewrite the checks
              el = {label => el}
              generate_xml(el, parent)
            end

          else
            parent.send(label, value)
          end
        end
      end # end method

    end # end class
  end
end
