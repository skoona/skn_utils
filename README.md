# SknUtils 
Rails Gem containing a Ruby POJO that can be instantiated at runtime with an input hash.  This library creates an Object with instance variables and associated getters and setters for Dot or Hash notational access to each instance variable.  Additional instance variables can be added post-create by 'obj.my_new_var = "some value"', or simply assigning it.  The intent of this component is to be ca container of data results, with easy access to its contents. 

* If the key's value is also a hash itself, it too will become an Object.
* if the key's value is a Array of Hashes, each element of the Array will become an Object.
  
  This nesting action is controlled by the value of the option key ':depth'. 
    The key :depth defaults to :multi, an has options of :single, or :multi_with_arrays
  
  The ability of the resulting Object to be Marshalled(dump/load) can be preserved by merging 
    into the input params key ':enable_serialization' set to true.  It defaults to false for speed purposes
 

### Operational Options
--------------------------------

    :enable_serialization = false     -- [ true | false ], for speed, omits creation of attr_accessor
    :depth = :multi                   -- [ :single | :multi | :multi_with_arrays ]

### Public Components
--------------------------------

    Inherit from NestedResultBase or instantiate an included example:
      SknUtils::GenericBean              # => Serializable, includes attr_accessors, and follows hash values only.
      SknUtils::PageControls             # => Serializable, includes attr_accessors, and follows hash values and arrays of hashes.
      SknUtils::ResultBean               # => Not Serializable, includes attr_accessors, and follows hash values only.
      SknUtils::ResultsBeanWithErrors    # => Same as ResultBean with addition of ActiveModel::Errors object.
    or Include AttributeHelpers          # => Add getter/setters, and hash notation access to instance vars of any object.


## Basic function includes:
```ruby
 - provides the hash or dot notation methods of accessing values from object created; i.e
     'obj = ResultBean.new({value1: "some value", value2: {one: 1, two: "two"}}) 
     'x = obj.value1' or 'x = obj.value2.one'
     'x = obj["value1"]'
     'x = obj[:value1]'

 - enables serialization by avoiding the use of 'singleton_class' methods which breaks Serializers:

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

 - supports predicates <attr>? and clear_<attr>? method patterns:	
    'obj = PageControls.new({name: "Something", phone: "2609998888"})'
    'obj.name?'       # => true    true or false, like obj.name.present?
    'obj.clear_name'  # => nil     sets :name to nil
```

### The combination of this NestedResultBase(dot notation class) and AttributeHelpers(hash notation module), produces
 this effect from an input hash:

    {:depth => <select>, ...}  Input Hash                        Basic dot notation: effect of :depth
    ----------------------------------------------------      ---------------------------------

### (DOES NOT FOLLOW Values) :depth => :single
```ruby
    * params = {one: 1,                                         drb.one      = 1
                two: { one: 1,                                  drb.two      = {one: 1, two: 'two}
                       two: "two"                               drb.two.two  = NoMethodError
                     }, 
                three: [ {one: 'one', two: 2},                  drb.three    = [{one: 'one', two: 2},{three: 'three', four: 4}]
                         {three: 'three', four: 4}              drb.three[1] = {three: 'three', four: 4}
                       ]                                        drb.three[1].four = NoMethodError
               }      
```

### (Follow VALUES that are Hashes only.) :depth => :multi
```ruby
    * params = {one: 1,                                         drb.one      = 1
                two: { one: 1,                                  drb.two.one  = 1
                	   two: "two"                               drb.two.two  = 'two'
                     }, 
                three: [ {one: 'one', two: 2},                  drb.three    = [{one: 'one', two: 2},{three: 'three', four: 4}]
                         {three: 'three', four: 4}              drb.three[1] = {three: 'three', four: 4}
                       ]                                        drb.three[1].four = NoMethodError
	           }
```
 
### (Follow VALUES that are Hashes and/or Arrays of Hashes) :depth => :multi_with_arrays
```ruby
    * params = {one: 1,                                         drb.one      = 1
                two: { one: 1,                                  drb.two.one  = 1
                       two: "two"                               drb.two.two  = 'two'
                     }, 
                three: [ {one: 'one', two: 2},                  drb.three.first.one = 'one'
                		 {three: 'three', four: 4}              drb.three[1].four   = 4
                       ]
               }      
 
```
# Usage Examples: SubClassing 

###(DOES NOT FOLLOW Values)
```ruby
       class SmallPackage < NestedResultBase
          def initialize(params={})
            super( params.merge({depth: :single}) )    # override default of :multi level
          end
       end
```

###(Follow VALUES that are Hashes only.)
```ruby
       class ResultBean < NestedResultBase
          # defaults to :multi level
       end
       
    -- or --
    
       class ResultBean < NestedResultBase
          def initialize(params={})
            # your other init stuff here
            super(params)    # default taken 
          end
       end
       
    -- or --
    
       class ResultBean < NestedResultBase
          def initialize(params={})
            # your other init stuff here
            super( params.merge({depth: :multi}) )    # Specified
          end
       end
       
    ** - or -- enable serialization and default to multi
       class GenericBean < NestedResultBase
          def initialize(params={})
            super( params.merge({enable_serialization: true}) )    # Specified with Serialization Enabled
          end
       end
```

###(Follow VALUES that are Hashes and/or Arrays of Hashes, and enable Serializers)
```ruby
       class PageControl < NestedResultBase
          def initialize(params={})
            super( params.merge({depth: :multi_with_arrays, enable_serialization: true}) )    # override defaults
          end
       end
```


### NOTE: Cannot be Marshalled/Serialized unless input params.merge({enable_serialization: true}) -- default is false
Use GenericBean if serialization is needed, it sets this value to default to true

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'skn_utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skn_utils
    
If your doing this from source then build it first before attempting an install:

    $ gem build skn_utils.gemspec
    
## Contributing

1. Fork it ( https://github.com/skoona/skn_utils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
