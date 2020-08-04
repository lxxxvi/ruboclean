# frozen_string_literal: true

require 'ruboclean/grouper'

module Ruboclean
  # Orders the items within the groups alphabetically
  class Orderer
    def initialize(config_hash)
      @config_hash = config_hash
    end

    def order
      grouped_config.reduce({}) do |result, group|
        _group_name, group_items = group
        result.merge!(order_by_key(group_items))
      end
    end

    private

    def order_by_key(config_hash)
      config_hash.sort_by(&:first).to_h
    end

    def grouped_config
      Ruboclean::Grouper.new(@config_hash).group_config
    end
  end
end
