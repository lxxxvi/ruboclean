# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class ArgumentsTest < BaseTest
    def test_path_defaults
      Ruboclean::Arguments.new.tap do |arguments|
        assert_equal Dir.pwd.to_s, arguments.path
        assert_predicate arguments, :verbose?
        refute_predicate arguments, :silent?
        refute_predicate arguments, :preserve_comments?
      end
    end

    def test_path_custom
      assert_equal "foo/bar.yml", Ruboclean::Arguments.new(["foo/bar.yml"]).path
    end

    def test_silent_custom
      Ruboclean::Arguments.new(["--silent"]).tap do |arguments|
        assert_equal Dir.pwd.to_s, arguments.path
        refute_predicate arguments, :verbose?
        assert_predicate arguments, :silent?
      end
    end

    def test_preserve_comments
      Ruboclean::Arguments.new(["--preserve-comments"]).tap do |arguments|
        assert_equal Dir.pwd.to_s, arguments.path
        assert_predicate arguments, :preserve_comments?
      end
    end
  end
end
