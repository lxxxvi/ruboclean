# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class RunnerTest < BaseTest
    def test_run_without_require_block
      using_fixture_file("01_input_without_require_block.yml") do |fixture_path|
        arguments = Ruboclean::Arguments.new(Array(fixture_path))
        Ruboclean::Runner.new(arguments).run!

        assert_equal fixture_file_path("01_expected_output_without_require_block.yml").read,
                     Pathname.new(fixture_path).read
      end
    end
  end
end
