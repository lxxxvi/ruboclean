# frozen_string_literal: true

require "test_helper"
require "ruboclean/path_cleanup"

module Ruboclean
  class PathCleanupTest < BaseTest
    def test_path_cleanup_include_and_exclude
      assert_equal output, Ruboclean::PathCleanup.new(input, root_directory).cleanup
    end

    private

    def root_directory
      Pathname.new("test/fixtures/project_root")
    end

    # rubocop:disable Metrics/MethodLength
    def input
      {
        CopWithIncludeAndExclude: {
          Include: ["bin/**/*", "lib/**/*.rb", "not_here.rb"],
          Exclude: ["config/**/*", "lib/**/*.rb", "file_exists.rb", "some_other_non_existent_file.rb"],
          EnforcedStyle: "something"
        },
        CopWithoutIncludeOrExclude: {
          EnforcedStyle: "something"
        },
        CopWhereIncludeGetsEliminated: {
          Include: ["bin/**/*"],
          PreventsCopFromElimination: "yay!"
        },
        CopGetsCompletelyEliminated: {
          Include: ["bin/**/*"],
          Exclude: ["config/**/*"]
        }
      }
    end

    def output
      {
        CopWithIncludeAndExclude: {
          Include: ["lib/**/*.rb"],
          Exclude: ["lib/**/*.rb", "file_exists.rb"],
          EnforcedStyle: "something"
        },
        CopWithoutIncludeOrExclude: {
          EnforcedStyle: "something"
        },
        CopWhereIncludeGetsEliminated: {
          PreventsCopFromElimination: "yay!"
        }
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end
