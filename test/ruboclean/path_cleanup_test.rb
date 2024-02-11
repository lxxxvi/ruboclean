# frozen_string_literal: true

require "test_helper"
require "ruboclean/path_cleanup"

module Ruboclean
  class PathCleanupTest < BaseTest
    def test_path_cleanup_includes
      input = { SomeCop: { Include: ["some_other_file.rb", "file_exists.rb", "lib/**/*.rb"] } }
      output = { SomeCop: { Include: ["file_exists.rb", "lib/**/*.rb"] } }

      assert_equal output, Ruboclean::PathCleanup.new(input, root_directory: root_directory).cleanup
    end

    def test_path_cleanup_excludes
      input = { SomeCop: { Exclude: ["config/**/*.rb", "file_exists.rb",
                                     "some_other_non_existent_file.rb", "not_here.rb"] } }
      output = { SomeCop: { Exclude: ["config/**/*.rb", "file_exists.rb"] } }

      assert_equal output, Ruboclean::PathCleanup.new(input, root_directory: root_directory).cleanup
    end

    # rubocop:disable Metrics/MethodLength
    def test_path_cleanup_include_and_exclude
      input = {
        SomeCop: {
          Include: ["lib/**/*.rb", "not_here.rb"],
          Exclude: ["config/**/*.rb", "file_exists.rb", "some_other_non_existent_file.rb"],
          EnforcedStyle: "something"
        },
        SomeOtherCop: {
          EnforcedStyle: "something"
        }
      }
      output = {
        SomeCop: {
          Include: ["lib/**/*.rb"],
          Exclude: ["config/**/*.rb", "file_exists.rb"],
          EnforcedStyle: "something"
        },
        SomeOtherCop: {
          EnforcedStyle: "something"
        }
      }

      assert_equal output, Ruboclean::PathCleanup.new(input, root_directory: root_directory).cleanup
    end
    # rubocop:enable Metrics/MethodLength

    private

    def root_directory
      Pathname.new("test/fixtures/project_root")
    end
  end
end
