# encoding: utf-8

module Ouija
  class Planchette

    def initialize(hash)
      @hash = hash
    end

    def [](key)
      value = @hash[key]
      value.respond?(:dup) ? value.dup : value
    end

    def to_hash
      @hash.dup
    end
  end
end
