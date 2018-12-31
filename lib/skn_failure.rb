# frozen_string_literal: true

# ##
# Bad Result
#
# Syntax: SknFailure.call(value, message=nil, bool_code=false)
#

class SknFailure
  attr_reader :value, :success, :message

  def self.call(*args)
    new(*args)
  end

  def initialize(*args)
    val, msg, rc = args
    @value = val || "Failure"
    @message = msg || ''
    @success = rc.nil? ? false : rc
  end

  def payload
    if defined?(@_payload)
      @_payload
    elsif value.kind_of?(Hash)
      @_payload = SknUtils::DottedHash.new(value)
    else
      value
    end
  end
end
