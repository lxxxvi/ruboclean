# frozen_string_literal: true

module Ruboclean
  # Contains the hash representation of the `.rubocop.yml` file
  class RubocopConfiguration
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def order
      Ruboclean::Orderer.new(@hash).order
    end
  end
end
