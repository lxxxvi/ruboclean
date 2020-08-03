# frozen_string_literal: true

require 'pathname'
require 'yaml'

module Ruboclean
  # Interface for reading and writing the `.rubocop.yml` file
  class RubocopConfigurationPath
    def initialize(path)
      input_path = Pathname.new(path)

      @rubocop_configuration_path = if input_path.directory?
                                      input_path.join('.rubocop.yml')
                                    else
                                      input_path
                                    end

      raise 'path does not exist' unless @rubocop_configuration_path.exist?
    end

    def write(rubocop_configuration)
      output = rubocop_configuration.to_yaml
                                    .gsub(/^([a-zA-Z]+)/, "\n\\1")

      @rubocop_configuration_path.write(output)
    end

    def load
      Ruboclean::RubocopConfiguration.new(load_yaml)
    end

    private

    def load_yaml
      YAML.safe_load(@rubocop_configuration_path.read)
    end
  end
end
