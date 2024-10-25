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
               .then(&method(:write_stream!))
               .then(&method(:changed?))
    end

    def changed?(target_yaml)
      target_yaml != source_yaml
    end

    def verbose?
      cli_arguments.verbose?
    end

    def verify?
      cli_arguments.verify?
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

    def write_stream!(target_yaml)
      target_yaml.tap do |content|
        StreamWriter.new(target_file_pathname, content).write! unless verify?
      end
    end

    # TODO: Find a better place to compute source_file_pathname and target_file_pathname
    #       Preferrably it should happen early in the lifecycle, as it includes (and raises) argument validations
    def source_file_pathname
      @source_file_pathname ||= find_source_file_pathname
    end

    def target_file_pathname
      @target_file_pathname ||= find_target_file_pathname
    end

    def find_source_file_pathname
      source_path = Pathname.new(cli_arguments.path)

      source_path = source_path.join(".rubocop.yml") if source_path.directory?

      return source_path if source_path.exist?

      raise ArgumentError, "path does not exist: '#{source_path}'"
    end

    def find_target_file_pathname
      return source_file_pathname if cli_arguments.output_path.nil?

      target_path = Pathname.new(cli_arguments.output_path)
      target_path = Pathname.new(Dir.pwd).join(target_path) if target_path.relative?

      return target_path unless target_path.directory?

      raise ArgumentError, "output path (--output=#{target_path}) cannot be a directory"
    end
  end
end
