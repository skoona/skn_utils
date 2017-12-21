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
The intent of the NestedResult class is to be a container for data values composed of key/value pairs, 
with easy access to its contents, and on-demand transformation back to the hash (#to_hash).

Review the RSpec tests, and or review the README for more details.
EOF
  spec.post_install_message = <<-EOF
This version includes modified versions of SknUtils::ResultBean, SknUtils::PageControls classes, which inherit from  
SknUtils::NestedResult class.  SknUtils::NestedResult replaces those original classes and consolidates their function.  

Please update your existing code in consideration of the above change, or use the prior version 2.0.6.

Additionally, The gem nokogiri may be manually installed, for non-Rails applications, to enable SknUtils::HashToXml feature.

EOF
  spec.homepage      = "https://github.com/skoona/skn_utils"
  spec.license       = "MIT"
  spec.platform      = Gem::Platform::RUBY
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'deep_merge', '~> 1'

  spec.add_development_dependency "bundler",   "~> 1"
  spec.add_development_dependency "rake",      "~> 10"
  spec.add_development_dependency "rspec",     '~> 3'
  spec.add_development_dependency "pry",       "~> 0"
  spec.add_development_dependency "simplecov", "~> 0"
  spec.add_development_dependency 'benchmark-ips', '~> 2'
  spec.add_development_dependency 'nokogiri',  '~> 1.8'

end
