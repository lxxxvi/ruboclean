# frozen_string_literal: true

module Ruboclean
  # Contains the config_hash representation of the `.rubocop.yml` file
  class RubocopConfiguration
    def initialize(config_hash)
      @config_hash = config_hash
    end

    def order
      Ruboclean::Orderer.new(@config_hash).order
    end

    def cleanup
      Ruboclean::PathCleanup.new(@config_hash).cleanup
    end

    def perform
      @config_hash = order
      cleanup
    end

    def nil?
      @config_hash.nil?
    end
  end
end
