##
# spec/lib/skn_utils/as_human_size_spec.rb
#


describe SknUtils, 'Number to Human Readable value' do

  context "#as_human_size" do
    it '#as_human_size(123)              123 Bytes' do
      expect(described_class.as_human_size(123)).to eq "123 Bytes"
    end
    it '#as_human_size(358400)           0.3 MB' do
      expect(described_class.as_human_size(358400)).to eq "0.3 MB"
    end
    it '#as_human_size(1234)             1.2 KB' do
      expect(described_class.as_human_size(1234)).to eq "1.2 KB"
    end
    it '#as_human_size(12345)             12 KB' do
      expect(described_class.as_human_size(12345)).to eq "12 KB"
    end
    it '#as_human_size(1234567890)       1.1 GB' do
      expect(described_class.as_human_size(1234567890)).to eq "1.1 GB"
    end
    it '#as_human_size(1234567890123)    1.1 TB' do
      expect(described_class.as_human_size(1234567890123)).to eq "1.1 TB"
    end
    it '#as_human_size(1234567)          1.2 MB' do
      expect(described_class.as_human_size(1234567)).to eq "1.2 MB"
    end
    it '#as_human_size(483989)           0.5 MB' do
      expect(described_class.as_human_size(483989 )).to eq "0.5 MB"
    end
  end

end
