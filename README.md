
[![Gem Version](https://badge.fury.io/rb/skn_utils.svg)](http://badge.fury.io/rb/skn_utils)

# SknUtils

`SknUtils` is a collection of pure-ruby utility classes and modules, with limited 
dependencies, to augment the development of Ruby applications.  Examples of these 
utilities in action can be found in my related projects `SknServices`, `SknWebApp`, 
and `SknBase`.

* Most classes are standalone modules, or cleary documented, and can be copy/pasted into your project.
*   The exchange or handoff of values between objects is addressed via the `NestedResults` 
class which implements dot-notation and nesting over a concurrent hash: A ruby Hash can 
use any valid ruby object as a key or value. 
*   `NestedResults` is later sub-classed as `Configuration` to provide application level 
settings using YAML files with a API simular to the RbConfig gem.
*   Object or method return values can be enclosed in `SknSuccess` or `SknFailure` classes 
to prevent or minimize nil returns.
*   Precise microsecond `duration`s, Number to `as_human_size`, and a `catch_exceptions` 
retry-able feature are implemented on the SknUtils class directly for ease of use.
*   `Configurable` module extends any class or module with configurable attribute method 
as needed, with a set of defaults methods which emulate Rails.env, Rails.logger, and 
Rails.root functionality.
*   `CoreObjectExtensions` simular to ActiveSupport's, `#present?` and `#blank?` are 
automatically applied, unless already present, when SknUtils gem is loaded.
*   `SknRegistry` class is an advanced feature which allows you to manually register 
classes, procs, or any value with a user-defined `label`.  Initialization and dependency injection 
requirements of service-like classes can be included in this registration process allowing 
them to be centrally maintained.  The `label` can be any valid ruby value; like a 
classname, symbol, or string as needed
*   `NullObject`, `NotifierBase`, and `Wrappable` are interesting classes which you might want to explore further.
* `ConcurrentJobs` is a feature implemented to allow concurrent/multi-threaded execution of jobs.  The included 
companion classes focus on HTTP GET,PUT,POST, and DELETE jobs as an example of how to use the `ConcurrentJobs` feature. 

All classes and modules have RSpec test coverage (90+) of their originally intended 
use-cases.    


### Available Classes
* SknSettings
    * SknUtils::Configuration
    * SknUtils::EnvStringHandler
* SknHash
    * SknUtils::ResultBean
    * SknUtils::PageControls
    * SknUtils::NestedResult
* SknRegistry
    * SknContainer
* SknSuccess
* SknFailure
* SknUtils::Configurable
* SknUtils::CoreObjectExtensions
* SknUtils::NullObject
* SknUtils::NotifierBase
* SknUtils::Wrappable
* SknUtils::ConcurrentJobs
    * SknUtils::JobWrapper      (via ConcurrentJobs)
    * SknUtils::CommandJSONPost (via JobCommands)
    * SknUtils::CommandFORMPost
    * SknUtils::CommandJSONGet
    * SknUtils::CommandJSONPut
    * SknUtils::CommandFORMDelete
    * SknUtils::HttpProcessor

### Available Class.Methods
* SknUtils.catch_exceptions()
* SknUtils.as_human_size()
* SknUtils.duration(start_time=nil)

### Available RSpec Helpers
* spec/support/xml_matchers.rb
    * expect(bundle).to have_xpath('//witnesses/witness/role')
    * expect(bundle).to have_nodes('//witnesses/witness/role', 3)
    * expect(bundle).to match_xpath('//lossInformation/date', "2020-01-28")
 

## History
    2/3/2020 V5.7.0
    Added
    * RSpec XML_Matchers to spec/support folders
    * Update ConcurrentJobs JobCommands to support HTTP Headers
    
    2/24/2019 V5.5.0
    Added
    * ConcurrentJobs feature set  
    - Executes (HTTP/any) jobs in parallel

    1/2/2019 V5.4.1
    Added
    - Wrappable module for evaluation. 
    - Ruby comment # frozen_string_literal, everywhere
     
    12/16/2018 V5.4.0
    Added :duration() utils to SknUtils module: 
        #duration()            #=> returns start_time value 
        #duration(start_time)  #=> returns elapsed-time as string, "%3.3f seconds"

    11/09/2018 V5.3.0
    Added two utils to SknUtils module: 
        #catch_exceptions(&blk)  #=> catch all exceptions and retry block x times 
        #as_human_size(12345)    #=> 12 KB
    - See related RSpecs

    10/17/2018 V5.1.3
    Enhanced SknUtils::Configurable to include a #registry method/value at its root, like Clas.registry or Class.root
    - Right now these are Class methods only, will update them to survive #new later.

    10/15/2018 V5.1.1
    Enhanced SknSettings to match 95% of the (Rb)Config.gem public API.
    
    10/13/2018 V5.1.0
    Added SknRegistry to handle service and handler registrations.
    - Command.class => CommandHandler.class/instance container
    - Replaces SknContainer

    10/12/2018 V5.0.1
    Added SknSuccess/SknFailure as value object to carry return codes vs exceptions
    Modified Configurable to mimic Rails.env, Rails.root, and Rails.logger

    10/2/2018 V5.0.0
    Modified SknContainer (IoC) to only use #register and #resolve as it's public API.
    - Inspired by: [Andrew Holland](http://cv.droppages.com)

    09/30/2018 V4.0.4
    Updated EnvStringHandler class to behave like Rails.root in all respects.

    02/04/2018 V4.0.2
    Added `bin/install` to copy default settings.yml files to the project's config directory

    02/04/2018 V4.0.0
    Added SknUtils::CoreObjectExtensions, this module contains those popular Rails ActiveSupport extensions like `:present?`.
    - However, it is contructed with the Ruby `:refine` and `using SknUtils::CoreObjectExtensions` constraints, so as not to intefer with existing monkey-patches.
    - Simply add `using SknUtils::CoreObjectExtensions` to any class or module you wish to use the `:present?`, `:blank?`, etc methods.

    01/2018  V3.6.0
    Moved Linked List to my Minimum_Heaps gem.  This repo has a tag of 'lists' documententing the removal
    Removed classes and utils not directly related to NestedResult

    12/2017  V3.5.0
    Made Nokogiri's gem install/load Optional for HashToXml class
    Added SknContainer as a globally namespaced sub-class of NestedResult.  SknContainer is a NestedResult which is functional wrapper over a Concurrent::Hash.  Hashes can use anyObject or anyValue as their key:value pairs.  This makes them perfect for use as a DI Container.
    Added EnvStringHandler class to augment YAML values in an application settings.yml file.  Rails.env.development? becomes SknSettings.env.development? if the following is added to the settings file.
    ./config/settings.yml: `env: !ruby/string:EnvStringHandler <%= ENV['RACK_ENV'] %>`

    09/2017  V3.4.0
    Added HashToXml class which converts complex/simple hashes into XML. pre-req's Nokogiri 1.8.0 or higher, unless Rails present, then uses version included with rails.

    08/2017  V3.3.0
    Added Linked List classes which implement Single, Double, and Circular linked lists patterns.  LinkedLists are implemented
    with method results returning node values or the nodes themselves.

    07/2017  V3.1.5
    Added SknSettings class for use as a replacement to the popular, but obsolete, Config.gem
    SknSettings.load_configuration_basename!(config_file_name-only) or 'Rails.env.to_s' value, will load all the yml files in this order:
    ./config/settings.yml
    ./config/settings/<config_name>.yml
    ./config/settings/<config_name>.local.yml
    I also restored SknUtils:ResultBean and SknUtils::PageControls to the classes contained in this gem.  They are simple wrappers
    inheriting the NestedResult class.  Also added SknHash class as a wrapper without the SknUtils namespace required or exposed

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

### NestedResult class; dynamic key/value container
A class implementing a Ruby PORO (Plain Old Ruby Object) that can be instantiated at runtime with a hash.  Creates
 a nested object with Dot and Hash notational accessors to each key's value.  Additional key/value pairs can be added post-create
 by simply assigning it; `obj.my_new_var = "some value"`

* Transforms the initialing hash into accessible object instance values, with their keys as method names.
* If the key's value is also a hash, it too will become an Object.
* if the key's value is a Array of Hashes, or Array of Arrays of Hashes, each hash element of the Arrays will become an Object.
* The current key/value (including nested) pairs are returned via #to_hash or #to_json when and if needed.
* Best described as dot notation wrapper over a Ruby (Concurrent-Ruby) Hash.

Ruby's Hash object is already extremely flexible, even more so with the addition of dot-notation.  As I work more with Ruby outside of Rails, I'm finding more use cases for the capabilities of this gem.  Here are a few examples:

1. Application settings containers, SknSettings.  Loads Yaml file based on `ENV['RACK_ENV']` value, or specified file-key.
    - Replaces Config and/or RBConfig Gems for yaml based settings
1. Substitute for Rails.root, via a little ERB/YAML/Marshal statement in settings.yml file, and a helper class
    - settings.yml (YAML)
        - `root: <%= Dir.pwd %>`
            - enables `SknSettings.root`
        - `env:  !ruby/string:SknUtils::EnvStringHandler <%= ENV.fetch('RACK_ENV', 'development') %>`
            - enables `SknSettings.env.production?` ...
1. Since SknSettings is by necessity a global constant, it can serve as Session Storage to keep system objects; like a ROM-RB instance.
1. In-Memory Key-Store, use it to cache active user objects, or active Integration passwords, and/or objects that are not serializable.
1. Command registries used to dispatch command requests to proper command handler. see example app [SknBase](https://github.com/skoona/skn_base/blob/master/strategy/services/content/command_handler.rb)
```ruby
    SknSettings.command_handler = {
                            Commands::RetrieveAvailableResources  => method(:resources_metadata_service),
                            Commands::RetrieveResourceContent  => method(:resource_content_service)
                           }
    ...
    SknSettings.command_handler[ cmd.class ].call( cmd )
    -- or --
    SknSettings.command_handler.key?( cmd.class ) && 
      cmd.valid? ? SknSettings.command_handler[ cmd.class ].call( cmd ) : command_not_found_action()
```
There are many more use cases for Ruby's Hash that this gem just makes easier to implement.


## Public Components
    SknUtils::NestedResult           # Primary Key/Value Container with Dot/Hash notiation support.
        SknHash                      # Wrapper for name only, WITHOUT SknUtils namespace, inherits from SknUtils::NestedResult
        SknUtils::ResultBean         # Wrapper for name only, inherits from SknUtils::NestedResult
        SknUtils::PageControls       # Wrapper for name only, inherits from SknUtils::NestedResult
        SknUtils::DottedHash         # Wrapper for name only, inherits from SknUtils::NestedResult

    SknUtils::Configurable           # Basic one-level class configuration Module

    SknSettings                      # Multi-level application Configuration class, Key/Value Container with Dot/Hash notiation support.    

    SknContainer/SknRegistry         # Basic Key/Value container which #registers and #resolves procs, classes, and/or object

    SknSuccess                       # Three attribute value containers for return codes   -- #value, #message, #success
                                       - Extra #payload method returns value as NestResult if value is_a Hash 
    SknFailure                       # Three attribute value containers for return codes   -- #value, #message, #success
    SknUtils::ConcurrentJobs         # Async/Sync Job executor pool with HTTP support
        SknUtils::CommandJSONGet     # HTTP Get Command class expecting `json` return, located inside `job_commands`
        SknUtils::CommandJSONPut     # HTTP Put Command class expecting `json` return, located inside `job_commands`
        SknUtils::CommandJSONPost    # HTTP Post Command class expecting `json` return, located inside `job_commands`
        SknUtils::CommandFORMPost    # HTTP Post Command class expecting `form` data return, located inside `job_commands`
        SknUtils::CommandFORMDelete  # HTTP Delete Command class expecting `form` data return, located inside `job_commands`
        SknUtils::HttpProcessor      # Command driven HTTP processing object supporting GET,PUT,POST, and DELETE
        SknUtils::JobWrapper         # Outer wrapper class to capture catastrophic exceptions (syntax normally)


## Public Methods: SknUtils::Configurable module
 For making an arbitrary class configurable and then specifying those configuration values. 
```ruby
  # (1) First establish the method names of class values desired.
  ################
  # Inside Target component
  ################
  class MyApp
    include SknUtils::Configurable.with(:app_id, :title, :cookie_name) # or {root_enable: false})
    # ... default=true for root|env|logger
  end

  # (2) Set initial values for those class values in a Rails Initializer, or before use.
  ################
  # Inside Initializer
  ################
  MyApp.configure do
    app_id "my_app"
    title "My App"
    cookie_name { "#{app_id}_session" }
  end

  # (2) Or set initial values for those class values when defining the class.
  ################
  # During Definition
  ################
  class MyApp
    include SknUtils::Configurable.with(:app_id, :title, :cookie_name, {root_enable: true})
    # ...
    configure do
      app_id "my_app"
      title "My App"
      cookie_name { "#{app_id}_session" }
    end

    self.logger = Logger.new
    self.env    = ENV.fetch('RACK_ENV', 'development')
    self.root   = Dir.pwd
  end

  # (3) Remember they are class values, use as needed.
  ################
  # Usage:
  ################
  MyApp.config.app_id # ==> "my_app"
  MyApp.logger        # ==> <Logger.class>
  MyApp.registry      # ==> <SknRegistry.instance> or user assigned object
  MyApp.env.test?     # ==> true

  ###############
  # Syntax
  ###############
  # Main Class Attrs  -- defaults
  - root     =  application root directory as Pathname
  - env      =  string value from RACK_ENV
  - registry =  SknRegistry instance
  - logger   =  Assigned Logger instance
  #with(*user_attrs, enable_root: true|false) - defaults to enable of Main Class Attrs
  
  # ##
  # User-Defined Attrs
  # ## 
  MyThing.with(:name1, :name2, ...)
```


## Public Methods: SknRegistry ONLY
    `SknContainer` is global constant assigned to an instantiated instance of `SknRegistry`.
    Returns the keyed value as the original instance/value or if provided a proc the result of calling that proc.
    To register a class or object for global retrieval, use the following API.  Also review the RSpecs for additional useage info.
    
      #register(key, contents = nil, options = {})
        - example: 
            SknContainer.register(:some_klass, MyClass)                   -- class as value
            SknContainer.register(:the_instance, MyClass.new)             -- Object Instance as value 
            SknContainer.register(:unique_instance, -> {MyClass.new})     -- New Object Instance for each #resolve 

            SknContainer                                                  -- #register returns self to enable chaining
                .register(:unique_instance, -> {MyClass.new})
                  .register(:the_instance, MyClass.new)
                    .register(:some_klass, MyClass)    
            
      #resolve(key)
        - example:
            klass  = SknContainer.resolve(:some_klass) 
            instance = SknContainer.resolve(:some_klass).new
            
            obj_instance1 = SknContainer.resolve(:unique_instance) 
            obj_instance2 = SknContainer.resolve(:unique_instance)
            
            same_instance = SknContainer.resolve(:the_instance)

      * Testing Support:
          - #substitute(...) allows you to mock an existing entry. #substitute is an alias for #register_mock              
          - #restore! clears all mocked entries.  #restore! is an alias for #unregister_mock!


## Public Methods: SknUtils::ConcurrentJobs ONLY
    `ConcurrentJobs` behaves as a concurrent thread pool by using Concurrent::Promise from the `concurrent-ruby` gem. 
    Enables the definition of Procs, or any callable class, which will be executed in parrallel the available jobs 
    loaded into ConcurrentJobs.  Meant to reduce user-sensitive response times when multiple APIs must be invoked. 
    Also review the RSpecs for additional useage info.
    
        SknUtils::ConcurrentJobs
           #call(async: true)               - Instantiate ConcurrentJobs with Async Workers, false for Sync Workers
           #register_jobs(cmds, callable)   - Array of Command to be executed by single callable
           #register_job(&block)            - Adds callable block to internal worker queue
           #render_jobs                     - Collect results from all jobs into a Result object
           #elapsed_time_string             - "0.012 seconds" string showing duration of last #render_jobs call
           
           SknUtils::Result                 - Contains individual results from each job executed
              #success?                     - Determines if any job failed
              #messages                     - Retrieves messages from job results, assumed present when job fails
              #values                       - Returns an array of individual results from job executions

    Commands and HttpProcessors are included to demonstrate Job creating patterns.  ConcurrentJobs is not restricted
    to Http calls or the command to command handler pattern.  Using the #register_job method you can pass callable BLOCK
    and it will be executed when #render_jobs is invoked.  HttpProcessor is what I needed and triggered me to add this feature.              
    
    Example here:
```ruby
begin
  # CommandJSONPost, CommandFORMGet, CommandJSONGet,
  # CommandJSONPut, CommandFORMDelete
  commands = [
      SknUtils::CommandJSONGet.call(full_url: "http://jsonplaceholder.typicode.com/posts"),
      SknUtils::CommandJSONGet.call(full_url: "https://jsonplaceholder.typicode.com/comments"),
      SknUtils::CommandJSONGet.call(full_url: "https://jsonplaceholder.typicode.com/todos/1"),
      SknUtils::CommandJSONGet.call(full_url: "http://jsonplaceholder.typicode.com/users")
  ]

  # Initialize the queue with Async Workers by default
  provider = SknUtils::ConcurrentJobs.call

  # Populate WorkQueue
  provider.register_jobs(commands, SknUtils::HttpProcessor) # mis-spelling these params result in an immediate exception (line 43 below)

  # Execute WorkQueue
  result = provider.render_jobs

  if result.success?
    puts "Success: true"
    puts "Values: #{result.values}"
    puts "Messages: #{result.messages}"
  else
    puts "Success: false - errors: #{result.messages.join(', ')}"
    puts "Values: #{result.values}"
  end

#  result.values
rescue => e
  $stderr.puts e.message, e.backtrace
end

```    



## Public Methods: SknSettings ONLY
    SknSettings is a global constant containing an initialized Object of SknUtils::Configuration using defaults
    To change the 'development'.yml default please use the following method early or in the case of Rails in 'application.rb
      #load_config_basename!(config_name) -- Where config_name is the name of yml files stored in the `./config/settings` directory
      #config_path!(path)                 -- Where path format is './<dirs>/', default is: './config/'
                                             and contains a settings.yml file and a 'path/settings/' directory

    Paths ./config must exist.
    Paths ./config/settings/, and ./config/environments/ are optional
    File ./config/settings.yml must exist and contain a valid YAML file structure.
       
    File load/deep_merge sequence:
    -------------------------------------------------
     <prepend-somefile-or-hash>                       -- see #prepend_source!(...)
     config/settings.yml
     config/settings/#{environment}.yml
     config/environments/#{environment}.yml    
     config/settings.local.yml
     config/settings/#{environment}.local.yml
     config/environments/#{environment}.local.yml
     <append-somefile-or-hash>                        -- see #add_source!(...)
    
    
    Public API 
     -------------------------------------------------
     #load_config_basename!(environment_name)          -- self, loads std sequence
     #config_path!(config_root)                        -- self, set config_root for above
     #load_and_set_settings(ordered_filelist)          -- self, sets config_root and loads std sequence
       - Alias: #reload_from_files(ordered_filelist)
     #reload!()                                        -- self, clears and reloads last filelist
     #setting_files(config_root, environment_name)     -- returns ordered filelist
     #add_source!(file_path_or_hash)                   -- self, adds yaml_file or hash to end of filelist (:reload! required)
     #prepend_source!(file_path_or_hash)               -- self, adds yaml_file or hash to start of filelist (:reload! required)
     -------------------------------------------------


## Public Methods: SknUtils::NestedResult, SknHash & SknSettings
    Each concrete Class supports the following utility methods:
      #to_hash                       -- returns a hash of current key/value pairs, including nested
      #to_json                       -- returns a json string of current key/value pairs, including nested
      #hash_from(:base_key)          -- exports the internal hash starting with this base level key
      #obj.obj2.hash_from(:base)     -- exports the internal hash starting from this nested base level key

      #[]                            -- returns value of attr, when #[<attr_name_symbol>]
      #[]=(attr, value)              -- assigns value to existing attr, or creates a new key/value pair
      #<attr>                        -- returns value of named attribute
      #<attr> = (value)              -- assigns value to existing attr, or creates a new key/value pair
      #<attr>?                       -- detects true/false presence? of attr, and non-blank existance of attr's value; when #address?
      -- Where <attr> is a key value from the initial hash, or a key that was/will be dynamically added

      #keys                          -- returns array of symbol #keys from current nested level
      #==(other)                            -- alias to #===
      #===(other)                           -- returns true/false from camparison of the two objects
      #eql?(other)                          -- returns true/false from camparison of the two objects


## NestedResult Basic features include:
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


## NestedResult Usage:

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
*   V5+ None
*   V4+ None
*   V3+ None
*   V2+ None
*   V1+ gem 'active_model', '~> 3.0'


Add this line to your application's Gemfile:
```ruby
gem 'skn_utils'
```


And then execute:
    $ bundle install


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
[2] pry(main)> pg = SknHash.new({sample: [{three: 3, four: 4},{five: 'five', two: 'two'}] })
[3] pry(main)> pg.sample.first.three
[4] pry(main)> rb.sample.first.one
[5] pry(main)> rb.sample.first[:one]
[6] pry(main)> rb.hash_from(:sample)
[7] pry(main)> rb.sample?
[8] pry(main)> rb.sample[0].one?
...
[10] pry(main)> cfg = SknSettings
[11] pry(main)> cfg.config_path!('./spec/factories/')
[12] pry(main)> cfg.load_config_basename!('test')
[13] pry(main)> cfg.keys
[14] pry(main)> cfg.Packaging.keys

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

