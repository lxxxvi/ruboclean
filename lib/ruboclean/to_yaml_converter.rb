# frozen_string_literal: true

module Ruboclean
  # Converts the configuration hash to YAML and applies modifications on it, if requested
  class ToYamlConverter
    def initialize(configuration_hash, source_yaml, options:)
      @configuration_hash = configuration_hash
      @source_yaml = source_yaml
      @options = options
    end

    def to_yaml
      target_yaml = sanitize_yaml(configuration_hash.transform_keys(&:to_s).to_yaml)

      return target_yaml unless options.preserve_comments?

      preserve_preceding_comments(source_yaml, target_yaml)
    end

    private

    attr_reader :configuration_hash, :source_yaml, :options

    def sanitize_yaml(data)
      data.gsub(/^([a-zA-Z]+)/, "\n\\1")
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
