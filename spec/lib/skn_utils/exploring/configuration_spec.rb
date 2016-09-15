##
# spec/lib/skn_utils/exploring/configuration_spec.rb
#

describe SknUtils::Exploring::Configuration, "Gem Configuration Module." do


  context "Initializers Feature. " do

    it "#configure can be called without a block." do
      expect( subject.configure ).to be_a(SknUtils::Exploring::Configuration::Options)
    end

    it "#configure can be called with a block." do
      expect( subject.configure() {|c| c.one = 'One'} ).to be_a(SknUtils::Exploring::Configuration::Options)
    end

  end

  context "Runtime Features. " do

    it "#config returns the selected value." do
      subject.config.one = 1
      expect( subject.config.one ).to eq(1)
    end

    it "#config overrides the selected value." do
      subject.config.three = 12
      expect( subject.config.three ).to eq(12)
    end

  end


end
