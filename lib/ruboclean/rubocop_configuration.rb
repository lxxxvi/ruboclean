# frozen_string_literal: true

module Ruboclean
  class RubocopConfiguration
    def initialize(rubocop_config)
      @rubocop_config = rubocop_config
    end

    def only_require_config
      @rubocop_config.slice('require')
    end

    def except_require_config
      @rubocop_config.keep_if { |config| config != 'require' }
    end

    def to_yaml
      @rubocop_config.to_yaml
    end

    def order
      Ruboclean::Orderer.new(self).order
    end
  end
end
