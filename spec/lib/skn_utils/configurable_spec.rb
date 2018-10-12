##
# spec/lib/skn_utils/configurable_spec.rb
#

class MyApp
  include SknUtils::Configurable.with( :app_id, :title, :cookie_name, enable_root: true) # No options hash defaults to true
  # - and accept defaults for #env=, #root=, and #logger=

  # notice: self.logger=, the self is required when assigning values
  self.logger = Object.new

  configure do
    app_id 'some app'
    title 'My Title'
    cookie_name 'Chocolate'
  end

  def null_value
    @app_id.dup
  end
end

module MyMod
  include SknUtils::Configurable.with(:app_id, :title, :cookie_name,  enable_root: false)

  def self.null_value
    @app_id.dup
  end
end

MyMod.configure do
  app_id 'some module'
  title 'Some Title'
  cookie_name 'Caramel'
end


describe SknUtils::Configurable, "Gem Configuration module." do

  let(:my_app) { MyApp.new }

  context "Top Level AppClass Extra Operational Features. " do

    it "MyApp.env.test? returns expected value. " do
      expect( MyApp.env.test? ).to be true
    end
    it "MyApp.root returns expected value. " do
      expect( MyApp.root.realdirpath.to_s ).to eq( Dir.pwd )
    end
    it "MyApp.logger returns expected value. " do
      expect( MyApp.logger ).to be_instance_of(Object) # eq('No Logger Assigned.')
    end
  end

  context "Module & Class Operational Features. " do

    it "my_app#config.title returns expected value. " do
      expect( MyApp.config.title ).to eq( "My Title" )
    end
    it "my_app#config.app_id returns expected value. " do
      expect( MyApp.config.app_id ).to eq( "some app" )
    end

    it "MyMod#config.app_id  returns expected value. " do
      expect( MyMod.config.app_id ).to eq( "some module" )
    end
    it "MyMod#config.cookie_name returns expected value. " do
      expect( MyMod.config.cookie_name ).to eq( 'Caramel' )
    end

    it "MyMod#logger raises NoMethodError as expected. " do
      expect{ MyMod.logger }.to raise_error(NoMethodError)
    end

  end

end
