# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class ToYamlConverterTest < BaseTest
    def test_to_yaml_without_comments
      cli_arguments = Ruboclean::CliArguments.new
      options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

      converter = Ruboclean::ToYamlConverter.new(configuration_hash, source_yaml, options: options)

      assert_equal expected_yaml_without_comments, converter.to_yaml
    end

    def test_to_yaml_with_preserving_comments
      cli_arguments = Ruboclean::CliArguments.new(["--preserve-comments"])
      options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

      converter = Ruboclean::ToYamlConverter.new(configuration_hash, source_yaml, options: options)

      assert_equal expected_yaml_with_preserved_comments, converter.to_yaml
    end

    private

    def configuration_hash
      { "Foo" => { "Bar" => "Baz" } }
    end

    def source_yaml
      <<~YAML
        # A glorious comment
        Foo:
          Bar: Baz
      YAML
    end

    def expected_yaml_without_comments
      <<~YAML
        ---

        Foo:
          Bar: Baz
      YAML
    end

    def expected_yaml_with_preserved_comments
      <<~YAML
        ---

        # A glorious comment
        Foo:
          Bar: Baz
      YAML
    end
  end
end
