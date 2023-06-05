# frozen_string_literal: true

module Ruboclean
  # Reads command line arguments and exposes corresponding reader methods
  class Arguments
    def initialize(command_line_arguments = [])
      @command_line_arguments = Array(command_line_arguments)
    end

    def path
      @path ||= find_path
    end

    def verbose?
      !silent?
    end

    def silent?
      @silent ||= find_silent
    end

    private

    attr_reader :command_line_arguments

    def find_path
      command_line_arguments.first.then do |argument|
        return Dir.pwd if argument.nil? || argument.start_with?("--")

        argument
      end
    end

    def find_silent
      command_line_arguments.any? do |argument|
        argument == "--silent"
      end
    end
  end
end
