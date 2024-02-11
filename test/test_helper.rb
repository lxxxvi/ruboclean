# frozen_string_literal: true

require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ruboclean"

require "fileutils"
require "pathname"

require "minitest/autorun"

class BaseTest < Minitest::Test
  TEST_FIXTURES_PATH = Pathname.new("test/fixtures")

  def fixture_file_path(file_name)
    TEST_FIXTURES_PATH.join(file_name)
  end

  def using_fixture_files(rubocop_configuration_file)
    Dir.mktmpdir do |tmpdir|
      tmp_project_root_path = Pathname.new(tmpdir).join("project_root")

      FileUtils.cp_r(fixture_file_path("project_root"), tmp_project_root_path)

      tmp_rubocop_configuration_path = tmp_project_root_path.join(".rubocop.yml")
      FileUtils.copy_file(fixture_file_path(rubocop_configuration_file), tmp_rubocop_configuration_path)

      yield tmp_rubocop_configuration_path.to_s, tmp_project_root_path.to_s
    end
  end
end
