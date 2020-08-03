# frozen_string_literal: true

require 'ruboclean/grouper'

module Ruboclean
  # Orders the items within the groups alphabetically
  class Orderer
    def initialize(rubocop_configuration)
      @rubocop_configuration = rubocop_configuration
    end

    def order
      ordered_hash = {}.merge(@rubocop_configuration.only_require_config)
                       .merge(remaining_config_ordered_within_groups)

      Ruboclean::RubocopConfiguration.new(ordered_hash)
    end

    private

    def remaining_config_ordered_within_groups
      ordered_within_groups = {}

      group_remaining_config.map do |group|
        _group_name, group_items = group

        group_items.sort_by { |group_item| group_item.first.first }
                   .each { |sorted_group_item| ordered_within_groups.merge!(sorted_group_item) }
      end

      ordered_within_groups
    end

    def group_remaining_config
      Ruboclean::Grouper.new(@rubocop_configuration).group_remaining_config
    end
  end
end
