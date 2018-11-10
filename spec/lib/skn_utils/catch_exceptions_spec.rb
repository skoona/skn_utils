##
# spec/lib/skn_utils/catch_exceptions_spec.rb
#


describe SknUtils, 'Catch exceptions and retry block. ' do

  context "#catch_exceptions" do
    it '#catch_exceptions -- good block ' do
      expect(
          described_class.catch_exceptions do
            "good"
          end.value
      ).to eq "good"
    end

    it '#catch_exceptions -- exception block ' do
      expect(
          described_class.catch_exceptions do
            raise NotImplementedError, "Simulate Failures"
          end.value
      ).to include "Simulate Failures"
    end

  end

end
