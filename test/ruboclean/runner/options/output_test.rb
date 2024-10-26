# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class Runner
    class Options
      class OutputTest < BaseTest
        def test_without_arguments
          cli_arguments = new_cli_arguments
          input = new_input(cli_arguments: cli_arguments)

          output = Ruboclean::Runner::Options::Output.new(cli_arguments: cli_arguments, input: input)

          assert_equal Pathname.new(Dir.pwd).join(".rubocop.yml"), output.stream
          refute_predicate output, :stdout?
        end

        def test_with_custom_output_flag
          cli_arguments = new_cli_arguments(["--output=/tmp/output.yml"])
          input = new_input(cli_arguments: cli_arguments)

          output = Ruboclean::Runner::Options::Output.new(cli_arguments: cli_arguments, input: input)

          assert_equal Pathname.new("/tmp/output.yml"), output.stream
          refute_predicate output, :stdout?
        end

        def test_resolves_relative_paths
          cli_arguments = new_cli_arguments(["--output=./test/.rubocop.yml"])
          input = new_input(cli_arguments: cli_arguments)

          output = Ruboclean::Runner::Options::Output.new(cli_arguments: cli_arguments, input: input)

          assert_equal Pathname.new(Dir.pwd).join("./test/.rubocop.yml"), output.stream
        end

        def test_stdout_if_input_is_stdin_and_no_output_given
          cli_arguments = new_cli_arguments(["--stdin"])
          input = new_input(cli_arguments: cli_arguments)

          output = Ruboclean::Runner::Options::Output.new(cli_arguments: cli_arguments, input: input)

          assert_equal $stdout, output.stream
          assert_predicate output, :stdout?
        end

        def test_stdout_if_output_is_stdout
          cli_arguments = new_cli_arguments(["--output=STDOUT"])
          input = new_input(cli_arguments: cli_arguments)

          output = Ruboclean::Runner::Options::Output.new(cli_arguments: cli_arguments, input: input)

          assert_equal $stdout, output.stream
          assert_predicate output, :stdout?
        end

        def test_with_custom_output_flag_and_stdin_flag
          cli_arguments = new_cli_arguments(["--output=/tmp/output.yml", "--stdin"])
          input = new_input(cli_arguments: cli_arguments)

          output = Ruboclean::Runner::Options::Output.new(cli_arguments: cli_arguments, input: input)

          assert_equal Pathname.new("/tmp/output.yml"), output.stream
          refute_predicate output, :stdout?
        end

        private

        def new_input(...)
          Ruboclean::Runner::Options::Input.new(...)
        end

        def new_cli_arguments(...)
          Ruboclean::CliArguments.new(...)
        end
      end
    end
  end
end
