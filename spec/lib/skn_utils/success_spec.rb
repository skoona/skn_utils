
describe SknSuccess, "Result/Response Value Container" do

  let(:default_instance) { described_class.call }

  context "Created without Params" do

    it "Exists. " do
      expect(default_instance).to be
    end

    it "Has default value " do
      expect(default_instance.value ).to eq "Success"
    end

    it "Has default status " do
      expect(default_instance.success ).to be true
    end

    it "Has no default message. " do
      expect(default_instance.message ).to be_empty
    end
  end

  context "Created with Params" do
    it "#success defaults to true. " do
      expect(described_class.call("Testing").success ).to be true
    end

    it "#success accepts input. " do
      expect(described_class.call("Testing", true).success ).to be true
    end

    it "#value defaults to Success. " do
      expect(described_class.call(nil, true).value ).to eq "Success"
    end

    it "#value accepts input. " do
      expect(described_class.call({some: :hash}).value ).to be_a Hash
      expect(described_class.call("Success is Wonderful!").value ).to eq "Success is Wonderful!"
    end

    it "#message accepts input. " do
      expect(described_class.call("Success is Wonderful!", true, 'Something Good Happened!').message ).to eq "Something Good Happened!"
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
      expect(described_class.new('payload', false, "Testing").success ).to be true
    end

    it "Forgives absence of return code input with message. " do
      expect(described_class.('Success is ... !', 'Forgiveness is Wonderful!').message ).to eq('Forgiveness is Wonderful!')
      expect(described_class.('Success is ... !', 'Forgiveness is Wonderful!').success ).to be true
    end
  end
end

