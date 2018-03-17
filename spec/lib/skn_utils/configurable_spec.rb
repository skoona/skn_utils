##
# spec/lib/skn_utils/exploring/configuration_spec.rb
#

class MyApp
  include SknUtils::Configurable.with(:app_id, :title, :cookie_name)

  def null_value
    @app_id.dup
  end
end

module MyMod
  include SknUtils::Configurable.with(:app_id, :title, :cookie_name)

  def self.null_value
    @@app_id.dup
  end
end

MyApp.configure do
       app_id 'some app'
        title 'My Title'
  cookie_name 'Chocolate'
end

MyMod.configure do
       app_id 'some module'
        title 'Some Title'
  cookie_name 'Caramel'
end


describe SknUtils::Configurable, "Gem Configuration module." do

  let(:my_app) { MyApp.new }


  context "Operational Features. " do

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

  end

end
