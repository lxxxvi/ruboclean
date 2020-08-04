# frozen_string_literal: true

require 'ruboclean/grouper'

module Ruboclean
  # Orders the items within the groups alphabetically
  class Orderer
    def initialize(hash)
      @hash = hash
    end

    def order
      order_within_groups
    end

    private

    def order_within_groups
      grouped_config.reduce({}) do |result, group|
        _group_name, group_items = group
        result.merge!(order_by_key(group_items))
      end
    end

    def order_by_key(hash)
      hash.sort_by(&:first).to_h
    end

    def grouped_config
      Ruboclean::Grouper.new(@hash).group_config
    end
  end
end
