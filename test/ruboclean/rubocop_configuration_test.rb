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

    def test_nil?
      assert_nil Ruboclean::RubocopConfiguration.new(nil)
    end
  end
end
