
describe SknFailure, "Result/Response Value Container" do

  let(:default_instance) { described_class.call }

  context "Created without Params" do

    it "Exists. " do
      expect(default_instance).to be
    end

    it "Has default value. " do
      expect(default_instance.value ).to eq "Failure"
    end

    it "Has default status. " do
      expect(default_instance.success ).to be false
    end

    it "Has no default message. " do
      expect(default_instance.message ).to be_empty
    end
  end

  context "Created with Params" do
    it "#success defaults to false. " do
      expect(described_class.call("Testing").success ).to be false
    end

    it "#success accepts input. " do
      expect(described_class.call("Testing", false).success ).to be false
    end

    it "#value defaults to Failure. " do
      expect(described_class.call(nil, false ).value ).to eq "Failure"
    end

    it "#value accepts input. " do
      expect(described_class.call("Don't know why!").value ).to eq "Don't know why!"
    end

    it "#message accepts input. " do
      expect(described_class.call("Don't know why!", false, 'Something Bad Happened!').message ).to eq "Something Bad Happened!"
    end
  end

  context "Supports #(), #call, #new, initialization and Forgives. " do

  it "#(...) is supported. " do
      expect(described_class.('payload', false, "Testing").message ).to eq('Testing')
    end

    it "#call(...) is supported. " do
      expect(described_class.call('payload', false, "Testing").value ).to eq('payload')
    end

    it "#new(...) is supported. " do
      expect(described_class.new('payload', false, "Testing").success ).to be false
    end

    it "Forgives absence of return code input with message. " do
      expect(described_class.('Failure is ... !', 'Forgiveness is Wonderful!').message ).to eq('Forgiveness is Wonderful!')
      expect(described_class.('Failure is ... !', 'Forgiveness is Wonderful!').success ).to be false
    end
  end
end

