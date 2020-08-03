# frozen_string_literal: true

require 'test_helper'
require 'fileutils'
require 'pathname'

class RubocleanTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ruboclean::VERSION
  end

  def test_it_cleans_rubocop_configuration
    using_fixture_file('input.yml') do |rubocop_configuration_path|
      assert_equal fixture_file_path('expected_output.yml').read,
                   rubocop_configuration_path.read
    end
  end

  def test_it_cleans_rubocop_configuration_without_require_block
    using_fixture_file('input_without_require_block.yml') do |rubocop_configuration_path|
      assert_equal fixture_file_path('expected_output_without_require_block.yml').read,
                   rubocop_configuration_path.read
    end
  end

  private

  def fixture_file_path(file_name)
    TEST_FIXTURES_PATH.join(file_name)
  end

  def using_fixture_file(file_name)
    Dir.mktmpdir do |tmpdir|
      tempdir_path = Pathname.new(tmpdir)
      rubocop_configuration_path = tempdir_path.join('.rubocop.yml')
      FileUtils.copy_file(fixture_file_path(file_name), rubocop_configuration_path)
      Ruboclean.run(tempdir_path)

      yield rubocop_configuration_path
    end
  end
end
