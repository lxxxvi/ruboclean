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
               .then(&method(:convert_to_yaml))
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
      Orderer.new(configuration_hash).order
    end

    def cleanup_paths(configuration_hash)
      return configuration_hash if cli_arguments.preserve_paths?

      PathCleanup.new(configuration_hash, source_file_pathname.dirname).cleanup
    end

    def convert_to_yaml(configuration_hash)
      ToYamlConverter.new(configuration_hash, cli_arguments.preserve_comments?, source_yaml).to_yaml
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
  end
end
