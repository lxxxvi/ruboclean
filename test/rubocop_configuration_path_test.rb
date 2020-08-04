# frozen_string_literal: true

require 'test_helper'

class RubocopConfigurationPathTest < BaseTest
  def test_invalid_path_error
    error = assert_raises Ruboclean::RubocopConfigurationPath::InvalidPathError do
      Ruboclean::RubocopConfigurationPath.new('does-not-exist')
    end

    assert_equal "path does not exist: 'does-not-exist'", error.message
  end

  def test_load_with_file_path
    using_fixture_file('00_input.yml') do |rubocop_configuration_pathname|
      Ruboclean::RubocopConfigurationPath.new(rubocop_configuration_pathname).load.tap do |result|
        assert_equal Ruboclean::RubocopConfiguration, result.class
      end
    end
  end

  def test_load_with_directory_path
    using_fixture_file('00_input.yml') do |rubocop_configuration_pathname|
      Ruboclean::RubocopConfigurationPath.new(rubocop_configuration_pathname.dirname).load.tap do |result|
        assert_equal Ruboclean::RubocopConfiguration, result.class
      end
    end
  end

  def test_write
    using_fixture_file('02_input_empty.yml') do |rubocop_configuration_pathname|
      rubocop_configuration_path = Ruboclean::RubocopConfigurationPath.new(rubocop_configuration_pathname)
      rubocop_configuration_path.write({ 'AllCops' => { 'Enabled' => false } })
      assert_equal expected_yaml, rubocop_configuration_pathname.read
    end
  end

  private

  def expected_yaml
    <<~YML
      ---

      AllCops:
        Enabled: false
    YML
  end
end
