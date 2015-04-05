# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skn_utils/version'

Gem::Specification.new do |spec|
  spec.name          = "skn_utils"
  spec.version       = SknUtils::VERSION
  spec.authors       = ["James Scott Jr"]
  spec.email         = ["skoona@gmail.com"]
  spec.summary       = %q{NestedResultBean class initialized by input Hash, allows access via dot or hash notation, and serializable via to_xml, to_hash, and to_json.}
  spec.description   = %q$#Creates an Object with instance variables and associated getters and setters for hash each input key, during runtime. 
* If a key's value is also a hash itself, it too will become an Object.
* If a key's value is a Array of Hashes, each element of the Array will become an Object.
  
  This nesting action is controlled by the value of the option key ':depth'. 
    The key :depth defaults to :multi, an has options of :single, or :multi_with_arrays
  
  The ability of the resulting Object to be Marshalled(dump/load) can be preserved by merging 
    into the input params key ':enable_serialization' set to true.  It defaults to false for speed purposes
 

## Operational Options
--------------------------------
  :enable_serialization = false     -- [ true | false ], for speed, omits creation of attr_accessor
  :depth = :multi                   -- [ :single | :multi | :multi_with_arrays ]

## Public Components
--------------------------------
  Inherit from NestedResultBase or instantiate
      SknUtils::GenericBean
      SknUtils::PageControls
      SknUtils::ResultBean
      SknUtils::ResultsBeanWithErrors
  or Include AttributeHelpers


## Basic function includes:
   - provides the hash or dot notation methods of accessing values from object created; i.e
      'obj = ResultBean.new({value1: "some value", value2: {one: 1, two: "two"}}) 
     'x = obj.value1' or 'x = obj.value2.one'
     'x = obj["value1"]'
     'x = obj[:value1]'

   - enables serialization by avoiding the use of 'singleton_class' methods which breaks Serializers
    Serializer supports xml, json, hash, and standard Marshall'ing

    person = PageControls.new({name: "Bob"})
    person.attributes          # => {"name"=>"Bob"}
    person.serializable_hash   # => {"name"=>"Bob"}
    person.to_hash             # => {"name"=>"Bob"}
    person.to_json             # => "{\"name\":\"Bob\"}"
    person.to_xml              # => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<page-controls>\n  <name>Bob</name>\n</page-controls>\n"
    dmp = Marshal.dump(person) # => "\x04\bo:\x1ASknUtils::PageControls\x06:\n@nameI\"\bBob\x06:\x06ET"
    person = Marshal.load(dmp) # => #<SknUtils::PageControls:0x007faede906d40 @name="Bob">

    ***GenericBean designed to automatically handle the setup for serialization and multi level without arrays 

   - post create additions:
     'obj = ResultBean.new({value1: "some value", value2: {one: 1, two: "two"}}) 
     'x = obj.one'                          --causes NoMethodError
     'x = obj.one = 'some other value'      --creates a new instance value with accessors
     'x = obj.one = {key1: 1, two: "two"}'  --creates a new ***bean as the value of obj.one
     'y = obj.one.two'                      --returns "two"
     'y = obj.one[:two]                     --returns "two"
     'y = obj.one['two']                    --returns "two"

   - supports predicates <attr>? and clear_<attr>? method patterns
     'obj = PageControls.new({name: "Something", phone: "2604815365"})'
     'obj.name?'       # => true    true or false, like obj.name.present?
     'obj.clear_name'  # => nil     sets :name to nil
$
  spec.homepage      = "https://github.com/skoona/skn_utils"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activemodel', '~> 3.2'  
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", '~> 3.0'
  spec.add_development_dependency "pry"
end
