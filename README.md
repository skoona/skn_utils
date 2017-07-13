
[![Gem Version](https://badge.fury.io/rb/skn_utils.svg)](http://badge.fury.io/rb/skn_utils)

# SknUtils
#### SknUtils::NestedResult class; dynamic key/value container
The intent of this gem is to be a container of data results or key/value pairs, with easy access to its contents, and on-demand transformation back to the hash (#to_hash).

Ruby Gem containing a Ruby PORO (Plain Old Ruby Object) that can be instantiated at runtime with an input hash.  This library creates
 an Object with Dot or Hash notational accessors to each key's value.  Additional key/value pairs can be added post-create
 by 'obj.my_new_var = "some value"', or simply assigning it.

* Transforms the initializating hash into accessible object instance values, with their keys as method names.
* If the key's value is also a hash, it too will become an Object.
* if the key's value is a Array of Hashes, or Array of Arrays of Hashes, each element of the Arrays will become an Object.
* The current key/value (including nested) pairs are returned via #to_hash or #to_json when and if needed.


## New Features
    07/2017  V3.1.4
    Added SknSettings class for use as a replacement to the popular, but obsolete, Config.gem
    SknSettings.load_configuration_basename!(config_file_name-only) or 'Rails.env.to_s' value, will load all the yml files in this order:
    ./config/settings.yml
    ./config/settings/<name>.yml
    ./config/settings/<name>.local.yml
    and deep_merge the results.  Ya might have to add this gem statement to your Rails Application GemFile.
                 gem 'deep_merge', '~> 1.1', :require => 'deep_merge/rails_compat'
    I also restored SknUtils:ResultBean and SknUtils::PageControls to the classes contained in this gem.  They are simple wrappers
    inheriting the NestedResult class.

    03/2017  V3.0.0
    Added SknUtils::NestedResult to replace, or be an alternate, to ResultBean, GenericBean, PageControls, ValueBean, and AttributeHelper.
    NestedResult overcome issues with serialization via Marshal and Yaml/Psych.
    NestedResult will properly encode all hash based key/value pairs of input and decodes it via #to_h or #to_json
    NestedResult encodes everything given no matter how deeply its nested, unlike the prior version where you had control over nesting.

    10/2016  V2.0.6  
    Added an SknUtils::NullObject and SknUtils::nullable?(value) extracted from [Avdi Grimm's Confident Code](https://gist.github.com/jschoolcraft/979827)
    The NullObject class has great all around utility, check out it's specs!        

    08/2016  V2.0.3  
    Added an exploritory ActionService class and RSpec test, triggered by reading [Kamil Lelonek](https://blog.lelonek.me/what-service-objects-are-not-7abef8aa2f99#.p64vudxq4)
    I don't support his approach, but the CreateTask class caught my attention as a Rubyist.        

    12/2015  V2.0  
	All references to ActiveRecord or Rails has been removed to allow use in non-Rails environments
    as a result serialization is done with standard Ruby Hash serialization methods; by first transforming
    object back to a hash using its #to_hash method. 

	06/2015  V1.5.1 commit #67ef656
	Last Version to depend on Rails (ActiveModel) for #to_json and #to_xml serialization


## Configuration Options
    None required other than initialization hash


## Public Methods
    Each concrete Class supports the following utility methods:
      #to_hash                       -- returns a hash of current key/value pairs, including nested
      #to_json                       -- returns a json string of current key/value pairs, including nested
      #hash_from(:base_key)          -- exports the internal hash starting with this base level key
      #obj.obj2.hash_from(:base)     -- exports the internal hash starting from this nested base level key
      #[]                            -- returns value of attr, when #[<attr_name_symbol>]
      #[]=(attr, value)              -- assigns value to existing attr, or creates a new key/value pair
      #<attr>?                       -- detects true/false presence? of attr, and non-blank existance of attr's value; when #address?
      #<attr>                        -- returns value of named attribute
      #<attr> = (value)              -- assigns value to existing attr, or creates a new key/value pair
      -- Where <attr> is a key value from the initial hash, or a key that was/will be dynamically added      



## Public Components
    SknUtils::NestedResult                # >= V 3.0.0 Primary Key/Value Container with Dot/Hash notiation support.


    *** <= V 2.0.6 Depreciated, HAS been removed ***

    Inherit from NestedResultBase or instantiate an pre-built Class:
      SknUtils::ResultBean                # => Not Serializable and follows hash values only.
      SknUtils::PageControls              # => Serializable and follows hash values and arrays of hashes.
      SknUtils::GenericBean               # => Serializable and follows hash values only.
      SknUtils::ValueBean                 # => Serializable and DOES NOT follows hash values.
    or Include SknUtils::AttributeHelpers # => Adds getter/setters, and hash notation access to instance vars of any object.


## Basic features include:
```ruby
 - provides the hash or dot notation methods of accessing values:

     $ obj = SknUtils::NestedResult.new({value1: "some value", value2: {one: 1, two: "two"}})
     $ x = obj.value1
     $ x = obj.value2.one
     $ x = obj["value1"]
     $ x = obj[:value1]

 - enables serialization:
    Internally supports #to_hash and #to_json

    $ person = SknUtils::NestedResult.new({name: "Bob"})
    $ person.to_hash             # => {"name"=>"Bob"}
    $ person.to_json             # => "{\"name\":\"Bob\"}"
    $ dmp = Marshal.dump(person) # => "\x04\bo:\x1ASknUtils::NestedResult\x06:\n@nameI\"\bBob\x06:\x06ET"
    $ person2 = Marshal.load(dmp) # => #<SknUtils::NestedResult:0x007faede906d40 @name="Bob">

 - post create additions:

    'obj = SknUtils::NestedResult.new({value1: "some value", value2: {one: 1, two: "two"}})
    'x = obj.one'                          --causes NoMethodError
    'x = obj.one = 'some other value'      --creates a new instance value with accessors
    'x = obj.one = {key1: 1, two: "two"}'  --creates a new ***bean as the value of obj.one
    'y = obj.one.two'                      --returns "two"
    'y = obj.one[:two]                     --returns "two"
    'y = obj.one['two']                    --returns "two"

 - supports predicates <attr>? method patterns:  target must exist and have a non-empty/valid value

    $ obj = SknUtils::NestedResult.new({name: "Something", active: false, phone: "2609998888"})'
    $ obj.name?'       # => true         -- true or false, like obj.name.present?
    $ obj.active?      # => true         -- your asking if method exist with a valid value, not what the value is!
    $ obj.street?      # => false
```


## Usage:

* The NestedResult produces these effects when given a params hash;
* Follow VALUES that are Hashes, Arrays of Hashes, and Arrays of Arrays of Hashes
```ruby
    drb = SknUtils::NestedResult.new(params)                          Basic dot notation:
    ----------------------------------------------------      -----------------------------------------------------------------

    * params = {one: 1,                                         drb.one      = 1
                two: { one: 1, two: "two"},                     drb.two      = <SknUtils::NestedResult>
                                                                drb.two.two  = 'two'

                three: [ {one: 'one', two: 2},                  drb.three.first.one  = 'one'
                         {three: 'three', four: 4}              drb.three[1].four = 4
                       ],                                       drb.three.last.three = 'three'

                four: [
                        [ {one: 'one', two: 2},                 drb.four.first.first.one  = 'one'
                          {three: 'three', four: 4} ],          drb.four.first.last.four = 4
                        [ { 5: 'five', 6: 'six'},               drb.four[1][0][5] = 'five'     # number keys require hash notation :[]
                          {five: '5', six: 6} ]                 drb.four[1].last.six = 6
                      ],
           'five' => [1, 2, 3]                                  drb.five = [1, 2, 3]
                6 => 'number key'                               drb[6] = 'number key'
               }      
```

* Expected usage
```ruby
       result =  SknUtils::NestedResult.new({
                           success: true,
                           message: "",
                           payload: {package: 'of key/value pairs from operations'}
       })
       ...

       if result.success && result.payload.package?
        # do something with result.payload
       end
```


* Wrap additional methods around the core NestedResult feature set
```ruby
       class MyPackage < SknUtils::NestedResult
          def initialize(params={})
            super
          end

          def additional_method
            # do something
          end
       end
```


## Installation

runtime prereqs: 
    V3+ None
    V2+ None
    V1+ gem 'active_model', '~> 3.0'


Add this line to your application's Gemfile:
```ruby
gem 'skn_utils'
```


And then execute:
    $ bundle


Or install it yourself as:
    $ gem install skn_utils


## Build    

1. $ git clone git@github.com:skoona/skn_utils.git
2. $ cd skn_utils
3. $ gem install bundler
4. $ bundle install
5. $ bundle exec rspec
6. $ gem build skn_utils.gemspec
7. $ gem install skn_utils
* Done


## Console Workout    

Start with building gem first.
```bash    
$ cd skn_utils
$ bin/console

[1] pry(main)> rb = SknUtils::NestedResult.new({sample: [{one: "one", two: "two"},{one: 1, two: 2}] })
[2] pry(main)> pg = SknUtils::NestedResult.new({sample: [{three: 3, four: 4},{five: 'five', two: 'two'}] })
[3] pry(main)> pg.sample.first.three
[4] pry(main)> rb.sample.first.one
[5] pry(main)> rb.sample.first[:one]
[6] pry(main)> rb.hash_from(:sample)
[7] pry(main)> rb.sample?
[8] pry(main)> rb.sample[0].one?
    
[n] pry(main)> exit
* Done
```
    
## Contributing

1. Fork it 
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

