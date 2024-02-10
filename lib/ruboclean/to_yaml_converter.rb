# frozen_string_literal: true

module Ruboclean
  class ToYamlConverter
    def initialize(configuration_hash, cli_arguments, source_yaml)
      @configuration_hash = configuration_hash
      @cli_arguments = cli_arguments
      @source_yaml = source_yaml
    end

    def to_yaml
      target_yaml = sanitize_yaml(configuration_hash.to_yaml)

      return target_yaml unless cli_arguments.preserve_comments?

      preserve_preceding_comments(source_yaml, target_yaml)
    end

    private

    attr_reader :configuration_hash, :cli_arguments, :source_yaml

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
