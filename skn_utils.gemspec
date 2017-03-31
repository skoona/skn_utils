# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skn_utils/version'

Gem::Specification.new do |spec|
  spec.name          = 'skn_utils'
  spec.version       = SknUtils::VERSION
  spec.author        = 'James Scott Jr'
  spec.email         = 'skoona@gmail.com'  
  spec.summary       = <<-EOF
SknUtils contains a small collection of Ruby utilities, the first being a NestedResult a key/value container.
EOF

  spec.description   = <<-EOF
The intent of the NestedResult class is to be a container of data results or key/value pairs, 
with easy access to its contents, and on-demand transformation back to the hash (#to_hash).

Review the RSpec tests, and or review the README for more details.
EOF
  spec.post_install_message = <<-EOF
This version does not include ResultBean, PageControls, or ValueBean classes.  
SknUtils::NestedResult class replaces those original classes and their function.  

Please update your existing code to make the above change or use the prior version 2.0.7
EOF
  spec.homepage      = "https://github.com/skoona/skn_utils"
  spec.license       = "MIT"
  spec.platform      = Gem::Platform::RUBY
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]
  
  spec.add_development_dependency "bundler", ">= 0"
  spec.add_development_dependency "rake", ">= 0"
  spec.add_development_dependency "rspec", '~> 3.0'
  spec.add_development_dependency "pry", ">= 0"
  spec.add_development_dependency "simplecov", ">= 0"

  ## Make sure you can build the gem on older versions of RubyGems too:
  spec.rubygems_version = "1.6.2"
  spec.required_rubygems_version = Gem::Requirement.new(">= 0") if spec.respond_to? :required_rubygems_version=
  spec.required_ruby_version = '~> 2.0'
  spec.specification_version = 3 if spec.respond_to? :specification_version  
end
