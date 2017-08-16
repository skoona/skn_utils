##
#
##

module SknUtils
  module Lists

    class LinkNode
      attr_accessor :prev, :next, :value

      def initialize(val, anchor_node=nil, strategy=:after, &cmp_key)
        @value = val
        @prev = nil
        @next = nil
        @cmp_proc = block_given? ? cmp_key : lambda {|a| a }

        case strategy
          when :single # after logic
            if anchor_node
              @next = anchor_node.next
              anchor_node.next = self
            end
          when :before
            @prev = anchor_node.prev if anchor_node
            anchor_node.prev = self if anchor_node
            @next = anchor_node
          when :after
            @next = anchor_node.next if anchor_node
            anchor_node.next = self if anchor_node
            @prev = anchor_node
          when :circle_before
            @prev = anchor_node ? anchor_node.prev : self
            anchor_node.prev = self if anchor_node
            @next = anchor_node ? anchor_node : self
          when :circle_after
            @next = anchor_node ? anchor_node.next : self
            anchor_node.next = self if anchor_node
            @prev = anchor_node ? anchor_node : self
        end
      end

      def match_by_value(other_value)
        @cmp_proc.call(value) === @cmp_proc.call(other_value)
      end

      # returns next node
      def remove!
        next_node = @next
        @value = nil
        @prev = nil
        @next = nil
        next_node
      end

      def to_s
        "Node with value: #{@value}"
      end
    end
  end # module
end