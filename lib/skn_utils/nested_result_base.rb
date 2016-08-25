##
# <project.root>/lib/skn_utils/nested_result_base.rb
#
# Creates an Object with instance variables and associated getters and setters for hash each input key. 
#   If the key's value is also a hash itself, it too will become an Object.
#   if the key's value is a Array of Hashes, each element of the Array will become an Object.
# 
# This nesting action is controlled by the value of the option key ':depth'. 
#   The key :depth defaults to :multi, an has options of :single, or :multi_with_arrays
# 
# The ability of the resulting Object to be Marshalled(dump/load) can be preserved by merging 
#   input params key ':enable_serialization' set to true.  It defaults to false for speed purposes
#
##
# Operational Options
# --------------------------------
#  :enable_serialization = false     -- [ true | false ], for speed, omits creation of attr_accessor
#  :depth = :multi                   -- [ :single | :multi | :multi_with_arrays ]
##
# NOTE: Cannot be Marshalled/Serialized unless input params.merge({enable_serialization: true}) -- default is false
#       Use GenericBean if serialization is needed, it sets this value to true automatically
##


module SknUtils

  class NestedResultBase
    include AttributeHelpers

    # :depth controls how deep into input hash/arrays we convert
    # :depth => :single | :multi | :multi_with_arrays 
    # :depth defaults to :multi
    # :enable_serialization controls the use of singleton_method() to preserve the ability to Marshal
    # :enable_serialization defaults to false
    #:nodoc:
    def initialize(params={})
      @skn_enabled_depth = params.delete(:depth) {|not_found| :multi }
      @skn_enable_serialization = params.delete(:enable_serialization) {|not_found| false }
      case depth_level
        when :single
              single_level_initializer(params)                 
        when :multi_with_arrays
              multi_level_incl_arrays_initializer(params)
        else
              multi_level_initializer(params)                  
      end
    end

    #:nodoc:
    def single_level_initializer(params={})   # Single Level Initializer -- ignore value eql hash
      params.each do |k,v|
        key = clean_key(k)
        singleton_class.send(:attr_accessor, key) unless respond_to?(key) or serialization_required?
        instance_variable_set("@#{key}".to_sym,v)
      end
    end

    #:nodoc:
    def multi_level_initializer(params={}) # Multi Level Initializer -- value eql hash then interate
      params.each do |k,v|
        key = clean_key(k)
        singleton_class.send(:attr_accessor, key) unless respond_to?(key) or serialization_required?
        if v.kind_of?(Hash)
          instance_variable_set("@#{key}".to_sym, self.class.new(v))
        else
          instance_variable_set("@#{key}".to_sym,v)
        end
      end
    end

    #:nodoc:
    def multi_level_incl_arrays_initializer(params={}) # Multi Level Initializer including Arrays of Hashes
      params.each do |k,v|
        key = clean_key(k)
        singleton_class.send(:attr_accessor, key) unless respond_to?(key) or serialization_required?
        if v.kind_of?(Array) and v.first.kind_of?(Hash)
          instance_variable_set("@#{key}".to_sym, (v.map {|nobj| self.class.new(nobj)}) )
        elsif v.kind_of?(Hash)
          instance_variable_set("@#{key}".to_sym, self.class.new(v))
        else
          instance_variable_set("@#{key}".to_sym,v)
        end
      end
    end

    # enablement for latter additions    
    def serialization_required?
      @skn_enable_serialization
    end

    # enablement for latter additions        
    def depth_level
      @skn_enabled_depth
    end

    # determines if this is one of our objects
    #:nodoc:
    def attribute_helper_object
      true
    end

    # Some keys have chars not suitable for symbol keys => @,#,:,-
    #:nodoc:
    def clean_key(original)
      formatted_key = original.to_s.gsub(/[#|@]/,'').gsub(/[:|-]/,'_')

      # if /^[#|@|:]/.match(formatted_key)  # filter out (@xsi) from '@xsi:type' keys
      #   label = /@(.+):(.+)/.match(formatted_key) || /[#|@|:](.+)/.match(formatted_key) || []
      #   formatted_key = case label.size
      #                     when 1
      #                       label[1].to_s
      #                     when 2
      #                       "#{label[1]}_#{label[2]}"
      #                     else
      #                       original  # who knows what it was, give it back
      #                   end
      # end
      # formatted_key
    end
    
        
  end
end
