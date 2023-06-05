# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class OrdererTest < BaseTest
    def test_order_all
      input = { "Foo/Foo" => nil, "Foo/Faa" => nil, "Baz" => nil,
                "Bar" => nil, "require" => nil, "inherit_from" => nil }
      output = { "inherit_from" => nil, "require" => nil, "Bar" => nil,
                 "Baz" => nil, "Foo/Faa" => nil, "Foo/Foo" => nil }

      assert_ordered input, output
    end

    def test_order_without_require
      input = { "Foo/Foo" => nil, "Foo/Faa" => nil, "Baz" => nil, "Bar" => nil }
      output = { "Bar" => nil, "Baz" => nil, "Foo/Faa" => nil, "Foo/Foo" => nil }

      assert_ordered input, output
    end

    def test_order_without_namespaces
      input = { "Foo/Foo" => nil, "Foo/Faa" => nil, "require" => nil }
      output = { "require" => nil, "Foo/Faa" => nil, "Foo/Foo" => nil }

      assert_ordered input, output
    end

    def test_order_without_cops
      input = { "Baz" => nil, "Bar" => nil, "require" => nil }
      output = { "require" => nil, "Bar" => nil, "Baz" => nil }

      assert_ordered input, output
    end

    private

    def assert_ordered(input, expected_output)
      orderer = Ruboclean::Orderer.new(input)

      orderer.order.tap do |result|
        assert_equal expected_output.to_a, result.to_a
      end
    end
  end
end
