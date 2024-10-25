# frozen_string_literal: true

require "test_helper"

module Ruboclean
  class StreamWriterTest < BaseTest
    def test_writes_to_path
      Tempfile.create do |tmpfile|
        target_file_pathname = Pathname.new(tmpfile)
        Ruboclean::StreamWriter.new(target_file_pathname, "magnificent file output").write!

        assert_equal "magnificent file output", target_file_pathname.read
      end
    end

    def test_writes_to_stdout
      target_file_pathname = Pathname.new("STDOUT")

      assert_output("magnificent STDOUT output\n") do
        Ruboclean::StreamWriter.new(target_file_pathname, "magnificent STDOUT output").write!
      end
    end
  end
end
