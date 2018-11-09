##
# spec/lib/skn_utils/as_human_size_spec.rb
#


def as_human_size(number)
  units = %W(Bytes KB MB GB TB PB EB).freeze
  num = number.to_f
  if number < 1001
    num = number
    exp = 0
  else
    max_exp  = units.size - 1
    exp = ( Math.log( num ) / Math.log( 1024 ) ).round
    exp = max_exp  if exp > max_exp
    num /= 1024 ** exp
  end
  ((num > 9 || num.modulo(1) < 0.1) ? '%d %s' : '%.1f %s') % [num, units[exp]]
end



describe 'Number to Human Readable value' do

  context "as_human_size" do
    it 'as_human_size(123)              123 Bytes' do
      expect(as_human_size(123)).to eq "123 Bytes"
    end
    it 'as_human_size(358400)           0.3 MB' do
      expect(as_human_size(358400)).to eq "0.3 MB"
    end
    it 'as_human_size(1234)             1.2 KB' do
      expect(as_human_size(1234)).to eq "1.2 KB"
    end
    it 'as_human_size(12345)             12 KB' do
      expect(as_human_size(12345)).to eq "12 KB"
    end
    it 'as_human_size(1234567890)       1.1 GB' do
      expect(as_human_size(1234567890)).to eq "1.1 GB"
    end
    it 'as_human_size(1234567890123)    1.1 TB' do
      expect(as_human_size(1234567890123)).to eq "1.1 TB"
    end
    it 'as_human_size(1234567)          1.2 MB' do
      expect(as_human_size(1234567)).to eq "1.2 MB"
    end
    it 'as_human_size(483989)           0.5 MB' do
      expect(as_human_size(483989 )).to eq "0.5 MB"
    end
  end

end
