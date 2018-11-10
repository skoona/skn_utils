# ##
# Good Result
#
# Syntax: SknSuccess.call(value, message=nil, bool_code=true)
#

class SknSuccess
  attr_reader :value, :success, :message

  def self.call(*args)
    new(*args)
  end

  def initialize(*args)
    val, msg, rc = args
    @value = val || "Success"
    @message = msg || ''
    @success = rc.nil? ? true : rc
  end

  def payload
    if defined?(@_payload)
      @_payload
    elsif value.kind_of?(Hash)
      @_payload = SknUtils::DottedHash.new(value.to_h)
    else
      value
    end
  end
end
