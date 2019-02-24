ENV['RAILS_ENV'] = 'test'
ENV['RACK_ENV'] = 'test'

ENV['TEST_GEM'] = 'gem'   # enable SknSettings Gem Mode Testing

require 'bundler/setup'

require 'simplecov'

SimpleCov.start do
  # any custom configs like groups and filters can be here at a central place
  add_filter '/spec/'
end

require 'skn_utils'
require 'rspec'

require 'webmock/rspec'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  Kernel.srand config.seed

  config.order = :random
  config.color = true
  config.tty = false
  config.profile_examples = 10

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # config.disable_monkey_patching!  # -- breaks rspec runtime
  config.warnings = true

  config.include WebMock::API

  if config.files_to_run.one?
    config.formatter = :documentation
  else
    config.formatter = :progress  #:html, :textmate, :documentation
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  
end
