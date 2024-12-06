# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class Runner
    class OptionsTest < BaseTest
      def test_input_stream_and_input_path
        cli_arguments = new_cli_arguments

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        assert_instance_of Pathname, options.input_stream
        assert_instance_of Pathname, options.input_path
      end

      def test_output_stream
        cli_arguments = new_cli_arguments

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        assert_instance_of Pathname, options.input_stream
      end

      def test_verbose_and_silent_default
        cli_arguments = new_cli_arguments

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        assert_predicate options, :verbose?
        refute_predicate options, :silent?
      end

      def test_verbose_and_silent_directly_forced
        cli_arguments = new_cli_arguments(["--silent"])

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        refute_predicate options, :verbose?
        assert_predicate options, :silent?
      end

      def test_verbose_and_silent_indirectly_forced
        cli_arguments = new_cli_arguments(["--stdin"])

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        refute_predicate options, :verbose?
        assert_predicate options, :silent?
      end

      def test_preserve_comments_default
        cli_arguments = new_cli_arguments

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        refute_predicate options, :preserve_comments?
      end

      def test_preserve_comments_forced
        cli_arguments = new_cli_arguments(["--preserve-comments"])

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        assert_predicate options, :preserve_comments?
      end

      def test_preserve_paths_default
        cli_arguments = new_cli_arguments

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        refute_predicate options, :preserve_paths?
      end

      def test_preserve_paths_forced
        cli_arguments = new_cli_arguments(["--preserve-paths"])

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        assert_predicate options, :preserve_paths?
      end

      def test_verify_default
        cli_arguments = new_cli_arguments

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        refute_predicate options, :verify?
      end

      def test_verify_forced
        cli_arguments = new_cli_arguments(["--verify"])

        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        assert_predicate options, :verify?
      end

      private

      def new_cli_arguments(...)
        Ruboclean::CliArguments.new(...)
      end
    end
  end
end
