# frozen_string_literal: true

module Ruboclean
  # Orders the items within the groups alphabetically
  class Orderer
    def initialize(configuration_hash)
      @configuration_hash = configuration_hash
    end

    def order
      grouped_config.reduce({}) do |result, group|
        _group_name, group_items = group
        result.merge!(order_by_key(group_items))
      end
    end

    private

    attr_reader :configuration_hash

    def order_by_key(group_items)
      group_items.sort_by(&:first).to_h
    end

    def grouped_config
      Ruboclean::Grouper.new(configuration_hash).group_config
    end
  end
end
