# ##
# Bad Result
#
# Syntax: SknFailure.call(payload, message=nil, bool_code=false)
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
    # puts "#{self.class.name} => val:#{val}, rc:#{rc}, msg:#{msg}, args:#{args}"
    # puts "#{self.class.name} => @val:#{@value}, @rc:#{@success}, @msg:#{@message}"
  end

  def payload
    @value
  end
end
