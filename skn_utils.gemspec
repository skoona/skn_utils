# frozen_string_literal: true
# coding: utf-8

require_relative 'lib/skn_utils/version'

Gem::Specification.new do |spec|
  spec.name          = 'skn_utils'
  spec.version       = SknUtils::VERSION
  spec.author        = 'James Scott Jr'
  spec.email         = 'skoona@gmail.com'  
  spec.summary       = <<-DESC
Ruby utilities for dependency injection/lookup, class customizations, and dot.notion access over nested hashes.
  DESC
  spec.description   = <<-DESC
Value containers supporting nested dot.notation access over hashes, and utilities offering dependency injection/lookup, and 
language extensions support running in a non-rails environment.  Plus, examples of null objects, class customization, 
and concurrent processing.

Review the RSpec tests, and or review the README for more details.
  DESC

  spec.post_install_message = <<-DESC
This version includes modified versions of SknUtils::ResultBean, SknUtils::PageControls classes, which inherit from  
SknUtils::NestedResult class.  SknUtils::NestedResult replaces those original classes and consolidates their function.  
  DESC

  spec.homepage      = "https://github.com/skoona/skn_utils"
  spec.license       = "MIT"
  spec.platform      = Gem::Platform::RUBY
  spec.files          = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files     = spec.files.grep(%r{^(spec)/})
  spec.require_paths = %w[lib]
  spec.extra_rdoc_files = Dir["README.md", "CODE_OF_CONDUCT.md", "LICENSE"]

  spec.add_runtime_dependency 'deep_merge', '~> 1'
  spec.add_runtime_dependency 'concurrent-ruby', '~> 1'
  spec.add_runtime_dependency 'thor', '~> 0'

  spec.add_development_dependency "bundler",   ">= 1"
  spec.add_development_dependency "rake",      ">= 12.3.3"
  spec.add_development_dependency "rspec",     '>= 3'
  spec.add_development_dependency "pry",       ">= 0"
  spec.add_development_dependency "pry-coolline"
  spec.add_development_dependency "simplecov", ">= 0"
  spec.add_development_dependency 'benchmark-ips', '>= 2'
  spec.add_development_dependency 'webmock'

end
