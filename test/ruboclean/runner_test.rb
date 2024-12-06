# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class RunnerTest < BaseTest # rubocop:disable Metrics/ClassLength
    def test_run_without_arguments
      using_fixture_files("00_input.yml") do |fixture_path, directory_path|
        changed = Dir.chdir(directory_path) do
          Ruboclean::Runner.new.run!
        end

        assert_equal(
          fixture_file_path("00_expected_output.yml").read,
          Pathname.new(fixture_path).read
        )
        assert changed
      end
    end

    def test_run_without_arguments_read_from_stdin
      stdin_content = "---\n\nSomeConfig:\n  Enabled: true\n"

      using_fixture_files("00_input.yml") do |_fixture_path, directory_path|
        Dir.chdir(directory_path) do
          assert_output(stdin_content) do
            $stdin.stub :read, stdin_content do
              Ruboclean::Runner.new(["--stdin"]).run!
            end
          end
        end
      end
    end

    def test_run_with_explicit_file_path
      using_fixture_files("00_input.yml") do |fixture_path|
        arguments = [fixture_path]
        Ruboclean::Runner.new(arguments).run!

        assert_equal(
          fixture_file_path("00_expected_output.yml").read,
          Pathname.new(fixture_path).read
        )
      end
    end

    def test_run_with_directory_path
      using_fixture_files("00_input.yml") do |fixture_path, directory_path|
        arguments = [directory_path]
        Ruboclean::Runner.new(arguments).run!

        assert_equal(
          fixture_file_path("00_expected_output.yml").read,
          Pathname.new(fixture_path).read
        )
      end
    end

    def test_return_value_when_already_sorted
      using_fixture_files("00_expected_output.yml") do |fixture_path, directory_path|
        changed = Dir.chdir(directory_path) do
          Ruboclean::Runner.new.run!
        end

        assert_equal(
          fixture_file_path("00_expected_output.yml").read,
          Pathname.new(fixture_path).read
        )
        refute changed
      end
    end

    def test_run_with_explicit_file_path_that_does_not_exist
      arguments = ["does-not-exist"]

      error = assert_raises ArgumentError do
        Ruboclean::Runner.new(arguments).run!
      end

      assert_equal "input path does not exist: 'does-not-exist'", error.message
    end

    def test_run_with_directory_path_that_does_not_have_rubocop_yaml
      arguments = ["/tmp"]

      error = assert_raises ArgumentError do
        Ruboclean::Runner.new(arguments).run!
      end

      assert_equal "input path does not exist: '/tmp/.rubocop.yml'", error.message
    end

    def test_run_without_require_block
      using_fixture_files("01_input_without_require_block.yml") do |fixture_path|
        arguments = [fixture_path]
        Ruboclean::Runner.new(arguments).run!

        assert_equal(
          fixture_file_path("01_expected_output_without_require_block.yml").read,
          Pathname.new(fixture_path).read
        )
      end
    end

    def test_run_with_output_argument_absolute_path
      using_fixture_files("00_input.yml") do |fixture_path|
        output_pathname = Pathname.new(fixture_path).dirname.join("custom_output_path.yml")
        arguments = [fixture_path, "--output=#{output_pathname}"]
        Ruboclean::Runner.new(arguments).run!

        assert_predicate output_pathname, :exist?

        assert_equal(
          fixture_file_path("00_expected_output.yml").read,
          output_pathname.read
        )
      end
    end

    def test_run_with_output_argument_relative_path # rubocop:disable Metrics/MethodLength
      # we need to read it here, because we're leaving the working directory (see `Dir.chdir` below)
      expected_target_file_content = fixture_file_path("00_expected_output.yml").read

      using_fixture_files("00_input.yml") do |fixture_path|
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir) do
            arguments = [fixture_path, "--output=relative_path.yml"]

            Ruboclean::Runner.new(arguments).run!

            output_pathname = Pathname.new(tmpdir).join("relative_path.yml")

            assert_predicate output_pathname, :exist?
            assert_equal expected_target_file_content,
                         output_pathname.read
          end
        end
      end
    end

    def test_run_with_output_argument_stdout
      using_fixture_files("00_input.yml") do |fixture_path|
        arguments = [fixture_path, "--output=STDOUT"]

        assert_output(fixture_file_path("00_expected_output.yml").read) do
          Ruboclean::Runner.new(arguments).run!
        end
      end
    end

    def test_run_with_output_argument_overrides_a_file
      using_fixture_files("00_input.yml") do |fixture_path|
        output_pathname = Pathname.new(fixture_path).dirname.join("custom_output_path.yml")
        arguments = [fixture_path, "--output=#{output_pathname}"]
        output_pathname.write("file content before")

        Ruboclean::Runner.new(arguments).run!

        assert_equal(
          fixture_file_path("00_expected_output.yml").read,
          output_pathname.read
        )
      end
    end

    def test_run_with_output_argument_raises_if_target_exists_as_directory
      using_fixture_files("00_input.yml") do |fixture_path|
        output_pathname = Pathname.new(fixture_path).dirname.join("some_directory")
        arguments = [fixture_path, "--output=#{output_pathname}"]
        output_pathname.mkdir

        error = assert_raises ArgumentError do
          Ruboclean::Runner.new(arguments).run!
        end

        assert_equal "output path (--output=#{output_pathname}) cannot be a directory",
                     error.message
      end
    end

    def test_run_with_preserve_comments_flag
      using_fixture_files("00_input.yml") do |fixture_path|
        arguments = [fixture_path, "--preserve-comments"]
        Ruboclean::Runner.new(arguments).run!

        assert_equal fixture_file_path("00_expected_output_with_preserved_comments.yml").read,
                     Pathname.new(fixture_path).read
      end
    end

    def test_run_with_preserve_paths_flag
      using_fixture_files("00_input.yml") do |fixture_path|
        arguments = [fixture_path, "--preserve-paths"]
        Ruboclean::Runner.new(arguments).run!

        assert_equal fixture_file_path("00_expected_output_with_preserved_paths.yml").read,
                     Pathname.new(fixture_path).read
      end
    end

    def test_run_with_verify_flag
      using_fixture_files("00_input.yml") do |fixture_path|
        arguments = [fixture_path, "--verify"]
        Ruboclean::Runner.new(arguments).run!

        assert_equal fixture_file_path("00_input.yml").read,
                     Pathname.new(fixture_path).read
      end
    end
  end
end
