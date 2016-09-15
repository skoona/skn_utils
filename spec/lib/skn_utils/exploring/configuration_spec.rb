##
# spec/lib/skn_utils/exploring/configuration_spec.rb
#

describe "Gem Configuration Example." do

  let!(:subject) { SknUtils::Exploring::Configuration }


  context "Initializers Feature. " do
    before(:each) do
      subject.reset!
    end

    it "#configure can be called without a block." do
      expect( subject.configure ).to be_a(SknUtils::Exploring::Configuration::Options)
    end

    it "#configure can be called with a block." do
      expect( subject.configure() {|c| c.one = 'One'} ).to be_a(SknUtils::Exploring::Configuration::Options)
    end

    it "#reset! allows new defaults to be applied." do
      subject.option_defaults = {four: 4, five: 5, six: 6}
      subject.reset!
      expect( subject.config.five ).to eq(5)
      subject.option_defaults = nil # remove prior defaults
      subject.reset!
      expect( subject.config.one ).to eq(1)
    end

  end

  context "Runtime Features. " do
    before(:each) do
      subject.reset!
    end

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
