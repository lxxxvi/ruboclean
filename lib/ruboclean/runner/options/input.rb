# frozen_string_literal: true

module Ruboclean
  class Runner
    class Options
      # Determines the input stream
      class Input
        def initialize(cli_arguments:)
          @cli_arguments = cli_arguments
        end

        def stream
          @stream ||= determine_input_stream
        end

        def input_path
          @input_path ||= find_input_path
        end

        def stdin?
          cli_arguments.stdin?
        end

        private

        attr_reader :cli_arguments

        def determine_input_stream
          return $stdin if stdin?

          return input_path if input_path.exist?

          raise ArgumentError, "input path does not exist: '#{input_path}'"
        end

        def find_input_path
          pathname = cli_arguments.input.nil? ? Pathname.new(Dir.pwd) : Pathname.new(cli_arguments.input)
          pathname = pathname.join(".rubocop.yml") if pathname.directory?
          pathname
        end
      end
    end
  end
end
