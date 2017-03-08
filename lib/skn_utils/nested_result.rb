##
# <project.root>/lib/skn_utils/nested_result.rb
#
# NestedResult Value Container/Class for Ruby
#
# Description:
# Creates an Object with instance variables and associated getters and setters for each hash input key.
#   If the key's value is also a hash itself, it too will become an Object.
#   if the key's value is a Array of Hashes, each hash element of the Array will become an Object; non-hash object are left as-is
#   Transforms entire input hash contents into dot.notation accessible object
#     - hash
#     - array of hashes
#     - non hash element values are not modified,
#       whether in an array or the basic value in a key/value pair
#
# The ability of the resulting Object to be Marshaled(dump/load) is preserved
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
#  person = Utility::NestedResult.new( {name: "Bob"} )
#
# Serializers:
#    person.to_hash
#      => {"name"=>"Bob"}
#    person.to_json
#      => "{\"name\":\"Bob\"}"
#
# Post create addition on new key/values
#    person.address = 'Fort Wayne Indiana'
#    person.address
#      => 'Fort Wayne Indiana'
#
# Support <attr>? and method patterns, and delete_field(:attr) method
#  example:
#    person.name?
#      => true          true or false, like obj.name.present?
#    person.name_not_found
#      => nil           sets :name to nil
#
# dot.notation feature for all instance variables
#   person.name
#     => "Bob"
#   person.name = "James"
#     => "James"
#
# InDifferent String/Symbol hash[notation] feature for all instance variables
#   person['name']
#     => "Bob"
#   person['name'] = "James"
#     => "James"
#   person[:name]
#     => "James"
#   person[:name] = "Bob"
#     => "Bob"
##
# Known Issues
# - Using instance variables as the container is misleading as instance variables have
#    restriction on key names.
#
#
module SknUtils
  class NestedResult

    def initialize(params={})
      @container =  {}
      initialize_from_hash(params)
    end

    def to_hash
      attributes
    end

    alias_method :to_h, :to_hash

    def to_json(*args)
      attributes.to_json(*args)
    end

    def to_s(*args)
      attributes.to_s(*args)
    end

    # Hash notation
    def [](attr)
      container[attr.to_sym]
    end

    def []=(attr, value)
      container.store(attr.to_sym, value)
    end

    def delete_field(sym)
      self.class.send(:remove_method, "#{sym.to_s}=".to_sym, sym.to_sym) if self.class.method_defined?(sym.to_sym)
      container.delete(sym.to_sym)
    end

    def ==(other)
      return false unless other.is_a?(NestedResult)
      self.to_hash.eql?(other.to_hash)
    end
    alias_method :===, :==

    def eql?(other)
      return false unless other.is_a?(NestedResult)
      self.to_hash.eql?(other.to_hash)
    end

    def hash
      self.to_hash.hash
    end

  protected

    def container
      @container ||= {}
    end

    ##
    # Marshalling Support
    ##

    #
    # Output a String representing this class
    #:nodoc:
    def _dump(depth=-1)
      Marshal.dump(attributes, depth)
    end

    #
    # Using the String from above create and return an instance of this class
    #:nodoc:
    def self._load(str)
      NestedResult.new(Marshal.load(str))
    end

    # Support the regular respond_to? method by
    # answering for any attr that method missing can actually handle
    #:nodoc:
    def respond_to_missing?(method, incl_private=false)
      method_nsym = method.to_s[0..-2].to_sym
      container[:method.to_sym] || container[:method_nsym] || super
    end

    # return a hash of all attributes and their current values
    # including nested arrays of hashes/objects
    #:nodoc:
    def attributes
      container.keys.each_with_object({}) do |attr,collector|
        value = container[attr]
        case value
          when Array
            value = value.map {|ele| ele.is_a?(NestedResult) ? ele.to_h : ele }
          when NestedResult
            value = value.attributes
        end
        collector[attr] = value                                                          # new copy
      end
    end

    # Determines the true existence of an attribute and then its non-blank or empty value
    # - attribute must exist and have a non-blank value to cause this method to return true
    #:nodoc:
    def attribute?(attr)
      return false unless container.key?(attr)
      ![ "", " ", nil, [],[""], [" "], {}].include?(container[attr])
    end

    ##
    # Adds the attr?() method pattern.  all attributes will respond to attr?: example - obj.name? with true or false
    # Handles getter for any instance_variable currently defined - create attr_accessor to prevent second call to mm
    # Handles setter for any instance_variable currently defined - create attr_accessor to prevent second call to mm
    # Handles new key/value assignment
    #
    #:nodoc:
    def method_missing(method, *args, &block)
      method_sym = method.to_sym
      method_nsym = method.to_s[0..-2].to_sym

      if method.to_s.end_with?('?')                                              # order of tests is significant,
        attribute?(method_nsym)

      elsif method.to_s.end_with?("=") and container[method_nsym].nil?           # add new key/value pair, transform value if Hash or Array
        initialize_from_hash({method_nsym => args.first})                        # concerned about args list; maybe args.first is better invocation

      elsif container.key?(method_sym)
        enable_dot_notation(method_sym)                                          # Add Reader/Writer one first need
        container[method_sym]

      else
        nil                                                                      # by team request, return nil vs NoMethodError
      end
    end

    # #method_missing seems to be faster than
    #  dynamically defined accessor methods
    def enable_dot_notation(name)
      unless self.class.method_defined?(name)
        self.class.send(:define_method, name) do
            container[name]
        end

        self.class.send(:define_method, "#{name}=".to_sym) do |x|
            container[name] = x
        end
      end
    end

    def initialize_from_hash(hash)
      hash.each_pair do |k,v|
        enable_dot_notation(k.to_sym)
        case v
          when Array
            value = v.map {|ele| ele.is_a?(Hash) ? NestedResult.new(ele) : ele}
            @container.store(k.to_sym, value)
          when Hash
            @container.store(k.to_sym, NestedResult.new(v))
          else
            @container.store(k.to_sym, v)
        end
      end
    end

  end # end class
end # end module
