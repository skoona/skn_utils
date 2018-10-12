# ##
# File: ./lib/skn_utils/core_extensions.rb  --
# -- from: Rails 4.1 ActiveSupport:lib/active_support/core_ext/object/blank.rb
# -- Ref: https://6ftdan.com/allyourdev/2015/01/20/refinements-over-monkey-patching/

module SknUtils
  module CoreObjectExtensions

    unless Object.respond_to?(:present?)

      class ::Object
        # An object is blank if it's false, empty, or a whitespace string.
        # For example, '', '   ', +nil+, [], and {} are all blank.
        #
        # This simplifies
        #
        #   address.nil? || address.empty?
        #
        # to
        #
        #   address.blank?
        #
        # @return [true, false]
        def blank?
          respond_to?(:empty?) ? !!empty? : !self
        end

        # An object is present if it's not blank.
        #
        # @return [true, false]
        def present?
          !blank?
        end

        # Returns the receiver if it's present otherwise returns +nil+.
        # <tt>object.presence</tt> is equivalent to
        #
        #    object.present? ? object : nil
        #
        # For example, something like
        #
        #   state   = params[:state]   if params[:state].present?
        #   country = params[:country] if params[:country].present?
        #   region  = state || country || 'US'
        #
        # becomes
        #
        #   region = params[:state].presence || params[:country].presence || 'US'
        #
        # @return [Object]
        def presence
          self if present?
        end
      end

      class ::NilClass
        # +nil+ is blank:
        #
        #   nil.blank? # => true
        #
        # @return [true]
        def blank?
          true
        end
      end

      class ::FalseClass
        # +false+ is blank:
        #
        #   false.blank? # => true
        #
        # @return [true]
        def blank?
          true
        end
      end

      class ::TrueClass
        # +true+ is not blank:
        #
        #   true.blank? # => false
        #
        # @return [false]
        def blank?
          false
        end
      end

      class ::Array
        # An array is blank if it's empty:
        #
        #   [].blank?      # => true
        #   [1,2,3].blank? # => false
        #
        # @return [true, false]
        alias_method :blank?, :empty?
      end

      class ::Hash
        # A hash is blank if it's empty:
        #
        #   {}.blank?                # => true
        #   { key: 'value' }.blank?  # => false
        #
        # @return [true, false]
        alias_method :blank?, :empty?
      end

      class ::String
        # A string is blank if it's empty or contains whitespaces only:
        #
        #   ''.blank?       # => true
        #   '   '.blank?    # => true
        #   "\t\n\r".blank? # => true
        #   ' blah '.blank? # => false
        #
        # Unicode whitespace is supported:
        #
        #   "\u00a0".blank? # => true
        #
        # @return [true, false]
        def blank?
          /\A[[:space:]]*\z/ === self
        end
      end

      class ::Numeric
        # No number is blank:
        #
        #   1.blank? # => false
        #   0.blank? # => false
        #
        # @return [false]
        def blank?
          false
        end
      end

    end # end unless respond_to

  end # end CoreObjectExtensions
end # end SknUtils
