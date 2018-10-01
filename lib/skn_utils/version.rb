# A better way to say it
module SknUtils
  class Version
    MAJOR = 4
    MINOR = 0
    PATCH = 4

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end


  VERSION = Version.to_s
end
