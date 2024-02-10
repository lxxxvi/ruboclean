# frozen_string_literal: true

require "pathname"
require "yaml"

module Ruboclean
  # Entry point for processing
  class Runner
    def initialize(args = [])
      @cli_arguments = CliArguments.new(args)
    end

    def run!
      return if source_file_pathname.empty?

      load_file.then(&method(:order))
               .then(&method(:cleanup_paths))
               .then(&method(:preserve_comments))
               .then(&method(:write_file!))
    end

    def verbose?
      cli_arguments.verbose?
    end

    def path
      cli_arguments.path
    end

    private

    attr_reader :cli_arguments

    def source_yaml
      @source_yaml ||= source_file_pathname.read
    end

    def load_file
      YAML.safe_load(source_yaml, permitted_classes: [Regexp])
    end

    def order(configuration_hash)
      Ruboclean::Orderer.new(configuration_hash).order
    end

    def cleanup_paths(configuration_hash)
      Ruboclean::PathCleanup.new(configuration_hash).cleanup
    end

    def preserve_comments(configuration_hash)
      target_yaml = sanitize_yaml(configuration_hash.to_yaml)

      return target_yaml unless cli_arguments.preserve_comments?

      preserve_preceding_comments(source_yaml, target_yaml)
    end

    def write_file!(target_yaml)
      source_file_pathname.write(target_yaml)
    end

    def source_file_pathname
      @source_file_pathname ||= find_source_file_pathname
    end

    def find_source_file_pathname
      source_path = Pathname.new(cli_arguments.path)

      source_path = source_path.join(".rubocop.yml") if source_path.directory?

      return source_path if source_path.exist?

      raise ArgumentError, "path does not exist: '#{source_path}'"
    end

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
