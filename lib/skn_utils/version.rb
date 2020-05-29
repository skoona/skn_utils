# frozen_string_literal: true

# A better way to say it
module SknUtils
  class Version
    MAJOR = 5
    MINOR = 8
    PATCH = 0

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end


  VERSION = Version.to_s
end
