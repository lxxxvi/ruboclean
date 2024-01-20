# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class RubocopConfigurationTest < BaseTest
    def test_order
      input = { "Rails" => { Enabled: false }, "AllCops" => { Enabled: true } }
      output = { "AllCops" => { Enabled: true }, "Rails" => { Enabled: false } }

      Ruboclean::RubocopConfiguration.new(input).order.tap do |ordered_output|
        assert_instance_of Hash, ordered_output
        assert_equal output.to_a, ordered_output.to_a
      end
    end

    def test_path_cleanup
      input = { SomeCop: { Include: ["some_other_file.rb", "test/fixtures/file_exists.rb", "lib/**/*.rb"] } }
      output = { SomeCop: { Include: ["test/fixtures/file_exists.rb", "lib/**/*.rb"] } }

      Ruboclean::RubocopConfiguration.new(input).path_cleanup.tap do |cleaned_output|
        assert_instance_of Hash, cleaned_output
        assert_equal output.to_a, cleaned_output.to_a
      end
    end

    def test_perform
      input = { "Rails" => { Exclude: ["does_not_exist.rb", "test/fixtures/file_exists.rb"] },
                "AllCops" => { Enabled: true } }
      output = { "AllCops" => { Enabled: true }, "Rails" => { Exclude: ["test/fixtures/file_exists.rb"] } }

      Ruboclean::RubocopConfiguration.new(input).perform.tap do |cleaned_output|
        assert_instance_of Hash, cleaned_output
        assert_equal output.to_a, cleaned_output.to_a
      end
    end

    def test_nil?
      assert_nil Ruboclean::RubocopConfiguration.new(nil)
    end
  end
end
