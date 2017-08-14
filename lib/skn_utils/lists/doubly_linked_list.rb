
module SknUtils
  module Lists
    # Doubly Linked List
    # Forward (#next) and Backwards (#prev) navigation
    # Head when (prev == nil)
    # Tail when (next == nil)
    class DoublyLinkedList
      attr_accessor :size

      def initialize(*vargs, &block)
        @current = nil
        @head = nil
        @tail = nil
        @size = 0

        @sort_ascending  = lambda {|a_obj,b_obj| a_obj >= b_obj}
        @sort_descending = lambda {|a_obj,b_obj| a_obj <= b_obj}
        @sort_condition  = block_given? ? block : @sort_ascending

        vargs.each {|value| insert(value) }
        first if vargs.size > 1
      end

      #
      # Navigation
      #

      # return values and position current to last node accessed
      # prevent @current from nil assignment
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

      def prev
        @current = @current.prev if @current and @current.prev
        @current.value rescue nil
      end

      def last
        @current = tail if tail
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
        target = find_by_value(position_value)
        node = LinkNode.new(value, target, :before)
        @current = node if target
        self.head = node if head === target
        self.tail = node if tail.nil?
        self.size += 1
      end

      # return new size
      def insert_after(position_value, value)
        target = find_by_value(position_value)
        node = LinkNode.new(value, target, :after)
        @current = node
        self.head = node if head.nil?
        self.tail = node if tail === target
        self.size += 1
      end

      # return remaining size
      def remove(value)
        target_node = find_by_value(value)
        if target_node
          @current = target_node.prev if target_node.prev
          @current.next = target_node.next if target_node.next
          @current.next.prev = @current if @current and @current.next and @current.next.prev
          target_node.remove!
        end
        self.tail = @current if tail === target_node
        self.head = @current if head === target_node
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
            break if position === @current
          end
        else
          Enumerator.new do |yielder, val|
            while position do
              yielder << position.value.dup
              position = position.next
              break if position === @current
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

      # block format: sort condition : {|a_obj,b_obj| a_obj >= b_obj}
      def sort!(direction_sym=:default, &block)
        active_sort_condition = block_given? ? block :
                                    (
                                    case direction_sym
                                      when :asc
                                        @sort_ascending
                                      when :desc
                                        @sort_descending
                                      else
                                        @sort_condition
                                    end
                                    )
        sorted = merge_sort(to_a, active_sort_condition)
        clear
        sorted.each {|item| insert(item) }
        size
      end

    private

      attr_accessor :head, :tail

      def find_by_value(value)
        return nil if head.nil?
        prior = head
        target = prior
        while not target.match_by_value(value)
          prior = target
          target = prior.next
          @current = target if target
        end
        target
      end

      def find_by_index(index)
        return nil if head.nil? or index < 1 or index > size
        node = head
        node = node.next while ((index -= 1) > 0 and node.next)
        @current = node if node
        node
      end

      # Merged Sort via Ref: http://rubyalgorithms.com/merge_sort.html
      # arr is Array to be sorted, sort_cond is Proc expecting a/b params returning true/false
      def merge_sort(arr, sort_cond)
        return arr if arr.size < 2

        middle = arr.size / 2

        left = merge_sort(arr[0...middle], sort_cond)
        right = merge_sort(arr[middle..arr.size], sort_cond)

        merge(left, right, sort_cond)
      end

      def merge(left, right, sort_cond)
        sorted = []

        while left.any? && right.any?

          if sort_cond.call(left.first, right.first)  # replace this condition with a proc
            sorted.push right.shift
          else
            sorted.push left.shift
          end

        end

        sorted + left + right
      end

    end # end class
  end # module
end # end module
