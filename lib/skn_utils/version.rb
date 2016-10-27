# A better way to say it
module SknUtils
  class Version
    MAJOR = 2
    MINOR = 0
    PATCH = 6

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end

  VERSION = Version.to_s
end