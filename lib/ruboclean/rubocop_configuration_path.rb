# frozen_string_literal: true

require "pathname"
require "yaml"

module Ruboclean
  # Interface for reading and writing the `.rubocop.yml` file
  class RubocopConfigurationPath
    PERMITTED_CLASSES = [Regexp, Symbol].freeze

    # Thrown if given path is invalid
    class InvalidPathError < StandardError
      def initialize(path)
        super("path does not exist: '#{path}'")
      end
    end

    def initialize(path)
      input_path = Pathname.new(path)

      @rubocop_configuration_path = if input_path.directory?
                                      input_path.join(".rubocop.yml")
                                    else
                                      input_path
                                    end

      raise InvalidPathError, @rubocop_configuration_path unless @rubocop_configuration_path.exist?
    end

    def load
      Ruboclean::RubocopConfiguration.new(load_yaml)
    end

    def write(rubocop_configuration, preserve_comments: false)
      output_yaml = sanitize_yaml(rubocop_configuration.to_yaml)
      output_yaml = preserve_preceding_comments(source_yaml, output_yaml) if preserve_comments
      @rubocop_configuration_path.write(output_yaml)
    end

    private

    def sanitize_yaml(data)
      data.gsub(/^([a-zA-Z]+)/, "\n\\1")
    end

    def load_yaml
      YAML.safe_load(source_yaml, permitted_classes: PERMITTED_CLASSES)
    end

    def source_yaml
      @source_yaml ||= @rubocop_configuration_path.read
    end

    def preserve_preceding_comments(source, target)
      target.dup.tap do |output|
        source.scan(/(((^ *#.*\n|^\s*\n)+)(?![\s#]).+)/) do |groups|
          config_keys_with_preceding_lines = groups.first
          *preceding_lines, config_key = config_keys_with_preceding_lines.split("\n")

          next if preceding_lines.all?(:empty?)
          next if config_key.gsub(/\s/, "").empty?

          output.sub!(/^#{config_key}$/, config_keys_with_preceding_lines.strip)
        end
      end
    end
  end
end
