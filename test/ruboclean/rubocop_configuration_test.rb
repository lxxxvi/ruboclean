# frozen_string_literal: true

require "test_helper"

class Ruboclean::RubocopConfigurationTest < BaseTest
  def test_order
    input = { "Rails" => { Enabled: false }, "AllCops" => { Enabled: true } }
    output = { "AllCops" => { Enabled: true }, "Rails" => { Enabled: false } }

    Ruboclean::RubocopConfiguration.new(input).order.tap do |ordered_output|
      assert_equal Hash, ordered_output.class
      assert_equal output.to_a, ordered_output.to_a
    end
  end
end
