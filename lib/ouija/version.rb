# encoding: utf-8

module Ouija
  class Version
    MAJOR, MINOR, PATCH = 0, 1, 0

    def self.major
      MAJOR
    end

    def self.minor
      MINOR
    end

    def self.patch
      PATCH
    end

    def self.current
      "#{major}.#{minor}.#{patch}"
    end
  end
end
