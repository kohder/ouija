# encoding: utf-8

module Ouija
  class Planchette

    def initialize(hash)
      @hash = hash
    end

    def [](key)
      value = @hash[key]
      value.respond_to?(:dup) ? value.dup : value rescue value
    end

    def to_hash
      @hash.dup
    end
  end
end
