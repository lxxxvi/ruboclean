# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class ArgumentsTest < BaseTest
    def test_path_defaults
      Ruboclean::CliArguments.new.tap do |cli_arguments|
        assert_equal Dir.pwd.to_s, cli_arguments.path
        assert_predicate cli_arguments, :verbose?
        refute_predicate cli_arguments, :silent?
        refute_predicate cli_arguments, :preserve_comments?
      end
    end

    def test_path_custom
      assert_equal "foo/bar.yml", Ruboclean::CliArguments.new(["foo/bar.yml"]).path
    end

    def test_silent_custom
      Ruboclean::CliArguments.new(["--silent"]).tap do |cli_arguments|
        assert_equal Dir.pwd.to_s, cli_arguments.path
        refute_predicate cli_arguments, :verbose?
        assert_predicate cli_arguments, :silent?
      end
    end

    def test_preserve_comments
      Ruboclean::CliArguments.new(["--preserve-comments"]).tap do |cli_arguments|
        assert_equal Dir.pwd.to_s, cli_arguments.path
        assert_predicate cli_arguments, :preserve_comments?
      end
    end
  end
end
