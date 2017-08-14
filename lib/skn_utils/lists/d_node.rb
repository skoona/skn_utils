##
#
##

module SknUtils
  module Lists

    class DNode
      attr_accessor :prev, :next, :value

      def initialize(val, anchor_node=nil, strategy=:after)
        @value = val
        @prev = nil
        @next = nil

        case strategy
          when :before
            @prev = anchor_node.prev if anchor_node
            @next = anchor_node
            anchor_node.prev = self if anchor_node
          when :after
            @prev = anchor_node
            @next = anchor_node.next if anchor_node
            anchor_node.next = self if anchor_node
            @next.prev = self if @next
          when :circle_before
            @prev = anchor_node ? anchor_node.prev : self
            @next = anchor_node ? anchor_node : self
            anchor_node.prev = self if anchor_node
            @prev.next = self if anchor_node
          when :circle_after
            @prev = anchor_node ? anchor_node : self
            @next = anchor_node ? anchor_node.next : self
            anchor_node.next = self if anchor_node
            @next.prev = self if anchor_node
        end
      end

      def match_by_value(other_value)
        self.value === other_value
      end

      def to_s
        "Node with value: #{@value}"
      end
    end
  end # module
end