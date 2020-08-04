# frozen_string_literal: true

require 'test_helper'

class GrouperTest < BaseTest
  def test_group_remaining_config_with_empty_configuration
    group_remaining_config_with({}).tap do |result|
      assert_equal 2, result.keys.size
      assert_equal 0, result[:namespaces].size
      assert_equal 0, result[:cops].size
    end
  end

  def test_group_remaining_config_only_namespaces
    input = { 'AllCops' => { 'Enabled' => true } }

    group_remaining_config_with(input).tap do |result|
      assert_equal 2, result.keys.size
      assert_equal 1, result[:namespaces].size
      assert_equal 0, result[:cops].size
    end
  end

  def test_group_remaining_config_only_cops
    input = { 'Style/CaseLikeIf' => { 'Enabled' => true } }

    group_remaining_config_with(input).tap do |result|
      assert_equal 2, result.keys.size
      assert_equal 0, result[:namespaces].size
      assert_equal 1, result[:cops].size
    end
  end

  private

  def group_remaining_config_with(hash)
    rubocop_configuration = Ruboclean::RubocopConfiguration.new(hash)
    Ruboclean::Grouper.new(rubocop_configuration).group_remaining_config
  end
end
