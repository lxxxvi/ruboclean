# frozen_string_literal: true

module Ruboclean
  # Groups the rubocop configuration items into three categories:
  #   - require: the require block
  #   - namespaces: every item which does **not** include an "/"
  #   - cops: every item which **includes** an "/"
  class Grouper
    def initialize(config_hash)
      @config_hash = config_hash
    end

    def group_config
      @config_hash.each_with_object(empty_groups) do |item, result|
        key, value = item
        target_group = find_target_group(key)
        result[target_group].merge! Hash[key, value]
      end
    end

    private

    def empty_groups
      { require: {}, namespaces: {}, cops: {} }
    end

    def find_target_group(key)
      return :require if key == 'require'
      return :cops if key.include?('/')

      :namespaces
    end
  end
end
