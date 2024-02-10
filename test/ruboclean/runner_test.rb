# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class RunnerTest < BaseTest
    def test_run_without_arguments
      using_fixture_files("00_input.yml") do |fixture_path, directory_path|
        Dir.chdir(directory_path) do
          arguments = Ruboclean::CliArguments.new
          Ruboclean::Runner.new(arguments).run!
        end

        assert_equal(
          fixture_file_path("00_expected_output.yml").read,
          Pathname.new(fixture_path).read
        )
      end
    end

    def test_run_with_explicit_file_path
      using_fixture_files("00_input.yml") do |fixture_path|
        arguments = Ruboclean::CliArguments.new([fixture_path])
        Ruboclean::Runner.new(arguments).run!

        assert_equal(
          fixture_file_path("00_expected_output.yml").read,
          Pathname.new(fixture_path).read
        )
      end
    end

    def test_run_with_directory_path
      using_fixture_files("00_input.yml") do |fixture_path, directory_path|
        arguments = Ruboclean::CliArguments.new([directory_path])
        Ruboclean::Runner.new(arguments).run!

        assert_equal(
          fixture_file_path("00_expected_output.yml").read,
          Pathname.new(fixture_path).read
        )
      end
    end

    def test_run_with_explicit_file_path_that_does_not_exist
      arguments = Ruboclean::CliArguments.new(["does-not-exist"])

      error = assert_raises ArgumentError do
        Ruboclean::Runner.new(arguments).run!
      end

      assert_equal "path does not exist: 'does-not-exist'", error.message
    end

    def test_run_with_directory_path_that_does_not_have_rubocop_yaml
      arguments = Ruboclean::CliArguments.new(["/tmp"])

      error = assert_raises ArgumentError do
        Ruboclean::Runner.new(arguments).run!
      end

      assert_equal "path does not exist: '/tmp/.rubocop.yml'", error.message
    end

    def test_run_without_require_block
      using_fixture_files("01_input_without_require_block.yml") do |fixture_path|
        arguments = Ruboclean::CliArguments.new([fixture_path])
        Ruboclean::Runner.new(arguments).run!

        assert_equal(
          fixture_file_path("01_expected_output_without_require_block.yml").read,
          Pathname.new(fixture_path).read
        )
      end
    end

    def test_run_with_preserve_comments_flag
      using_fixture_files("00_input.yml") do |fixture_path|
        arguments = Ruboclean::CliArguments.new([fixture_path, "--preserve-comments"])
        Ruboclean::Runner.new(arguments).run!

        assert_equal fixture_file_path("00_expected_output_with_preserved_comments.yml").read,
                     Pathname.new(fixture_path).read
      end
    end

    # TODO: enable
    # def test_path_cleanup
    #   input = { SomeCop: { Include: ["some_other_file.rb", "test/fixtures/file_exists.rb", "lib/**/*.rb"] } }
    #   output = { SomeCop: { Include: ["test/fixtures/file_exists.rb", "lib/**/*.rb"] } }

    #   Ruboclean::RubocopConfiguration.new(input).path_cleanup.tap do |cleaned_output|
    #     assert_instance_of Hash, cleaned_output
    #     assert_equal output.to_a, cleaned_output.to_a
    #   end
    # end
  end
end
