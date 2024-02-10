# frozen_string_literal: true

module Ruboclean
  # Proxy for invoking the cleaning
  class Runner
    def initialize(cli_arguments)
      @cli_arguments = cli_arguments
    end

    def run!
      rubocop_configuration_path = RubocopConfigurationPath.new(cli_arguments.path)
      rubocop_configuration = rubocop_configuration_path.load

      return if rubocop_configuration.nil?

      rubocop_configuration_path.write(rubocop_configuration.perform, preserve_comments: cli_arguments.preserve_comments?)
    end

    private

    attr_reader :cli_arguments
  end
end
