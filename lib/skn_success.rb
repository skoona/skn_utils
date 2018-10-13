# ##
# Good Result
#
# Syntax: SknSuccess.call(payload, message=nil, bool_code=true)
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
    # puts "#{self.class.name} => val:#{val}, rc:#{rc}, msg:#{msg}, args:#{args}"
    # puts "#{self.class.name} => @val:#{@value}, @rc:#{@success}, @msg:#{@message}"
  end

  def payload
    @value
  end
end
