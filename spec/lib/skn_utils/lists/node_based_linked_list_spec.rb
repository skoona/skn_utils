##
# spec/lib/skn_utils/node_based_linked_list_spec.rb
#

RSpec.describe SknUtils::Lists::DoublyLinkedList, "DoublyLinkedList using node interface " do

  context "Node Interface Edge Cases " do
    let(:list) { described_class.new(10,20, 30, 40, 50, 60, 70, 80, 90, 100) }

    context "Node Retrieval " do

      it "#node_request(:first) returns a LinkedNode object." do
        expect(list.send(:node_request,:first)).to be_a SknUtils::Lists::LinkNode
      end
      it "#first_node returns a LinkedNode object." do
        expect(list.send(:first_node)).to be_a SknUtils::Lists::LinkNode
      end
      it "#next_node returns a LinkedNode object." do
        expect(list.send(:next_node)).to be_a SknUtils::Lists::LinkNode
      end
      it "#current_node returns a LinkedNode object." do
        expect(list.send(:current_node)).to be_a SknUtils::Lists::LinkNode
      end
      it "#prev_node returns a LinkedNode object." do
        expect(list.send(:prev_node)).to be_a SknUtils::Lists::LinkNode
      end
      it "#last_node returns a LinkedNode object." do
        expect(list.send(:last_node)).to be_a SknUtils::Lists::LinkNode
      end
    end

    context "Node Values " do

      it "First node has the expected value. " do
        expect(list.send(:first_node).value).to eq(10)
      end
      it "Next node has the expected value. " do
        expect(list.send(:next_node).value).to eq(20)
      end
      it "Current node has the expected value. " do
        3.times { list.send(:next_node) }
        expect(list.send(:current_node).value).to eq(40)
      end
      it "Last node has the expected value. " do
        expect(list.send(:last_node).value).to eq(100)
      end
      it "#node_value collected match #to_a output. " do
        nav_ary = []
        node = list.send(:first_node)
        list.size.times do
          nav_ary << node.node_value
          node.next_node
        end

        expect(nav_ary).to eq(list.to_a)
      end
    end

    context "Node Navigation " do

      it "Can navigate to each mode in list, forward. " do
        node = list.send(:first_node)
        list.size.times do
          expect(node.next).to be_a SknUtils::Lists::LinkNode
        end
      end
      it "Can navigate to each mode in list, backward. " do
        node = list.send(:last_node)
        list.size.times do
          expect(node.prev).to be_a SknUtils::Lists::LinkNode
        end
      end
      it "Values collected match #to_a output. " do
        nav_ary = []
        node = list.send(:first_node)
        list.size.times do
          nav_ary << node.value
          node = node.next
        end

        expect(list.to_a).to eq(nav_ary)
      end
    end
  end

end
