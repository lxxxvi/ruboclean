# frozen_string_literal: true

module Ruboclean
  # Reads command line arguments and exposes corresponding reader methods
  class CliArguments
    FLAG_DEFAULTS = {
      "--output" => nil,
      "--silent" => false,
      "--preserve-comments" => false,
      "--preserve-paths" => false,
      "--verify" => false
    }.freeze

    def initialize(command_line_arguments = [])
      @command_line_arguments = Array(command_line_arguments)
    end

    def path
      @path ||= find_path
    end

    def output_path
      flag_arguments.fetch("--output")
    end

    def verbose?
      !silent?
    end

    def silent?
      flag_arguments.fetch("--silent")
    end

    def preserve_comments?
      flag_arguments.fetch("--preserve-comments")
    end

    def preserve_paths?
      flag_arguments.fetch("--preserve-paths")
    end

    def verify?
      flag_arguments.fetch("--verify")
    end

    private

    attr_reader :command_line_arguments

    def find_path
      command_line_arguments.first.then do |argument|
        return Dir.pwd if argument.nil? || argument.start_with?("--")

        argument
      end
    end

    def flag_arguments
      @flag_arguments ||= FLAG_DEFAULTS.dup.merge(custom_flag_arguments)
    end

    def custom_flag_arguments
      command_line_arguments.each_with_object({}) do |item, hash|
        next unless item.start_with?("--")

        flag_name, flag_value = item.split("=")

        raise ArgumentError, "invalid argument '#{item}'" unless FLAG_DEFAULTS.include?(flag_name)

        flag_default_value = FLAG_DEFAULTS[flag_name]

        hash[flag_name] = flag_value

        # Subject to change: We may need to find another way to determine if an argument has Boolean characteristics
        hash[flag_name] = !flag_value if flag_default_value.is_a?(FalseClass)
      end
    end
  end
end
