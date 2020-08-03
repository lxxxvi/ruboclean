# frozen_string_literal: true

module Ruboclean
  class Grouper
    def initialize(rubocop_configuration)
      @rubocop_configuration = rubocop_configuration
    end

    def group_remaining_config
      groups = { namespaces: [], cops: [] }

      @rubocop_configuration.except_require_config.each do |key, value|
        if key.include?('/')
          groups[:cops] << Hash[key, value]
        else
          groups[:namespaces] << Hash[key, value]
        end
      end

      groups
    end
  end
end
