# frozen_string_literal: true

module Ruboclean
  # Orders the items within the groups alphabetically
  class Logger
    def initialize(log_level = :verbose)
      raise ArgumentError, "Invalid log level" unless %i[verbose none].include?(log_level)

      @log_level = log_level
    end

    def verbose(message)
      case @log_level
      when :verbose
        print message
      end
    end
  end
end
