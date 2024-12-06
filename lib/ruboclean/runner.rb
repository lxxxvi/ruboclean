# frozen_string_literal: true

require "pathname"
require "yaml"

module Ruboclean
  # Entry point for processing
  class Runner
    def initialize(command_line_arguments = [])
      cli_arguments = CliArguments.new(command_line_arguments)
      @options = Runner::Options.new(cli_arguments: cli_arguments)
    end

    def run!
      return if source_yaml.empty?

      parse_yaml.then(&method(:order))
                .then(&method(:cleanup_paths))
                .then(&method(:convert_to_yaml))
                .then(&method(:write_stream!))
                .then(&method(:changed?))
    end

    def changed?(target_yaml)
      target_yaml != source_yaml
    end

    def verbose?
      options.verbose?
    end

    def verify?
      options.verify?
    end

    def input_path
      options.input_path
    end

    private

    attr_reader :options

    def source_yaml
      @source_yaml ||= options.input_stream.read
    end

    def parse_yaml
      YAML.safe_load(source_yaml, permitted_classes: [Regexp])
    end

    def order(configuration_hash)
      Orderer.new(configuration_hash).order
    end

    def cleanup_paths(configuration_hash)
      PathCleanup.new(configuration_hash, options: options).cleanup
    end

    def convert_to_yaml(configuration_hash)
      ToYamlConverter.new(configuration_hash, source_yaml, options: options).to_yaml
    end

    def write_stream!(target_yaml)
      StreamWriter.new(target_yaml, options: options).write!
    end
  end
end
