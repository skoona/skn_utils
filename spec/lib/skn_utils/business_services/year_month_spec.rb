##
# spec/lib/skn_utils/node_based_linked_list_spec.rb
#

RSpec.describe SknUtils::BusinessServices::YearMonth, "Year Month Calculator " do

  let(:basic) { described_class.new(2017, 1) }

  context "Normal Operations " do

    it "No params" do
      expect{described_class.new}.to raise_error(ArgumentError)
    end
    it "With Params" do
      expect(basic).to be_a described_class
    end
    it "#beginning_of month to be correct. " do
      expect(basic.beginning_of).to be_a Time
    end
    it "#end_of month to be correct. " do
      expect(basic.end_of).to be_a Time
    end
    it "#month to equal 3." do
      expect(basic.month).to eq(1)
    end
    it "#year to equal 2017." do
      expect(basic.year).to eq(2017)
    end
    it "#next.month to equal 2." do
      expect(basic.next.month).to eq(2)
    end
    it "Comparisons are correct." do
      expect(described_class.new(2017,1)).to eq(described_class.new(2017,1))
      expect(described_class.new(2017,2)).to be > (described_class.new(2017,1))
      expect(described_class.new(2017,1)).to be < (described_class.new(2017,2))
    end
  end

  context "Range Operations " do

    it "Can be represented in a Range object.  " do
      range = described_class.new(2017, 1)..described_class.new(2017, 9)

      expect(range).to  include(described_class.new(2017, 2))
      expect(range).to  include(described_class.new(2017, 7))
    end
  end

end
