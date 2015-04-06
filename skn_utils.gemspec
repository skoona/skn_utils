# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skn_utils/version'

Gem::Specification.new do |spec|
  spec.name          = 'skn_utils'
  spec.version       = SknUtils::VERSION
  spec.author        = 'James Scott Jr'
  spec.email         = 'skoona@gmail.com'
  spec.summary       = <<EOF
Ruby convenience utilities, the first being a ResultBean. 


ResultBean is a PORO (Plain Old Ruby Object) which inherits from NestedResultBean class (inlcuded). This class 
is intantiated  via a hash at Ruby/Rails Runtime, allows access to vars via dot or hash notation, 
and is serializable via to_xml, to_hash, and to_json.
EOF

  spec.description   = <<EOF
Creates an PORO Object with instance variables and associated getters and setters for each input key, during runtime.

 
If a key's value is also a hash, it too can optionally become an Object.

 
If a key's value is a Array of Hashes, each element of the Array can optionally become an Object.

  
This nesting action is controlled by the value of the options key ':depth'.  Options key :depth defaults 
to :multi, and has options of :single, :multi, or :multi_with_arrays

  
The ability of the resulting Object to be Marshalled(dump/load) can be preserved by merging configuration options
into the input params key ':enable_serialization' set to true.  It defaults to false for speed purposes.


Review the RSpec tests, and or review the README for more details.
EOF

  spec.homepage      = "https://github.com/skoona/skn_utils"
  spec.license       = "MIT"
  spec.platform      = Gem::Platform::RUBY
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activemodel', '~> 3.2'  
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", '~> 3.0'
  spec.add_development_dependency "pry"
  spec.post_install_message = "Thanks for installing SknUtils, keep watch more utilities will be added!"
end
