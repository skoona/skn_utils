##
# spec/support/configurables.rb
#

class MyApp
  include SknUtils::Configurable.with( :app_id, :title, :cookie_name, enable_root: true) # No options hash defaults to true
  # - and accept defaults for #env=, #root=, #registry=, and #logger=

  # notice: self.logger=, the self is required when assigning values
  self.logger = Object.new
  self.registry = Object.new

  configure do
    app_id 'some app'
    title 'My Title'
    cookie_name 'Chocolate'
  end

  def null_value
    self.class.config.app_id.dup
  end
end

module MyMod
  include SknUtils::Configurable.with(:app_id, :title, :cookie_name,  enable_root: false)

  def self.null_value
    config.app_id.dup
  end
end

MyMod.configure do
  app_id 'some module'
  title 'Some Title'
  cookie_name 'Caramel'
end
