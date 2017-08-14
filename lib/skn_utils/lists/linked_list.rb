
module SknUtils
  module Lists
    # Singly Linked List
    # Forward or #next navigation only
    # Head is absolute via #first
    # Tail when (next == nil)
    class LinkedList
      attr_accessor :size

      def initialize(*values)
        @current = nil
        @head = nil
        @tail = nil
        @size = 0
        values.each {|value| insert(value) }
        first if values.size > 1
      end

      #
      # Navigation
      #

      # return values and position current to last node accessed
      def first
        @current = head if head
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
        @current = tail if tail
        @current.value rescue nil
      end

      # -+ int position from current node
      def nth(index)
        node = @current
        while index > 1 and node and node.next
          node = node.next
          index -= 1
          @current = node
        end
        # no reverse or prev for Single List
        current
      rescue NoMethodError
        nil
      end

      # return node at positive index from head
      def at_index(index)
        find_by_index(index)
        current
      end

      def empty?
        size == 0
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
        temp = head.value rescue nil
        insert_before(temp, value)
      end

      # return new size
      def append(value)
        temp = tail.value rescue nil
        insert_after(temp, value)
      end

      # return new size
      def insert_before(position_value, value)
        prior, target = find_by_value(position_value)
        node = LinkNode.new(value, prior, :single)
        node.next = target if target
        self.head = node if head === target
        self.tail = node if tail.nil?
        @current = node
        self.size += 1
      end

      # return new size
      def insert_after(position_value, value)
        prior, target = find_by_value(position_value)
        node = LinkNode.new(value, target, :single)
        self.head = node if head.nil?
        self.tail = node if tail === target
        @current = node
        self.size += 1
      end

      # return remaining size
      def remove(value)
        @current, target_node = find_by_value(value)
        @current.next = target_node.remove!
        tail = @current.next if tail === target_node
        head = @current if head === target_node
        self.size -= 1
      end

      # return number cleared
      def clear
        rc = 0
        node = head
        position = head
        while node do
          node = node.remove!
          rc += 1
          break if position === node
        end

        @current = nil
        self.head = nil
        self.tail = nil
        self.size = 0
        rc
      end

      #
      # Enumerate
      #

      # perform each() or return enumerator
      def each(&block)
        @current = head
        position = head
        if block_given?
          while position do
            yield position.value.dup
            position = position.next
          end
        else
          Enumerator.new do |yielder, val|
            while position do
              yielder << position.value.dup
              position = position.next
            end
          end
        end
      end

      # convert self to a value array
      def to_a
        @current = head
        position = head
        result = []
        while position do
          result << position.value.dup
          position = position.next
          break if position === @current
        end
        result
      end

    private

      attr_accessor :head, :tail

      def find_by_value(value)
        return [nil,nil] if head.nil?
        prior = head
        target = prior
        while not target.match_by_value(value)
          prior = target
          target = prior.next
          @current = target if target
        end
        [prior, target]
      end

      def find_by_index(index)
        return nil if head.nil? or index < 1 or index > size
        node = head
        node = node.next while ((index -= 1) > 0 and node.next)
        @current = node if node
        node
      end

    end # end class
  end # end module
end # end module
