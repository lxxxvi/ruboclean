# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class GrouperTest < BaseTest
    def test_group_config_with_empty_configuration
      config_hash = {}

      group_config_with(config_hash).tap do |result|
        assert_equal 3, result.keys.size
        assert_equal 0, result[:base].size
        assert_equal 0, result[:namespaces].size
        assert_equal 0, result[:cops].size
      end
    end

    def test_group_config_only_base
      config_hash = { "require" => ["rubocop-rails"] }

      group_config_with(config_hash).tap do |result|
        assert_equal 3, result.keys.size
        assert_equal 1, result[:base].size
        assert_equal 0, result[:namespaces].size
        assert_equal 0, result[:cops].size
      end
    end

    def test_group_config_only_namespaces
      config_hash = { "AllCops" => { "Enabled" => true } }

      group_config_with(config_hash).tap do |result|
        assert_equal 3, result.keys.size
        assert_equal 0, result[:base].size
        assert_equal 1, result[:namespaces].size
        assert_equal 0, result[:cops].size
      end
    end

    def test_group_config_only_cops
      config_hash = { "Style/CaseLikeIf" => { "Enabled" => true } }

      group_config_with(config_hash).tap do |result|
        assert_equal 3, result.keys.size
        assert_equal 0, result[:namespaces].size
        assert_equal 1, result[:cops].size
      end
    end

    private

    def group_config_with(config_hash)
      Ruboclean::Grouper.new(config_hash).group_config
    end
  end
end
