# frozen_string_literal: true

module Ruboclean
  class Runner
    class Options
      # Determines the output stream
      class Output
        def initialize(cli_arguments:, input:)
          @cli_arguments = cli_arguments
          @input = input
        end

        def stream
          @stream ||= determine_output_stream
        end

        def stdout?
          (cli_arguments.output.nil? && input.stdin?) ||
            cli_arguments.output == "STDOUT"
        end

        private

        attr_reader :cli_arguments, :input

        def determine_output_stream
          return $stdout if stdout?

          output_path
        end

        def output_path
          @output_path ||= find_output_path
        end

        def find_output_path
          return input.stream if cli_arguments.output.nil?

          pathname = Pathname.new(cli_arguments.output)
          pathname = Pathname.new(Dir.pwd).join(pathname) if pathname.relative?

          return pathname unless pathname.directory?

          raise ArgumentError, "output path (--output=#{pathname}) cannot be a directory"
        end
      end
    end
  end
end
