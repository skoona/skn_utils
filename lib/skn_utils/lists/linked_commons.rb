##
#
##

module SknUtils
  module Lists

    class LinkedCommons
      attr_accessor :size

      def initialize(*vargs, &compare_key_proc)
        @current = nil
        @head = nil
        @tail = nil
        @size = 0

        @match_value     = block_given? ? compare_key_proc : lambda {|obj| obj }
        @sort_ascending  = lambda {|a_obj,b_obj| @match_value.call(a_obj) >= @match_value.call(b_obj)}
        @sort_descending = lambda {|a_obj,b_obj| @match_value.call(a_obj) <= @match_value.call(b_obj)}
        @sort_condition  = @sort_ascending

        vargs.each {|value| insert(value) }
        first if vargs.size > 1
      end



      def empty?
        self.size == 0
      end

      # return number cleared
      def clear
        rc = 0
        node = self.head
        position = node
        while node do
          node = node.remove!
          rc += 1
          break if position.equal?(node)
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
        @current = self.head
        position = self.head
        if block_given?
          while position do
            block.call( position.value.dup )
            position = position.next
            break if position === @current
          end
        else
          Enumerator.new do |yielder|
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
        @current = self.head
        position = self.head
        result = []
        while position do
          result << position.value.dup
          position = position.next
          break if position.equal?(@current)
        end
        result
      end

      # block format: sort condition : {|a_obj,b_obj| a_obj >= b_obj}
      def sort!(direction_sym=:default, &compare_sort_proc)
        @active_sort_condition = block_given? ? compare_sort_proc :
                                     case direction_sym
                                       when :asc
                                         @sort_ascending
                                       when :desc
                                         @sort_descending
                                       else
                                         @sort_condition
                                     end
        sorted = merge_sort(self.to_a)
        clear
        sorted.each {|item| insert(item) }
        self.size
      end


    protected

      attr_accessor :head, :tail

      # Merged Sort via Ref: http://rubyalgorithms.com/merge_sort.html
      # arr is Array to be sorted, sort_cond is Proc expecting a/b params returning true/false
      def merge_sort(arr)
        return arr if arr.size < 2
        middle = arr.size / 2
        left = merge_sort(arr[0...middle])
        right = merge_sort(arr[middle..arr.size])
        merge(left, right)
      end

      def merge(left, right)
        sorted = []
        while left.any? && right.any?
          if @active_sort_condition.call(left.first, right.first)
            sorted.push right.shift
          else
            sorted.push left.shift
          end
        end

        sorted + left + right
      end

    end
  end # module
end