# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class ToYamlConverterTest < BaseTest
    def test_to_yaml_without_comments
      converter = Ruboclean::ToYamlConverter.new(configuration_hash, false, source_yaml)

      assert_equal expected_yaml_without_comments, converter.to_yaml
    end

    def test_to_yaml_with_preserving_comments
      converter = Ruboclean::ToYamlConverter.new(configuration_hash, true, source_yaml)

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
