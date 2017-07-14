##
# <project.root>/lib/skn_utils/nested_result.rb
#
# SknUtils::NestedResult Value Container/Class for Ruby with Indifferent Hash and/or Dot.notation access
#
# Description:
#
# Creates an Object with attribute methods for dot.notation and hash.notation access
# for each hash input key/value pair.
#
#   If the key's value is an hash itself, it will become an NestedResult Object.
#   if the key's value is an Array of Hashes, each hash element of the Array will
#      become an Object; non-hash object are left as-is
#   if the key's value is an Array of Arrays-of- Hash/Object, each hash element of each Array will
#      become an Object; non-hash object are left as-is.  This array of array of arrays
#      goes on to the end.
#
#   Transforms entire input hash contents into dot.notation and hash.notation accessible key/value pairs.
#     - hash
#     - array of hashes
#     - non hash element values are not modified,
#       whether in an array or the basic value in a key/value pair
#
# The ability of the resulting Object to be YAML/Psych'ed, or Marshaled(dump/load) is preserved
#
##
# Transforms entire input hash contents into dot.notation accessible object
#  - hash
#  - array of hashes
#  - non hash element values are not modified, whether in an array or the basic value in a key/value pair
#
##
# This module provides
#
# Simple Initialization Pattern
#  person = SknUtils::NestedResult.new( {name: "Bob", title: {day: 'Analyst', night: 'Fireman'}} )
#
# Serializers:
#    person.to_hash
#      => {name: 'Bob', title: {day: 'Analyst', night: 'Fireman'}}
#    person.to_json
#      => "{\"name\":\"Bob\", \"title\":{\"day\":\"Analyst\", \"night\":\"Fireman\"}}"
#
# Dynamic addition of new key/values after initialization
#    person.address = 'Fort Wayne Indiana'
#    person.address
#      => 'Fort Wayne Indiana'
#
# dot.notation feature for all instance variables
#   person.title.day
#     => "Analyst"
#   person.name = "James"
#     => "James"
#
# InDifferent String/Symbol hash[notation] feature for all instance variables
#   person['title']['day']
#     => "Analyst"
#   person['name'] = "James"
#     => "James"
#   person[:name]
#     => "James"
#   person[:name] = "Bob"
#     => "Bob"
#
# Supports <attr>? predicate method patterns, and delete_field(:attr) method
#  example:
#    person.title.night?
#      => true                    true or false, like obj.name.present?
#    person.delete_field(:name)   only first/root level attributes can be deleted
#      => 'Bob'                   returns last value of deleted key
#    person.name_not_found
#      => NoMethodFound           raises exception if key is not found
#
# Exporting hash from any key starting point
#   person.hash_from(:name)
#     => {name: 'Bob'}            the entire hash tree from that starting point
##
# Advanced Methods
#  #to_hash                          - returns copy of input hash
#  #to_json(*args)                   - converts input hash into JSON
#  #keys                             - returns the first-level keys of input hash
#  #delete_field(attr_sym)           - removes attribute/key and returns it's former value
#  #hash_from(starting_attr_sym)     - (Protected Method) returns remaining hash starting from key provided
#
##
# Known Issues
# - Fixnum keys work as keys with the exception of #respond_to?() which does not support them
# - Entries with Fixnums or object-instance keys are accessible only via #[]=(), #[] Hash.notation
#     methods and not the dot.notation feature
#
###################################################################################################

module SknUtils
  class NestedResult

    def initialize(params={})
      reset_from_empty!(params)
    end

    def [](attr)
      container[key_as_sym(attr)]
    end

    #Feature: if a new attribute is added, on first read method_missing will create getters/setters
    def []=(attr, value)
      container.store(key_as_sym(attr), value)
    end

    def delete_field(name)      # protect public methods
      sym = key_as_sym(name)
      unless !sym.is_a?(Symbol) || self.class.method_defined?(sym)
        singleton_class.send(:remove_method, "#{sym.to_s}=".to_sym, sym) rescue nil
        container.delete(sym)
      end
    end

    #
    # Exporters
    #
    def to_hash
      attributes
    end

    alias_method :to_h, :to_hash

    def to_json(*args)
      attributes.to_json(*args)
    end

    #
    # Returns a string containing a detailed summary of the keys and values.
    #
    def to_s
      attributes.to_s
    end

    ##
    # Ruby basic Class methods
    #
    def ==(other)
      return false unless other.is_a?(NestedResult)
      to_hash.eql?(other.to_hash)
    end
    alias_method :===, :==

    def eql?(other)
      return false unless other.is_a?(NestedResult)
      to_hash.eql?(other.to_hash)
    end

    def hash
      to_hash.hash
    end

    # Feature: returns keys from root input Hash
    def keys
      container.keys
    end

    ##
    # YAML/Psych load support, chance to re-initialize value methods
    #
    # Use our unwrapped/original input Hash when yaml'ing
    def encode_with(coder)
      coder['container'] = attributes
    end

    # Use our hash from above to fully re-initialize this instance
    def init_with(coder)
      case coder.tag
        when '!ruby/object:SknUtils::NestedResult', "!ruby/object:#{self.class.name}"
          reset_from_empty!( coder.map['container'] )
      end
    end

    # returns hash from any root key starting point: object.root_key
    # - protected to reasonably ensure key is a symbol
    def hash_from(sym)
      starting_sym = key_as_sym(sym)
      bundle = ((starting_sym == container) ? container : { starting_sym => container[starting_sym] })
      bundle.keys.each_with_object({}) do |attr,collector|
        value = bundle[attr]
        case value
          when NestedResult
            value = value.to_hash
          when Array
            value = value.map {|ele| array_to_hash(ele) }
        end
        collector[attr] = value                                                          # new copy
      end
    end

  protected

    def reset_from_empty!(params={}, speed=true)
      @container =  {}
      speed ? initialize_for_speed(params) :
          initialize_from_hash(params)
    end

    ##
    # Marshal.load()/.dump() support, chance to re-initialize value methods
    #
    def marshal_dump
      to_hash
    end

    # Using the String from above create and return an instance of this class
    def marshal_load(hash)
      reset_from_empty!(hash)
    end

    def respond_to_missing?(method, incl_private=false)
      method_nsym = method.is_a?(Symbol) ? method.to_s[0..-2].to_sym : method
      container[key_as_sym(method)] || container[method_nsym] || super
    end

  private

    # Feature: attribute must exist and have a non-blank value to cause this method to return true
    def attribute?(attr)
      return false unless container.key?(key_as_sym(attr))
      ![ "", " ", nil, [],[""], [" "], NestedResult.new({}), [[]]].any? {|a| a == container[key_as_sym(attr)] }
    end

    # Feature:  returns a hash of all attributes and their current values
    def attributes
      hash_from(container)
    end

    def container
      @container ||= {}
    end

    # Feature: enables dot.notation and creates matching getter/setters
    def enable_dot_notation(sym)
      name = key_as_sym(sym)
      unless !name.is_a?(Symbol) || singleton_class.method_defined?(name)
        singleton_class.send(:define_method, name) do
          container[name]
        end

        singleton_class.send(:define_method, "#{name.to_s}=".to_sym) do |x|
          container[name] = x
        end
      end
      name
    end

    # Don't create methods until first access
    def initialize_for_speed(hash)
      hash.each_pair do |k,v|
        key = key_as_sym(k)
        case v
          when Array
            value = v.map { |element| translate_value(element) }
            container.store(key, value)
          when Hash
            container.store(key, NestedResult.new(v))
          else
            container.store(key, v)
        end
      end
    end

    def initialize_from_hash(hash)
      hash.each_pair do |k,v|
        key = key_as_sym(k)
        enable_dot_notation(key)
        case v
          when Array
            value = v.map { |element| translate_value(element) }
            container.store(key, value)
          when Hash
            container.store(key, NestedResult.new(v))
          else
            container.store(key, v)
        end
      end
    end

    # Feature: unwrap array of array-of-hashes/object
    def array_to_hash(array)
      case array
        when NestedResult
          array.to_hash
        when Array
          array.map { |element| array_to_hash(element) }
        else
          array
      end
    end

    # Feature: wrap array of array-of-hashes/object
    def translate_value(value)
      case value
        when Hash
          NestedResult.new(value)
        when Array
          value.map { |element| translate_value(element) }
        else
          value
      end
    end

    def key_as_sym(key)
      case key
        when Symbol
          key
        when String
          key.to_sym
        else
          key # no change, allows Fixnum and Object instances
      end
    end

    # Feature: post-assign key/value pair, <attr>?? predicate, create getter/setter on first access
    def method_missing(method, *args, &block)
      method_sym = key_as_sym(method)
      method_nsym = method_sym.is_a?(Symbol) ? method.to_s[0..-2].to_sym : method


      if method.to_s.end_with?("=")                                    # add new key/value pair, transform value if Hash or Array
        initialize_from_hash({method_nsym => args.first})         # Add Reader/Writer one first need

      elsif container.key?(method_sym)
        container[method_sym]                                         # Add Reader/Writer one first need

      elsif method.to_s.end_with?('?')                                # order of tests is significant,
        attribute?(method_nsym)

      else # TODO: replace following with nil to match OpenStruct behavior when key not found
        e = NoMethodError.new "undefined method `#{method}' for #{self.class.name}", method, args
        e.set_backtrace caller(1)
        raise e

      end
    end # end method_missing: errors from enable_dot..., initialize_hash..., and attribute? are possible

  end # end class
end # end module
