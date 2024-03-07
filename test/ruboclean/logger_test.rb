# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class LoggerTest < BaseTest
    def test_initialize
      assert_raises(ArgumentError) do
        Ruboclean::Logger.new(:invalid)
      end
    end

    def test_verbose
      assert_output(/^message$/) do
        Ruboclean::Logger.new(:verbose).verbose("message")
      end

      assert_output(/^$/) do
        Ruboclean::Logger.new(:none).verbose("message")
      end
    end
  end
end
