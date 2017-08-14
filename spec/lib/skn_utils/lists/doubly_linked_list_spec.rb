##
# spec/lib/skn_utils/doubly_linked_list_spec.rb
#

RSpec.describe SknUtils::Lists::DoublyLinkedList, "Double-Ended LinkedList " do

  context "Initialization" do
    it "can be initialized without params" do
      expect(subject).to be
    end
    it "can insert the first value" do
      expect(subject.empty?).to be true
      expect(subject.insert(101)).to eq(1)
    end
    it "can be cleared" do
      subject.insert(101)
      expect(subject.clear).to eq(1)
    end
    it "can be initialized with one or more initial values" do
      list = described_class.new(10,100,100)
      expect(list.current).to eq(10)
    end
    it "is initially empty?" do
      expect(subject.empty?).to be true
    end
  end

  context "Navigation" do
    let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }

    it "#first returns the first value" do
      expect(list.first).to eq(10)
    end
    it "#next returns the second value" do
      expect(list.first).to eq(10)
      expect(list.next).to eq(20)
    end
    it "#current returns the first value" do
      expect(list.current).to eq(10)
    end
    it "#prev returns the prior value" do
      expect(list.prev).to eq(10)
    end
    it "#last returns the last value" do
      expect(list.last).to eq(100)
    end
    it "#nth(6) returns the sixth value" do
      expect(list.first).to eq(10)
      expect(list.nth(6)).to eq(60)
      expect(list.nth(-2)).to eq(40)
    end
    it "#at_index(6) returns the sixth value" do
      expect(list.at_index(6)).to eq(60)
    end

  end
  context "Insertions" do
    it "#insert(value) indicates a value was added" do
      bsize = subject.size
      expect(subject.insert(110)).to eq(bsize + 1)
    end
    it "#prepend(value) indicates a value was added" do
      bsize = subject.size
      expect(subject.prepend(110)).to eq(bsize + 1)
    end
    it "#append(value) indicates a value was added" do
      bsize = subject.size
      expect(subject.append(110)).to eq(bsize + 1)
    end
    it "#insert_before(pvalue,value) indicates a value was added" do
      subject.insert(120)
      bsize = subject.size
      expect(subject.insert_before(120, 110)).to eq(bsize + 1)
      expect(subject.to_a).to eq([110,120])
    end
    it "#insert_after(value) indicates a value was added" do
      subject.insert(120)
      bsize = subject.size
      expect(subject.insert_after(120, 125)).to eq(bsize + 1)
      expect(subject.to_a).to eq([120,125])
    end
  end

  context "Removals" do
    let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }

    it "#remove(value) removes first occurance of that value" do
      bsize = list.size
      expect(list.remove(30)).to eq(bsize - 1)
      expect(list.to_a).to eq([10,20, 40, 50, 60, 70, 80, 90, 100])
    end

    it "#clear removes all elements from list" do
      expect(list.clear).to eq(10)
      expect(list.empty?).to be true
    end
  end

  context "Enumeration" do
    let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }
    it "#each works as expected when block is provided" do
      x = []
      list.each {|r| x << r}
      expect(x).to be_a(Array)
      expect(x).to eq([10,20, 30, 40, 50, 60, 70, 80, 90, 100])
    end
    it "#each works as expected when no block is offered" do
      expect(list.each).to be_a(Enumerator)
      expect(list.each.first).to eq(10)
    end
    it "#to_a returns the contents of linkedlist as an Array" do
      base = list.to_a
      expect(base).to be_a(Array)
      expect(base).to eq([10,20, 30, 40, 50, 60, 70, 80, 90, 100])
    end
  end

  context "Edge cases " do
    let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }

    it "#at_index(-999) fails and returns the current element. " do
      expect(list.at_index(-999)).to eq(10)
    end
    it "#at_index(0) fails and returns the current element. " do
      expect(list.at_index(0)).to eq(10)
    end
    it "#at_index(999) fails and returns the current element. " do
      expect(list.at_index(999)).to eq(10)
    end
    it "#at_index(n) returns the proper element. " do
      expect(list.at_index(1)).to eq(10)
      expect(list.at_index(list.size / 2)).to eq(50)
      expect(list.at_index(list.size)).to eq(100)
    end
    it "#at_index(n) returns the proper element for linkedlist with one element. " do
      only = described_class.new(55)
      expect(only.at_index(1)).to eq(55)
      expect(only.at_index(10)).to eq(55)
      expect(only.at_index(-10)).to eq(55)
    end

    it "#nth(-999) returns first initialization value." do
      expect(list.nth(-999)).to eq(10)
    end
    it "#nth(0) returns current value, or last initialization value." do
      expect(list.nth(0)).to eq(10)
    end
    it "#nth(999) returns last initialization value." do
      expect(list.nth(999)).to eq(100)
    end
    it "#current equals first initialization value." do
      expect(list.current).to eq(10)
    end
    it "#next after initialization equals last initialization value. " do
      expect(list.next).to eq(20)
      expect(list.next).to eq(30)
      expect(list.next).to eq(40)
    end
    it "#prev after first returns first value repeatably. " do
      expect(list.first).to eq(10)
      expect(list.prev).to eq(10)
      expect(list.prev).to eq(10)
    end
    it "#first, #next, #current, #prev, #nth, and #last return same value after initialization with one value. " do
      only = described_class.new(55)
      expect(only.first).to eq(55)
      expect(only.next).to eq(55)
      expect(only.prev).to eq(55)
      expect(only.last).to eq(55)
      expect(only.current).to eq(55)
      expect(only.nth(1)).to eq(55)
      expect(only.nth(11)).to eq(55)
    end
    it "#first, #next, #current, #prev, #nth, and #last return same value after initialization with no values. " do
      only = described_class.new
      expect(only.first).to be nil
      expect(only.next).to be nil
      expect(only.prev).to be nil
      expect(only.last).to be nil
      expect(only.current).to be nil
      expect(only.nth(1)).to be nil
      expect(only.nth(-1)).to be nil
    end
    it "#prepend enables navigation methods normal operations. " do
      only = described_class.new
      only.prepend(55)
      expect(only.first).to eq(55)
      expect(only.next).to eq(55)
      expect(only.prev).to eq(55)
      expect(only.last).to eq(55)
      expect(only.current).to eq(55)
      expect(only.nth(1)).to eq(55)
      expect(only.nth(11)).to eq(55)
    end
    it "#append enables navigation methods normal operations. " do
      only = described_class.new
      only.append(55)
      expect(only.first).to eq(55)
      expect(only.next).to eq(55)
      expect(only.prev).to eq(55)
      expect(only.last).to eq(55)
      expect(only.current).to eq(55)
      expect(only.nth(1)).to eq(55)
      expect(only.nth(11)).to eq(55)
    end
    it "#insert_before enables navigation methods normal operations. " do
      only = described_class.new
      only.insert_before(nil, 55)
      expect(only.first).to eq(55)
      expect(only.next).to eq(55)
      expect(only.prev).to eq(55)
      expect(only.last).to eq(55)
      expect(only.current).to eq(55)
      expect(only.nth(1)).to eq(55)
      expect(only.nth(11)).to eq(55)
    end
    it "#insert_after enables navigation methods normal operations. " do
      only = described_class.new
      only.insert_after(nil, 55)
      expect(only.first).to eq(55)
      expect(only.next).to eq(55)
      expect(only.prev).to eq(55)
      expect(only.last).to eq(55)
      expect(only.current).to eq(55)
      expect(only.nth(1)).to eq(55)
      expect(only.nth(11)).to eq(55)
    end
    it "#remove does not make navigation methods unstable if only element. " do
      only = described_class.new(55)
      only.remove(55)
      expect(only.first).to be nil
      expect(only.next).to be nil
      expect(only.prev).to be nil
      expect(only.last).to be nil
      expect(only.current).to be nil
      expect(only.nth(1)).to be nil
      expect(only.nth(-1)).to be nil
    end

  end

end
