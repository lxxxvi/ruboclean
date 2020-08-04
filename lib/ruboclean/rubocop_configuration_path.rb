# frozen_string_literal: true

require 'pathname'
require 'yaml'

module Ruboclean
  # Interface for reading and writing the `.rubocop.yml` file
  class RubocopConfigurationPath
    # Thrown if given path is invalid
    class InvalidPathError < StandardError
      def initialize(path)
        super "path does not exist: '#{path}'"
      end
    end

    def initialize(path)
      input_path = Pathname.new(path)

      @rubocop_configuration_path = if input_path.directory?
                                      input_path.join('.rubocop.yml')
                                    else
                                      input_path
                                    end

      raise InvalidPathError, @rubocop_configuration_path unless @rubocop_configuration_path.exist?
    end

    def load
      Ruboclean::RubocopConfiguration.new(load_yaml)
    end

    def write(rubocop_configuration)
      output = sanitize_yaml(rubocop_configuration.to_yaml)
      @rubocop_configuration_path.write(output)
    end

    private

    def sanitize_yaml(data)
      data.gsub(/^([a-zA-Z]+)/, "\n\\1")
    end

    def load_yaml
      YAML.safe_load(@rubocop_configuration_path.read)
    end
  end
end
