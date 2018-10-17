# A better way to say it
module SknUtils
  class Version
    MAJOR = 5
    MINOR = 1
    PATCH = 3

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end


  VERSION = Version.to_s
end
