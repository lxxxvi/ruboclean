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
      # ordered_within_groups = {}

      # group_remaining_config.map do |group|
      #   _group_name, group_items = group
      #   ordered_within_groups.merge!(order_by_key(group_items))
      # end

      # ordered_within_groups

      grouped_remaining_config.reduce({}) do |result, group|
        _group_name, group_items = group
        result.merge!(order_by_key(group_items))
      end
    end

    def order_by_key(hash)
      hash.sort_by(&:first).to_h
    end

    def grouped_remaining_config
      Ruboclean::Grouper.new(@rubocop_configuration).group_remaining_config
    end
  end
end
