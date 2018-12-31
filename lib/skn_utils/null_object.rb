# frozen_string_literal: true

#
# lib/skn_utils/null_object.rb
#
module SknUtils

  # From: https://github.com/avdi/cowsay
  class NullObject
    def initialize
      @origin = caller.first
    end

    def __null_origin__
      @origin
    end

    def method_missing(*args, &block)
      self
    end

    def nil?
      true
    end
  end

  def self.nullable?(value)
    value.nil? ? NullObject.new : value
  end

end
