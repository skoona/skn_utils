##
# spec/lib/skn_utils/configurable_spec.rb
#

require "support/configurables"


describe SknUtils::Configurable, "Gem Configuration module." do

  let(:my_app) { MyApp.new }

  context "MyApp: Top Level AppClass Extra Operational Features. " do

    it "MyApp.env.test? returns expected value. " do
      expect( MyApp.env.test? ).to be true
    end
    it "MyApp.root returns expected value. " do
      expect( MyApp.root ).to eq( Dir.pwd )
    end
    it "MyApp.logger returns expected value. " do
      expect( MyApp.logger ).to be_instance_of(Object) # eq('No Logger Assigned.')
    end
    it "MyApp.registry returns expected value. " do
      expect( MyApp.registry ).to be_instance_of(Object)
    end
  end

  context "Module & Class Operational Features. " do

    it "my_app#config.title returns expected value. " do
      expect( MyApp.config.title ).to eq( "My Title" )
      expect( MyApp.config[:title] ).to eq( "My Title" )
    end
    it "my_app#config[:value] accepts and returns expected value. " do
      expect( MyApp.config[:value]="New Attribute" ).to eq( "New Attribute" )
      expect( MyApp.config[:value] ).to eq( "New Attribute" )
    end

    it "MyMod#config.app_id  returns expected value. " do
      expect( MyMod.config.app_id ).to eq( "some module" )
    end
    it "MyMod#config.cookie_name returns expected value. " do
      expect( MyMod.config.cookie_name ).to eq( 'Caramel' )
      expect( MyMod.config[:cookie_name] ).to eq( 'Caramel' )
    end
    it "MyMod#config[:value] accepts and returns expected value. " do
      expect( MyMod.config[:value]="New Attribute" ).to eq( "New Attribute" )
      expect( MyMod.config[:value] ).to eq( "New Attribute" )
    end

    it "MyMod#logger raises NoMethodError as expected. " do
      expect{ MyMod.logger }.to raise_error(NoMethodError)
    end

  end

  context "#config instance vars are accessable as expected. " do

    it "MyApp#null_value to return expected value" do
      expect(my_app.null_value).to eq "some app"
      expect{ MyApp.null_value }.to raise_error(NoMethodError)
    end

    it "MyMod#null_value to return expected value" do
      expect( MyMod.null_value ).to eq "some module"
    end
  end
end
