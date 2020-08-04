# frozen_string_literal: true

require 'test_helper'

class RubocleanTest < BaseTest
  def test_that_it_has_a_version_number
    refute_nil ::Ruboclean::VERSION
  end

  def test_run
    using_fixture_file('00_input.yml') do |rubocop_configuration_pathname|
      Ruboclean.run(rubocop_configuration_pathname)

      assert_equal fixture_file_path('00_expected_output.yml').read,
                   rubocop_configuration_pathname.read
    end
  end

  def test_run_without_require_block
    using_fixture_file('01_input_without_require_block.yml') do |rubocop_configuration_pathname|
      Ruboclean.run(rubocop_configuration_pathname)

      assert_equal fixture_file_path('01_expected_output_without_require_block.yml').read,
                   rubocop_configuration_pathname.read
    end
  end
end
