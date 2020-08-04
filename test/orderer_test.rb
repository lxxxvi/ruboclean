# frozen_string_literal: true

require 'test_helper'

class OrdererTest < BaseTest
  def test_order_all
    input = { 'Foo/Foo' => nil, 'Foo/Faa' => nil, 'Baz' => nil, 'Bar' => nil, 'require' => nil }
    output = { 'require' => nil, 'Bar' => nil, 'Baz' => nil, 'Foo/Faa' => nil, 'Foo/Foo' => nil }

    assert_ordered input, output
  end

  def test_order_without_require
    input = { 'Foo/Foo' => nil, 'Foo/Faa' => nil, 'Baz' => nil, 'Bar' => nil }
    output = { 'Bar' => nil, 'Baz' => nil, 'Foo/Faa' => nil, 'Foo/Foo' => nil }

    assert_ordered input, output
  end

  def test_order_without_namespaces
    input = { 'Foo/Foo' => nil, 'Foo/Faa' => nil, 'require' => nil }
    output = { 'require' => nil, 'Foo/Faa' => nil, 'Foo/Foo' => nil }

    assert_ordered input, output
  end

  def test_order_without_cops
    input = { 'Baz' => nil, 'Bar' => nil, 'require' => nil }
    output = { 'require' => nil, 'Bar' => nil, 'Baz' => nil }

    assert_ordered input, output
  end

  private

  def assert_ordered(input, expected_output)
    rubocop_config = Ruboclean::RubocopConfiguration.new(input)
    orderer = Ruboclean::Orderer.new(rubocop_config)

    orderer.order.tap do |ordered_rubocop_config|
      assert_equal Ruboclean::RubocopConfiguration, ordered_rubocop_config.class
      assert_equal expected_output.to_a, ordered_rubocop_config.rubocop_config.to_a
    end
  end
end
