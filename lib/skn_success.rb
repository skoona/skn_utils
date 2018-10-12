# ##
# Good Result

class SknSuccess
  attr_reader :value, :success, :message

  def self.call(*args)
    new(*args)
  end

  def initialize(*args)
    val, rc, msg = *args
    # puts "#{self.class.name} => val:#{val}, rc:#{rc}, msg:#{msg}, args:#{args}"

    if args.size.eql?(2) and not ['TrueClass','FalseClass', 'NilClass'].include?(rc.class.name)
      msg = rc
      rc = true
    end

    @value = val || "Success"
    @success = !!rc || true
    @message = msg || ''
  end

end
