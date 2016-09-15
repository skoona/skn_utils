ENV['RAILS_ENV'] ||= 'test'

require 'skn_utils'
require 'skn_utils/exploring/commander'
require 'skn_utils/exploring/action_service'
require 'skn_utils/exploring/configuration'

require 'rspec'
require 'yaml'

# Shared Examples and Support Routines
Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  Kernel.srand config.seed

  config.order = :random
  config.color = true
  config.tty = false

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # config.disable_monkey_patching!  # -- breaks rspec runtime
  config.warnings = true

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
