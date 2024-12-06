# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class CliArgumentsTest < BaseTest
    def test_input
      assert_nil Ruboclean::CliArguments.new.input
      assert_equal "/some/value", Ruboclean::CliArguments.new(["/some/value"]).input
    end

    def test_stdin
      refute_predicate Ruboclean::CliArguments.new, :stdin?
      assert_predicate Ruboclean::CliArguments.new(["--stdin"]), :stdin?
    end

    def test_output
      assert_nil Ruboclean::CliArguments.new.output
      assert_equal "/some/value", Ruboclean::CliArguments.new(["--output=/some/value"]).output
      assert_equal "STDOUT", Ruboclean::CliArguments.new(["--output=STDOUT"]).output
    end

    def test_silent
      refute_predicate Ruboclean::CliArguments.new, :silent?
      assert_predicate Ruboclean::CliArguments.new(["--silent"]), :silent?
    end

    def test_preserve_comments
      refute_predicate Ruboclean::CliArguments.new, :preserve_comments?
      assert_predicate Ruboclean::CliArguments.new(["--preserve-comments"]), :preserve_comments?
    end

    def test_preserve_paths
      refute_predicate Ruboclean::CliArguments.new, :preserve_paths?
      assert_predicate Ruboclean::CliArguments.new(["--preserve-paths"]), :preserve_paths?
    end

    def test_verify
      refute_predicate Ruboclean::CliArguments.new, :verify?
      assert_predicate Ruboclean::CliArguments.new(["--verify"]), :verify?
    end

    def test_invalid_argument
      error = assert_raises(ArgumentError) do
        Ruboclean::CliArguments.new(["--some-flag"]).output # we need to hit any flag_arguments
      end

      assert_equal "invalid argument '--some-flag'", error.message
    end
  end
end
