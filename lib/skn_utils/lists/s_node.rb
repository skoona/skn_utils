##
#
##

module SknUtils
  module Lists

    class SNode
      attr_accessor :next, :value

      def initialize(val, current_node=nil)
        @value = val
        @next = nil
        current_node.next = self if current_node # :after logic, :before handled in LList
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