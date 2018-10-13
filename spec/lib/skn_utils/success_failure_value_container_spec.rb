# ##
# Test both classes in this file


shared_examples "a response value" do

  let(:default_instance) { described_class.call }
  let(:success_returned) { default_instance.instance_of?(SknSuccess) ? true : false }
  let(:default_value) { described_class.name.to_s[3..-1] }

  context "Created without Params" do

    it "Exists. " do
      expect(default_instance).to be
    end

    it "Has default value. " do
      expect(default_instance.value ).to eq default_value
    end

    it "Has default status. " do
      expect(default_instance.success ).to be success_returned
    end

    it "Has no default message. " do
      expect(default_instance.message ).to be_empty
    end
  end

  context "Created with Params" do
    it "#success defaults to false. " do
      expect(described_class.call("Testing").success ).to be success_returned
    end

    it "#success accepts input. " do
      expect(described_class.call("Testing", nil, !success_returned).success ).to be !success_returned
    end

    it "#value defaults to properly. " do
      expect(described_class.call(nil, nil, false ).value ).to eq default_value
    end

    it "#value accepts input. " do
      expect(described_class.call("Don't know why!").value ).to eq "Don't know why!"
    end

    it "#message accepts input. " do
      expect(described_class.call("Don't know why!", 'Something Happened!', false ).message ).to eq "Something Happened!"
    end

    it "#payload returns value as expected. " do
      expect(described_class.call("Don't know why!", 'Something Happened!').payload ).to eq "Don't know why!"
    end
  end

  context "Supports #(), #call, #new, initialization and Forgives. " do

    it "#(...) is supported. " do
      expect(described_class.('payload', "Testing", false ).message ).to eq('Testing')
    end

    it "#call(...) is supported. " do
      expect(described_class.call('payload', "Testing", false ).value ).to eq('payload')
    end

    it "#new(...) is supported. " do
      expect(described_class.new('payload', "Testing", false ).success ).to be false
    end

    it "Forgives absence of return code input with message. " do
      expect(described_class.('Trying Hard ... !', 'Forgiveness is Wonderful!').message ).to eq('Forgiveness is Wonderful!')
      expect(described_class.('Trying Hard ... !', 'Forgiveness is Wonderful!').success ).to be success_returned
    end
  end

end


describe SknFailure, "Failure Result Value Container" do
  it_behaves_like "a response value"
end

describe SknSuccess, "Success Result Value Container" do
  it_behaves_like "a response value"
end

