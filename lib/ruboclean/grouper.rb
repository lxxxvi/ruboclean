# frozen_string_literal: true

module Ruboclean
  # Groups the rubocop configuration items into two categories:
  #   - namespaces: every item which does **not** include an "/"
  #   - cops: every item which **includes** an "/"
  class Grouper
    def initialize(rubocop_configuration)
      @rubocop_configuration = rubocop_configuration
    end

    def group_remaining_config
      groups = { namespaces: {}, cops: {} }

      @rubocop_configuration.except_require_config.each do |key, value|
        if key.include?('/')
          groups[:cops].merge! Hash[key, value]
        else
          groups[:namespaces].merge! Hash[key, value]
        end
      end

      groups
    end
  end
end
