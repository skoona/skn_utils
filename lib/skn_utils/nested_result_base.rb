##
# <Rails.root>/lib/skn_utils/nested_result_base.rb
#
# Creates an Object with instance variables and associated getters and setters for hash each input key. 
#   If the key's value is also a hash itself, it too will become an Object.
#   if the key's value is a Array of Hashes, each element of the Array will become an Object.
# 
# This nesting action is controlled by the value of the option key ':depth'. 
#   The key :depth defaults to :multi, an has options of :single, or :multi_with_arrays
# 
# The ability of the resulting Object to be Marshalled(dump/load) can be preserved by merging 
#   into the input params key ':enable_serialization' set to true.  It defaults to false for speed purposes
#
##
# Operational Options
# --------------------------------
#  :enable_serialization = false     -- [ true | false ], for speed, omits creation of attr_accessor
#  :depth = :multi                   -- [ :single | :multi | :multi_with_arrays ]
##
# Public Components
# --------------------------------
# Inherit from NestedResultBase
# or Include AttributeHelpers
##
#
# Basic function includes:
#  - provides the hash or dot notation methods of accessing values from object created; i.e
#     'obj = ResultBean.new({value1: "some value", value2: {one: 1, two: "two"}}) 
#     'x = obj.value1' or 'x = obj.value2.one'
#     'x = obj["value1"]'
#     'x = obj[:value1]'
#
#  - enables serialization by avoiding the use of 'singleton_class' methods which breaks Serializers
#    Serializer supports xml, json, hash, and standard Marshall'ing
#
#    person = PageControls.new({name: "Bob"})
#    person.attributes          # => {"name"=>"Bob"}
#    person.serializable_hash   # => {"name"=>"Bob"}
#    person.to_hash             # => {"name"=>"Bob"}
#    person.to_json             # => "{\"name\":\"Bob\"}"
#    person.to_xml              # => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<page-controls>\n  <name>Bob</name>\n</page-controls>\n"
#    dmp = Marshal.dump(person) # => "\x04\bo:\x1ASknUtils::PageControls\x06:\n@nameI\"\bBob\x06:\x06ET"
#    person = Marshal.load(dmp) # => #<SknUtils::PageControls:0x007faede906d40 @name="Bob">
#
#    ***GenericBean designed to automatically handle the setup for serialization and multi level without arrays 
#
#  - post create additions:
#     'obj = ResultBean.new({value1: "some value", value2: {one: 1, two: "two"}}) 
#     'x = obj.one'                          --causes NoMethodError
#     'x = obj.one = 'some other value'      --creates a new instance value with accessors
#     'x = obj.one = {key1: 1, two: "two"}'  --creates a new ***bean as the value of obj.one
#     'y = obj.one.two'                      --returns "two"
#     'y = obj.one[:two]                     --returns "two"
#     'y = obj.one['two']                    --returns "two"
#
#  - supports predicates <attr>? and clear_<attr>? method patterns
#     'obj = PageControls.new({name: "Something", phone: "2604815365"})'
#     'obj.name?'       # => true    true or false, like obj.name.present?
#     'obj.clear_name'  # => nil     sets :name to nil
#
##
# The combination of this NestedResultBase(dot notation class) and AttributeHelpers(hash notation module), produces
# this effect from an input hash:
#
#   {:depth => <select>, ...}  Input Hash                                        Basic dot notation
#   -------------------------  ---------------------------------------          ---------------------------------
#
## (DOES NOT FOLLOW Values)
#   * :single                  - {one: 1,                                         drb.one      = 1
#                                 two: { one: 1,                                  drb.two      = {one: 1, two: 'two}
#                                        two: "two"                               drb.two.two  = NoMethodError
#                                      }, 
#                                 three: [ {one: 'one', two: 2},                  drb.three    = [{one: 'one', two: 2},{three: 'three', four: 4}]
#                                          {three: 'three', four: 4}              drb.three[1] = {three: 'three', four: 4}
#                                        ]                                        drb.three[1].four = NoMethodError
#                                }      
#
## (Follow VALUES that are Hashes only.)
#   * :multi                   - {one: 1,                                         drb.one      = 1
#                                 two: { one: 1,                                  drb.two.one  = 1
#                                        two: "two"                               drb.two.two  = 'two'
#                                      }, 
#                                 three: [ {one: 'one', two: 2},                  drb.three    = [{one: 'one', two: 2},{three: 'three', four: 4}]
#                                          {three: 'three', four: 4}              drb.three[1] = {three: 'three', four: 4}
#                                        ]                                        drb.three[1].four = NoMethodError
#                                }      
#
## (Follow VALUES that are Hashes and/or Arrays of Hashes)
#   * :multi_with_arrays       - {one: 1,                                         drb.one      = 1
#                                 two: { one: 1,                                  drb.two.one  = 1
#                                        two: "two"                               drb.two.two  = 'two'
#                                      }, 
#                                 three: [ {one: 'one', two: 2},                  drb.three.first.one = 'one'
#                                          {three: 'three', four: 4}              drb.three[1].four   = 4
#                                        ]
#                                }      
#
##
# -- SubClassing Usage Examples --
#
# (DOES NOT FOLLOW Values)
#       class SmallPackage < NestedResultBase
#          def initialize(params={})
#            super( params.merge({depth: :single}) )    # override default of :multi level
#          end
#       end
#
# (Follow VALUES that are Hashes only.)
#       class ResultBean < NestedResultBase
#          # defaults to :multi level
#       end
#   -- or --
#       class ResultBean < NestedResultBase
#          def initialize(params={})
#            # your other init stuff here
#            super(params)    # default taken 
#          end
#       end
#   -- or --
#       class ResultBean < NestedResultBase
#          def initialize(params={})
#            # your other init stuff here
#            super( params.merge({depth: :multi}) )    # Specified
#          end
#       end
# ** - or -- enable serialization and default to multi
#       class GenericBean < NestedResultBase
#          def initialize(params={})
#            super( params.merge({enable_serialization: true}) )    # Specified with Serialization Enabled
#          end
#       end
#
# (Follow VALUES that are Hashes and/or Arrays of Hashes, and enable Serializers)
#       class PageControl < NestedResultBase
#          def initialize(params={})
#            super( params.merge({depth: :multi_with_arrays, enable_serialization: true}) )    # override defaults
#          end
#       end
#
##
# NOTE: Cannot be Marshalled/Serialized unless input params.merge({enable_serialization: true}) -- default is false
#       Use GenericBean if serialization is needed, it sets this value to true automatically
##


module SknUtils

  class NestedResultBase
    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON
    include ActiveModel::Serializers::Xml
    include AttributeHelpers

    # :depth controls how deep into input hash/arrays we convert
    # :depth => :single | :multi | :multi_with_arrays 
    # :depth defaults to :multi
    # :enable_serialization controls the use of singleton_method() to preserve the ability to Marshal
    # :enable_serialization defaults to false
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

    def single_level_initializer(params={})   # Single Level Initializer -- ignore value eql hash
      params.each do |k,v|
        key = clean_key(k)
        singleton_class.send(:attr_accessor, key) unless respond_to?(key) or serialization_required?
        instance_variable_set("@#{key}".to_sym,v)
      end
    end

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

    # Some keys have chars not suitable for symbol keys
    def clean_key(original)
      formatted_key = original.to_s
      if /^[#|@|:]/.match(formatted_key)  # filter out (@xsi) from '@xsi:type' keys
        label = /@(.+):(.+)/.match(formatted_key) || /[#|@|:](.+)/.match(formatted_key) || [] 
        formatted_key = case label.size
                          when 1
                            label[1].to_s
                          when 2
                            "#{label[1]}_#{label[2]}"
                          else
                            original  # who knows what it was, give it back
                        end
      end
      formatted_key
    end
  end
end
