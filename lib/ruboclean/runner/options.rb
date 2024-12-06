# frozen_string_literal: true

module Ruboclean
  class Runner
    # Consolidates cli_arguments with "smart" defaults
    class Options
      def initialize(cli_arguments:)
        @cli_arguments = cli_arguments
      end

      def input_stream
        input.stream
      end

      def input_path
        input.input_path
      end

      def output_stream
        output.stream
      end

      def verbose?
        !silent?
      end

      def silent?
        cli_arguments.silent? || output.stdout?
      end

      def preserve_comments?
        cli_arguments.preserve_comments?
      end

      def preserve_paths?
        cli_arguments.preserve_paths?
      end

      def verify?
        cli_arguments.verify?
      end

      private

      attr_reader :cli_arguments

      def input
        @input ||= Ruboclean::Runner::Options::Input.new(cli_arguments: cli_arguments)
      end

      def output
        @output ||= Ruboclean::Runner::Options::Output.new(cli_arguments: cli_arguments, input: input)
      end
    end
  end
end
