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

  def using_fixture_file(file_name)
    Dir.mktmpdir do |tmpdir|
      tempdir_path = Pathname.new(tmpdir)
      fixture_path = tempdir_path.join(".rubocop.yml")
      FileUtils.copy_file(fixture_file_path(file_name), fixture_path)

      yield fixture_path.to_s, tmpdir
    end
  end
end
