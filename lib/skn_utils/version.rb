# A better way to say it
module SknUtils
  class Version
    MAJOR = 3
    MINOR = 3
    PATCH = 1

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end


  VERSION = Version.to_s
end