# frozen_string_literal: true

module Ruboclean
  # Reads command line arguments and exposes corresponding reader methods
  class CliArguments
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
      @silent ||= find_argument("--silent")
    end

    def preserve_comments?
      @preserve_comments ||= find_argument("--preserve-comments")
    end

    def preserve_paths?
      @preserve_paths ||= find_argument("--preserve-paths")
    end

    def verify?
      @verify ||= find_argument("--verify")
    end

    private

    attr_reader :command_line_arguments

    def find_path
      command_line_arguments.first.then do |argument|
        return Dir.pwd if argument.nil? || argument.start_with?("--")

        argument
      end
    end

    def find_argument(name)
      command_line_arguments.any? { |argument| argument == name }
    end
  end
end
