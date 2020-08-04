# frozen_string_literal: true

module Ruboclean
  # Contains the hash representation of the `.rubocop.yml` file
  class RubocopConfiguration
    attr_reader :rubocop_config

    def initialize(rubocop_config)
      @rubocop_config = rubocop_config
    end

    def only_require_config
      @rubocop_config.slice('require')
    end

    def except_require_config
      @rubocop_config.find_all { |key, _value| key != 'require' }
    end

    def to_yaml
      @rubocop_config.to_yaml
    end

    def order
      Ruboclean::Orderer.new(self).order
    end
  end
end
