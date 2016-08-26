##
# spec/lib/skn_utils/action_service_spec.rb
#

RSpec.describe SknUtils::ActionService, "Example Service Object class with command interface." do
  let(:action) {
    SknUtils::ActionService.new('Thingys')
  }

  context "Handles Bad Input. " do
    it "Handles invalid string input params" do
      expect { action.('Samples') }.to output(/Samples/).to_stdout
    end
  end

  context "Single Method Invocations. " do
    it "Handles a call with no param" do
      expect { action.() }.to output(/No Action Taken/).to_stdout
    end
    it "Handles a call with one param" do
      expect { action.(:action_one) }.to output(/Thingys/).to_stdout
    end
    it "Handles a call with more than one param" do
      expect { action.(:action_two, 'Wonderful') }.to output(/Wonderful/).to_stdout
    end
  end

  context "Chaining Method Invocations. " do
    it "Handles calls with no params" do
      expect { action.().() }.to output(/No Action Taken/).to_stdout
    end
    it "Handles a calls with one param" do
      expect { action.(:action_one).(:action_one) }.to output(/Thingys/).to_stdout
    end
    it "Handles a calls with more than one param" do
      expect { action.(:action_two, 'Wonderful').(:action_two, 'Marvelous') }.to output(/Wonderful/).to_stdout
    end
  end

end
