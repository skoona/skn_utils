##
#
##

module SknUtils
  module Lists

    class LinkNode
      attr_accessor :prev, :next, :value

      def initialize(val, anchor_node=nil, strategy=:after, mgr=nil, &cmp_key)
        @value = val
        @prev = nil
        @next = nil
        @provider = mgr
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
        @cmp_proc.call(value).equal? @cmp_proc.call(other_value)
      end

      # Returns: assuming two LinkNode s are being compared
      #   0 if first operand equals second,
      #   1 if first operand is greater than the second and
      #  -1 if first operand is less than the second.
      def <=>(other)
        if @cmp_proc.call(self.value)  == @cmp_proc.call(other.value)
            0
        elsif @cmp_proc.call(self.value) > @cmp_proc.call(other.value)
            1
        elsif @cmp_proc.call(self.value) < @cmp_proc.call(other.value)
            -1
        end
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

      # Reverse API to Parent Linked List Class
      def node_value
        node_request.value
      end
      def first_node
        node_request(:first)
      end
      def next_node
        node_request(:next)
      end
      def current_node
        node_request(:current)
      end
      def prev_node
        node_request(:prev)
      end
      def last_node
        node_request(:last)
      end

      protected()

      def respond_to_missing?(method, include_private=false)
        @provider && @provider.protected_methods(true).include?(method) || super
      end

      def method_missing(method, *args, &block)
        if @provider and @provider.protected_methods(true).include?(method)
          block_given? ? @provider.send(method, *args, block) :
              (args.size == 0 ?  @provider.send(method) : @provider.send(method, *args))
        else
          super
        end
      end
    end
  end # module
end