##
# File: <gem-root>/lib/skn_utils/business_services/year_month.rb
#  Ref: http://blog.arkency.com/2014/08/using-ruby-range-with-custom-classes/
#
## Calculates YearMonth
#
# YearMonth.new(2014, 3) > YearMonth.new(2014, 1)
# => true

# YearMonth.new(2014, 1) >= YearMonth.new(2014, 1)
# => true

# YearMonth.new(2015, 1) < YearMonth.new(2014, 3)
# => false
#
module SknUtils
  module BusinessServices

    class YearMonth < Struct.new(:year, :month)
      include Comparable

      def initialize(iyear, imonth)
        cleaned_year = iyear.to_i
        cleaned_month = imonth.to_i

        raise ArgumentError unless cleaned_year > 0
        raise ArgumentError unless cleaned_month >= 1 && cleaned_month <= 12

        super(cleaned_year, cleaned_month)
      end

      def next
        if month == 12
          self.class.new(year+1, 1)
        else
          self.class.new(year, month+1)
        end
      end
      alias_method :succ, :next

      def <=>(other)
        (year <=> other.year).nonzero? || month <=> other.month
      end

      # need to do some time calcs

      def beginning_of
        Time.parse("12:00",Date.new(year, month, 1).to_time) # strftime('%Y-%m-%d')
      end

      def end_of
        Time.parse("12:00",Date.new(year, month, -1).to_time) # strftime('%Y-%m-%d')
      end

      private :year=, :month=
    end
  end
end
