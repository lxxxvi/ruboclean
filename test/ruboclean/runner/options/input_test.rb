# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class Runner
    class Options
      class InputTest < BaseTest
        def test_with_empty_cli_arguments
          cli_arguments = new_cli_arguments

          input = Ruboclean::Runner::Options::Input.new(cli_arguments: cli_arguments)

          expected_input_pathname = Pathname.new(Dir.pwd).join(".rubocop.yml")

          assert_equal expected_input_pathname, input.stream
          assert_equal expected_input_pathname, input.input_path
          refute_predicate input, :stdin?
        end

        def test_with_input_argument
          using_fixture_files("00_input.yml") do |fixture_path|
            cli_arguments = new_cli_arguments([fixture_path])

            input = Ruboclean::Runner::Options::Input.new(cli_arguments: cli_arguments)

            expected_input_pathname = Pathname.new(fixture_path)

            assert_equal expected_input_pathname, input.stream
            assert_equal expected_input_pathname, input.input_path
            refute_predicate input, :stdin?
          end
        end

        def test_with_stdin_flag
          cli_arguments = new_cli_arguments(["--stdin"])

          input = Ruboclean::Runner::Options::Input.new(cli_arguments: cli_arguments)

          assert_equal $stdin, input.stream
          assert_equal Pathname.new(Dir.pwd).join(".rubocop.yml"), input.input_path
          assert_predicate input, :stdin?
        end

        def test_with_invalid_input_path
          cli_arguments = new_cli_arguments(["/path/does/not/exist/.rubocop.yml"])

          error = assert_raises(ArgumentError) do
            Ruboclean::Runner::Options::Input.new(cli_arguments: cli_arguments).stream
          end

          assert_equal "input path does not exist: '/path/does/not/exist/.rubocop.yml'", error.message
        end

        private

        def new_cli_arguments(...)
          Ruboclean::CliArguments.new(...)
        end
      end
    end
  end
end
