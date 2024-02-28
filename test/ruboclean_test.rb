# frozen_string_literal: true

require "test_helper"

class RubocleanTest < BaseTest
  def test_that_it_has_a_version_number
    refute_nil ::Ruboclean::VERSION
  end

  def test_run_from_cli_without_silent_option
    using_fixture_files("02_input_empty.yml") do |fixture_path|
      assert_output(/^Using path '.*' \.\.\. done.$/) do
        exit_code = assert_raises(SystemExit) do
          Ruboclean.run_from_cli!([fixture_path])
        end.status

        assert_equal 0, exit_code
      end
    end
  end

  def test_run_from_cli_with_silent_option
    using_fixture_files("02_input_empty.yml") do |fixture_path|
      assert_output(/^$/) do
        exit_code = assert_raises(SystemExit) do
          Ruboclean.run_from_cli!([fixture_path, "--silent"])
        end.status

        assert_equal 0, exit_code
      end
    end
  end

  def test_run_from_cli_with_verify_option_when_no_changes
    exit_code = assert_raises(SystemExit) do
      using_fixture_files("00_expected_output.yml") do |fixture_path|
        Ruboclean.run_from_cli!([fixture_path, "--silent", "--verify"])
      end
    end.status

    assert_equal 0, exit_code
  end

  def test_run_from_cli_with_verify_option
    exit_code = assert_raises(SystemExit) do
      using_fixture_files("00_input.yml") do |fixture_path|
        Ruboclean.run_from_cli!([fixture_path, "--silent", "--verify"])
      end
    end.status

    assert_equal 1, exit_code
  end
end
