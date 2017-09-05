## lib/skn_utils/converters/hash_to_xml.rb
#
# Converts Simple Hash to XML, or a Complex nested hash to XML
# Ref: https://stackoverflow.com/questions/11933451/converting-nested-hash-into-xml-using-nokogiri
# Ref: https://codereview.stackexchange.com/questions/51569/building-xml-by-enumerating-through-array-hashes


module SknUtils
  module Converters

    class HashToXml

      def initialize(*args)
        @source = args.shift
      end

      def self.call(*args, &block)
        new(*args).call(&block)
      end

      def call()
        hash = generate_xml_from_nested_hashes(@source)
          yield hash if block_given?
        hash
      end

      def hash_simple_to_xml(hash, base_type='root', collection_key='Collection')
        generate_xml_from_hash(hash, base_type, collection_key)
      end
      def hash_to_xml(data, parent = false, opt = {})
        generate_xml_from_nested_hashes(data, parent, opt)
      end

    protected

      ##
      # generate xml from a regular hash, with/out arrays
      def to_xml(data)
        Nokogiri::XML::Builder.new do |xml|
          xml.root do                           # Wrap everything in one element.
            handle_array('category',data,xml)  # Start the recursion with a custom name.
          end
        end.to_xml
      end

      ##
      # generate xml from a regular hash, with/out arrays
      def generate_xml_from_hash(hash, base_type, collection_key)
        builder = ::Nokogiri::XML::Builder.new do |xml|
          xml.send(base_type) { process_simple_array(collection_key, hash, xml) }
        end

        builder.to_xml
      end

      ##
      # generate xml from a hash of hashes or array of hashes
      def generate_xml_from_nested_hashes(data, parent = false, opt = {})
        return if data.to_s.empty?
        return unless data.is_a?(Hash)

        unless parent
          # assume that if the hash has a single key that it should be the root
          root, data = (data.length == 1) ? data.shift : ["root", data]
          builder = Nokogiri::XML::Builder.new(opt) do |xml|
            xml.send(root) {
              generate_xml_from_nested_hashes(data, xml)
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
              generate_xml_from_nested_hashes(value, parent)
            }

          elsif value.is_a?(Array)
            value.each do |el|
              # lets trick the above into firing so we do not need to rewrite the checks
              el = {label => el}
              generate_xml_from_nested_hashes(el, parent)
            end

          else
            parent.send(label, value)
          end
        end
      end

      private

      # support for #to_xml
      def handle_array(label,array,xml)
        array.each do |hash|
          xml.send(label) do                 # Create an element named for the label
            hash.each do |key,value|
              if value.is_a?(Array)
                handle_array(key,value,xml) # Recurse
              else
                xml.send(key,value)          # Create <key>value</key> (using variables)
              end
            end
          end
        end
      end

      # support for #generate_xml_from_hash
      def process_simple_array(label,array,xml)
        array.each do |hash|
          kids,attrs = hash.partition{ |k,v| v.is_a?(Array) }
          xml.send(label,Hash[attrs]) do
            kids.each{ |k,v| process_simple_array(k,v,xml) }
          end
        end
      end

    end
  end
end
