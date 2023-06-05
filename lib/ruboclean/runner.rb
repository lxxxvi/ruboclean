# frozen_string_literal: true

module Ruboclean
  # Proxy for invoking the cleaning
  class Runner
    def initialize(arguments)
      @arguments = arguments
    end

    def run!
      rubocop_configuration_path = RubocopConfigurationPath.new(arguments.path)
      rubocop_configuration = rubocop_configuration_path.load

      return if rubocop_configuration.nil?

      rubocop_configuration_path.write(rubocop_configuration.order)
    end

    private

    attr_reader :arguments
  end
end
