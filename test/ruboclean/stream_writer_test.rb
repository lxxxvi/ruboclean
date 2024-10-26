# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class StreamWriterTest < BaseTest
    def test_writes_to_path
      Tempfile.create do |tempfile|
        pathname = Pathname.new(tempfile)

        cli_arguments = Ruboclean::CliArguments.new([pathname.to_s])
        options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

        Ruboclean::StreamWriter.new("magnificent file output", options: options).write!

        assert_equal "magnificent file output", pathname.read
      end
    end

    def test_writes_to_stdout_if_output_flag_is_stdout
      cli_arguments = Ruboclean::CliArguments.new(["--output=STDOUT"])
      options = Ruboclean::Runner::Options.new(cli_arguments: cli_arguments)

      assert_output("magnificent STDOUT output\n") do
        Ruboclean::StreamWriter.new("magnificent STDOUT output\n", options: options).write!
      end
    end
  end
end
