##
# File <SknUtils>/lib/skn_utils/lists/linked_list.rb
#
#     ll = SknUtils::Lists::LinkedList.new(*vargs, &compare_key_proc)
# - or -
#     ll = SknUtils::Lists::LinkedList.new(1,2,3,4,5) {|element| element[:key] }
# - or -
#     ll = SknUtils::Lists::LinkedList.new(
#                     {key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}
#            ) {|el| el[:key] }
# - or -
#     cmp_proc = lambda { |el| el[:key] }
#     vargs = [{key: 'Z'}, {key: 'K'}, {key: 'S'}, {key: 'n'}, {key: 's'}]
#     ll = SknUtils::Lists::LinkedList.new(*vargs, &cmp_proc)
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
    # Singly Linked List
    # Forward or #next navigation only
    # Head is absolute via #first
    # Tail when (next == nil)
    class LinkedList < LinkedCommons

      #
      # Navigation
      #

      # return values and position current to last node accessed
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

      def last
        @current = self.tail if self.tail
        @current.value rescue nil
      end

      # +int position from current node
      def nth(index)
        node = @current
        while index > 1 and node and node.next
          node = node.next
          index -= 1
          @current = node
        end
        # no reverse or prev for Single List
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
        prior, target = find_by_value(position_value)
        node = LinkNode.new(value, prior, :single, &@match_value)
        node.next = target if target
        self.head = node if self.head === target
        self.tail = node if self.tail.nil?
        @current = node
        self.size += 1
      end

      # return new size
      def insert_after(position_value, value)
        prior, target = find_by_value(position_value)
        node = LinkNode.new(value, target, :single, &@match_value)
        self.head = node if self.head.nil?
        self.tail = node if self.tail === target
        @current = node
        self.size += 1
      end

      # return remaining size
      def remove(value)
        prior, target_node = find_by_value(value)
        @current = prior.nil? ? target_node.next : prior
        @current.next = target_node.remove! if @current && target_node
        self.tail = @current.next if @current && self.tail === target_node
        self.head = @current.next if @current && self.head === target_node
        self.size -= 1
      end

    protected

      def find_by_value(value)
        return [@current, nil] if self.head.nil? || value.nil?
        prior  = self.head
        target = prior
        while target and not target.match_by_value(value)
          prior = target
          target = target.next
          @current = prior if target
        end
        [prior, target]
      end

      def find_by_index(index)
        return nil if self.head.nil? || index < 1 || index > self.size
        node = self.head
        node = node.next while ((index -= 1) > 0 and node.next)
        @current = node if node
        node
      end

    end # end class
  end # end module
end # end module
