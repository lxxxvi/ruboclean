# frozen_string_literal: true

require "test_helper"

class RubocleanTest < BaseTest
  def test_that_it_has_a_version_number
    refute_nil ::Ruboclean::VERSION
  end

  def test_run_from_cli_without_arguments
    using_fixture_file("00_input.yml") do |fixture_path, directory_path|
      expected_output = fixture_file_path("00_expected_output.yml").read

      Dir.chdir(directory_path) do
        Ruboclean.run_from_cli!([])

        assert_equal expected_output, Pathname.new(fixture_path).read
      end
    end
  end

  def test_run_from_cli_with_path_to_configuration_directory
    using_fixture_file("00_input.yml") do |fixture_path, directory_path|
      Ruboclean.run_from_cli!([directory_path, "--silent"])

      assert_equal fixture_file_path("00_expected_output.yml").read,
                   Pathname.new(fixture_path).read
    end
  end

  def test_run_from_cli_with_path_to_configuration_file
    using_fixture_file("00_input.yml") do |fixture_path|
      Ruboclean.run_from_cli!([fixture_path, "--silent"])

      assert_equal fixture_file_path("00_expected_output.yml").read,
                   Pathname.new(fixture_path).read
    end
  end

  def test_run_from_cli_without_silent_option
    using_fixture_file("02_input_empty.yml") do |fixture_path|
      assert_output(/^Using path '.*' \.\.\. done.$/) do
        Ruboclean.run_from_cli!([fixture_path])
      end
    end
  end

  def test_run_from_cli_with_silent_option
    using_fixture_file("02_input_empty.yml") do |fixture_path|
      assert_output(/^$/) do
        Ruboclean.run_from_cli!([fixture_path, "--silent"])
      end
    end
  end

  def test_run_preserve_comments
    using_fixture_file("00_input.yml") do |fixture_path|
      Ruboclean.run_from_cli!([fixture_path, "--silent", "--preserve-comments"])

      assert_equal fixture_file_path("00_expected_output_with_preserved_comments.yml").read,
                   Pathname.new(fixture_path).read
    end
  end
end
