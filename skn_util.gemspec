# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skn_util/version'

Gem::Specification.new do |spec|
  spec.name          = "skn_util"
  spec.version       = SknUtil::VERSION
  spec.authors       = ["James Scott Jr"]
  spec.email         = ["skoona@gmail.com"]
  spec.summary       = %q{ResulBean class initialized by input Hash, allows access via dot or hash notation.}
  spec.description   = %q{ResulBean class initialized by input Hash, allows access via dot or hash notation.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activemodel', '~> 3.2'  
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", '~> 3.0'
end
