##
# File <SknUtils>/lib/skn_utils/lists/doubly_linked_list.rb
#
#     ll = SknUtils::Lists::DoublyLinkedList.new(*vargs, &compare_key_proc)
# - or -
#     ll = SknUtils::Lists::DoublyLinkedList.new(1,2,3,4,5) {|element| element[:key] }
# - or -
#     ll = SknUtils::Lists::DoublyLinkedList.new(
#                     {key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}
#          ) {|el| el[:key] }
# - or -
#     cmp_proc = lambda { |el| el[:key] }
#     vargs = [{key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}]
#     ll = SknUtils::Lists::DoublyLinkedList.new(*vargs, &cmp_proc)
###
# value = ll.first
# value = ll.at_index(4)
# count = ll.insert({key: 'anyValue'})
# ...
# count = ll.sort!           -- defaults to :asc
# count = ll.sort!(:desc)
# count = ll.sort!() {|a,b| a[:key] <= b[:key] }
##

module SknUtils
  module Lists
    # Doubly Linked List
    # Forward (#next) and Backwards (#prev) navigation
    # Head when (prev == nil)
    # Tail when (next == nil)
    class DoublyLinkedList < LinkedCommons

      #
      # Navigation
      #

      # return values and position current to last node accessed
      # prevent @current from nil assignment
      def first
        @current = self.head if self.head
        @current.value rescue nil
      end

      def next
        @current = @current.next if @current and @current.next
        @current.value rescue nil
      end

      def current
        @current.value rescue nil
      end

      def prev
        @current = @current.prev if @current and @current.prev
        @current.value rescue nil
      end

      def last
        @current = self.tail if self.tail
        @current.value rescue nil
      end

      # -+ int position from current node
      def nth(index)
        node = @current
        if index > 0
          while index > 1 and node and node.next
            node = node.next
            index -= 1
          end
          @current = node
        elsif index < 0
          while index < 0 and node and node.prev
            node = node.prev
            index += 1
          end
          @current = node
        end
        current
      end

      # return node at positive index from head
      def at_index(index)
        find_by_index(index)
        current
      end

      #
      # Modifications
      #

      # return new size
      def insert(value)
        temp = @current.value rescue nil
        insert_after(temp, value)
      end

      # return new size
      def prepend(value)
        temp = self.head.value rescue nil
        insert_before(temp, value)
      end
      # return new size
      def append(value)
        temp = self.tail.value rescue nil
        insert_after(temp, value)
      end

      # return new size
      def insert_before(position_value, value)
        target = find_by_value(position_value)
        node = LinkNode.new(value, target, :before, &@match_value)
        @current = node if target
        self.head = node if self.head === target
        self.tail = node if self.tail.nil?
        self.size += 1
      end

      # return new size
      def insert_after(position_value, value)
        target = find_by_value(position_value)
        node = LinkNode.new(value, target, :after, &@match_value)
        @current = node
        self.head = node if self.head.nil?
        self.tail = node if self.tail === target
        self.size += 1
      end

      # return remaining size
      def remove(value)
        target_node = find_by_value(value)
        if target_node
          if self.size == 1                           # will become zero
            @current = nil
            self.head = nil
            self.tail = nil
          elsif target_node.prev.nil?            # top
            @current = target_node.next
            @current.prev = nil
            self.head = @current
          elsif target_node.next.nil?            # bottom
            @current = target_node.prev
            @current.next = nil
            self.tail = @current
          else                                   # middle
            @current = target_node.prev
            @current.next = target_node.next
            target_node.next.prev = @current
          end
          target_node.remove!
          self.size -= 1
        end
      end

    protected

      def find_by_value(value)
        return nil if self.head.nil? || value.nil? || self.size == 0
        prior = self.head
        target = prior
        while target and not target.match_by_value(value)
          prior = target
          target = prior.next
        end
        target
      end

      def find_by_index(index)
        return nil if self.head.nil? or index < 1 or index > self.size
        node = self.head
        node = node.next while ((index -= 1) > 0 and node.next)
        @current = node if node
        node
      end

    end # end class
  end # module
end # end module
