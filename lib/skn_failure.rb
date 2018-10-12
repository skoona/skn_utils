# ##
# Bad Result

class SknFailure
  attr_reader :value, :success, :message

  def self.call(*args)
    new(*args)
  end

  def initialize(*args)
    val, rc, msg = *args
    # puts "#{self.class.name} => val:#{val}, rc:#{rc}, msg:#{msg}, args:#{args}"

    if args.size.eql?(2) and not ['TrueClass','FalseClass'].include?(rc.class.name)
      msg = rc
      rc = false
    end

    @value = val || "Failure"
    @success = !!rc
    @message = msg || ''
  end

end
