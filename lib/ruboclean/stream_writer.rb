# frozen_string_literal: true

module Ruboclean
  # Orders the items within the groups alphabetically
  class StreamWriter
    def initialize(target_file_pathname, content)
      @target_file_pathname = target_file_pathname
      @content = content
    end

    def write!
      if stdout?
        puts content
      else
        target_file_pathname.write(content)
      end
    end

    private

    attr_reader :target_file_pathname, :content

    def stdout?
      target_file_pathname.basename.to_s == "STDOUT"
    end
  end
end
