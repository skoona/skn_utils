# A better way to say it
module SknUtils
  class Version
    MAJOR = 3
    MINOR = 3
    PATCH = 12

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end


  VERSION = Version.to_s
end